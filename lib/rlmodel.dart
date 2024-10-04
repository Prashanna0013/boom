import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class TensorflowService {
  late Interpreter _interpreter;
  bool _isModelLoaded = false;

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

  // Function to load CSV file from assets
  Future<List<Map<String, dynamic>>> loadCSV(String path) async {
    try {
      final csvData = await rootBundle.loadString(path);
      List<List<dynamic>> rowsAsListOfValues =
          const CsvToListConverter().convert(csvData);

      // Convert the CSV data into a list of maps
      List<Map<String, dynamic>> csvAsMapList = [];
      for (var row in rowsAsListOfValues.skip(1)) {
        csvAsMapList.add({
          'S.no': row[1],
          'Title': row[2],
          'Desc': row[3],
          'Type': row[4],
          'BodyPart': row[5],
          'Equipment': row[6],
          'Level': row[7],
        });
      }

      return csvAsMapList;
    } catch (e) {
      print('Error loading CSV file: $e');
      return [];
    }
  }

  // Function to run inference using the model
  Future<List<double>> runModel(List<double> input) async {
    if (!_isModelLoaded) {
      print('Model not yet loaded.');
      return [];
    }

    try {
      // Ensure input matches model's expected shape [1, 1, 5]
      var inputTensor = [input]; // Shape [1, 1, 5]
      var output = List.filled(2918, 0.0).reshape([1, 2918]);

      _interpreter.run(inputTensor, output);

      return output[0];
    } catch (e) {
      print('Error running model: $e');
      return [];
    }
  }

  // Function to extract input data from CSV for running the model
  Future<List<double>> extractInputFromCSV(String path) async {
    List<Map<String, dynamic>> exercises = await loadCSV(path);

    // Assuming you want to use the first row's data or specific columns for input
    if (exercises.isNotEmpty) {
      // Example: generating a random input using numeric data from the CSV
      var exercise = exercises[0]; // Change index as needed
      List<double> input = [
        double.tryParse(exercise['S.no'].toString()) ?? 0.0,
        double.tryParse(exercise['Title'].length.toString()) ?? 0.0,
        double.tryParse(exercise['Type'].length.toString()) ?? 0.0,
        double.tryParse(exercise['Level'].length.toString()) ?? 0.0,
        double.tryParse(exercise['BodyPart'].length.toString()) ?? 0.0,
      ];

      return input;
    }

    return [0, 0, 0, 0, 0]; // Default input if CSV is empty
  }
}
