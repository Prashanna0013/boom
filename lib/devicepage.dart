import 'package:flutter/material.dart';
import 'package:smartme/rlmodel.dart';

class DevicePage extends StatefulWidget {
  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  // Dropdown menu options for difficulty levels
  String? selectedDifficulty;
  List<String> difficultyLevels = ['Beginner', 'Intermediate', 'Expert'];

  // Dropdown menu options for types of exercises
  String? selectedExerciseType;
  List<String> exerciseTypes = ['Cardio', 'Full Body', 'Warmup'];

  // TensorFlow model service
  late TensorflowService _tensorflowService;
  String modelOutput = 'No output yet'; // Display model output
  List<int>? actions; // List to hold selected actions for each agent

  @override
  void initState() {
    super.initState();
    _tensorflowService = TensorflowService(); // Initialize TensorFlow service
  }

  // Function to run the model and update output
  Future<void> runModelWithCSV() async {
    // Check if both selections are made
    if (selectedDifficulty == null || selectedExerciseType == null) {
      setState(() {
        modelOutput = 'Please select both difficulty level and exercise type';
      });
      return;
    }

    // Load and extract input from the CSV file
    List<double> input =
        await _tensorflowService.extractInputFromCSV('assets/new_data (5).csv');

    // Run the model with the extracted input
    List<double> output = await _tensorflowService.runModel(input);

    // Assuming the output corresponds to probabilities or scores for exercises
    if (output.isNotEmpty) {
      // Get actions based on Q-values for the agents
      actions = await _tensorflowService.runSelections(output);

      // Prepare the result message
      String resultMessage = 'Selected actions for agents:\n';
      for (int i = 0; i < actions!.length; i++) {
        resultMessage += 'Agent ${i + 1}: Action ${actions![i]}\n';
      }

      // Update model output state
      setState(() {
        modelOutput = resultMessage; // Update output with action results
      });
    } else {
      setState(() {
        modelOutput = 'Failed to get valid output from the model';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Exercise Options'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Dropdown for Difficulty Level
          Text(
            'Select Difficulty Level',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          DropdownButton<String>(
            isExpanded: true,
            value: selectedDifficulty,
            hint: Text('Choose Difficulty Level'),
            items: difficultyLevels.map((String level) {
              return DropdownMenuItem<String>(
                value: level,
                child: Text(level),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedDifficulty = newValue;
              });
            },
          ),
          SizedBox(height: 30),

          // Dropdown for Type of Exercise
          Text(
            'Select Type of Exercise',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          DropdownButton<String>(
            isExpanded: true,
            value: selectedExerciseType,
            hint: Text('Choose Exercise Type'),
            items: exerciseTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedExerciseType = newValue;
              });
            },
          ),

          SizedBox(height: 30),

          // Display Selected Values
          if (selectedDifficulty != null && selectedExerciseType != null)
            Text(
              'Selected: $selectedDifficulty Level, $selectedExerciseType Exercise',
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),

          SizedBox(height: 30),

          // Button to run the model and show output
          TextButton(
            onPressed: () async {
              await runModelWithCSV(); // Run the model and update output
            },
            child: Text("Run Model"),
          ),

          SizedBox(height: 20),

          // Display Model Output
          Text(
            modelOutput,
            style: TextStyle(fontSize: 18, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
