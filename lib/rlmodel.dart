import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'dart:typed_data';
import 'dart:math'; // For random selection

class TensorflowService {
  late Interpreter _interpreter;
  bool _isModelLoaded = false;
  final Random _random = Random();
  final int _numAgents = 5; // For 5 agents
  final double _epsilon = 0.1; // Exploration probability for epsilon-greedy
  final int _k = 2; // For top-k selection

  TensorflowService() {
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/beginner.tflite');
      _isModelLoaded = true;
      print('TensorFlow Lite Model Loaded Successfully.');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  // Function to load CSV file from assets and process input
  Future<List<double>> extractInputFromCSV(String path) async {
    try {
      final csvData = await rootBundle.loadString(path);
      List<List<dynamic>> rowsAsListOfValues =
          const CsvToListConverter().convert(csvData);

      // Ensure we have data (excluding the header)
      if (rowsAsListOfValues.length <= 1) {
        print('CSV file does not contain any data rows.');
        return List.filled(5, 0.0); // Default values
      }

      // Initialize a list to hold our numeric inputs
      List<double> input = [];

      // Example mapping of categorical to numerical
      Map<String, double> levelToNumeric = {
        'Beginner': 0.0,
        'Intermediate': 1.0,
        'Expert': 2.0
      };

      // Process each row to extract relevant numerical features
      for (var row in rowsAsListOfValues.skip(1)) {
        String level = row[6]?.toString() ?? ''; // Assuming Level is at index 6
        if (levelToNumeric.containsKey(level)) {
          input.add(levelToNumeric[level]!);
        } else {
          input.add(0.0); // Fallback for unknown levels
        }
      }

      // Ensure the input is of expected length
      if (input.length < 5) {
        print('Not enough valid inputs found, filling with zeros.');
        return List.filled(5, 0.0);
      }

      // Assuming we only need the first 5 values as input
      return input.sublist(0, 5);
    } catch (e) {
      print('Error loading or processing CSV file: $e');
      return List.filled(5, 0.0); // Default values in case of error
    }
  }

  void testCSVLoading() async {
    try {
      final csvData = await rootBundle.loadString('assets/new_data (5).csv');
      print('CSV Data:\n$csvData'); // Print the contents for verification
    } catch (e) {
      print('Error loading CSV file: $e');
    }
  }

  // Function to run inference using the model
  // Function to run inference using the model
  Future<List<double>> runModel(List<double> input) async {
    if (!_isModelLoaded) {
      print('Model not yet loaded.');
      return [];
    }

    try {
      var inputTensor = [input]; // Shape [1, input.length]
      print('Input Tensor: $inputTensor'); // Debug print for input tensor
      var output = List.filled(2918, 0.0).reshape([1, 2918]);

      _interpreter.run(inputTensor, output);
      //print('Model Output: $output'); // Debug print for output

      return output[0].sublist(0, _numAgents); // Return Q-values for 5 agents
    } catch (e) {
      print('Error running model: $e');
      return [];
    }
  }

  // Function to select the action using greedy selection
  int greedySelection(List<double> qValues) {
    return qValues
        .indexOf(qValues.reduce(max)); // Get action with the max Q-value
  }

  // Function for epsilon-greedy selection
  int epsilonGreedySelection(List<double> qValues) {
    // With probability epsilon, choose a random action
    if (_random.nextDouble() < _epsilon) {
      return _random.nextInt(qValues.length);
    }
    // Otherwise, choose the greedy action
    return greedySelection(qValues);
  }

  // Function for top-k selection
  int topKSelection(List<double> qValues) {
    // Sort Q-values along with their indices
    List<int> indices = List.generate(qValues.length, (i) => i);
    indices.sort(
        (a, b) => qValues[b].compareTo(qValues[a])); // Sort in descending order

    // Select randomly from the top-k actions
    int k = min(_k, qValues.length);
    return indices[
        _random.nextInt(k)]; // Randomly select from the top k actions
  }

  // Function to run selection for all 5 agents
  Future<List<int>> runSelections(List<double> qValues) async {
    List<int> actions = [];

    // For each agent, decide the action using epsilon-greedy or top-k selection
    for (int i = 0; i < _numAgents; i++) {
      double currentQValue = qValues[i];

      // Example: use epsilon-greedy for 3 agents and top-k for 2 agents
      if (i < 3) {
        // Epsilon-Greedy selection for first 3 agents
        actions.add(epsilonGreedySelection(qValues));
      } else {
        // Top-k selection for the last 2 agents
        actions.add(topKSelection(qValues));
      }
    }

    return actions;
  }
}
