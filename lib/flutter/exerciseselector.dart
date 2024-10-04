import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:smartme/rlmodel.dart';
// Assuming this file contains the TensorflowService class

class ExerciseSelector extends StatefulWidget {
  @override
  _ExerciseSelectorState createState() => _ExerciseSelectorState();
}

class _ExerciseSelectorState extends State<ExerciseSelector> {
  final TensorflowService tensorflowService = TensorflowService();

  Future<List<Map<String, dynamic>>> loadCSV(String path) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Exercise Selector'),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: loadCSV('assets/new_data (5).csv'),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            List<Map<String, dynamic>> exercises = snapshot.data!;
            return ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                var exercise = exercises[index];
                return ListTile(
                  title: Text(exercise['Title']),
                  subtitle: Text(exercise['Desc']),
                  onTap: () async {
                    // Randomly generate input for the model
                    List<double> input = List.generate(
                        5, (index) => Random().nextDouble() * 1000);

                    // Run the TensorFlow model with the generated input
                    List<double> output =
                        await tensorflowService.runModel(input);

                    // Show a dialog or handle the output as needed
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Model Output'),
                          content: Text(output.toString()),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
