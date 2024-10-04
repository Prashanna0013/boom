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

  @override
  void initState() {
    super.initState();
    _tensorflowService = TensorflowService(); // Initialize TensorFlow service
  }

  // Function to run the model and update output
  Future<void> runModelWithCSV() async {
    // Load and extract input from the CSV file
    List<double> input =
        await _tensorflowService.extractInputFromCSV('assets/new_data (5).csv');

    // Run the model with the extracted input
    List<double> output = await _tensorflowService.runModel(input);

    // Update model output state
    setState(() {
      modelOutput = 'Model Output: $output';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Exercise Options'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }
}
