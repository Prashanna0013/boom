import 'package:flutter/material.dart';

class SportsPage extends StatelessWidget {
  final List<Map<String, String>> exercises = [
    {'name': 'Walking', 'description': 'A simple walk for fitness.'},
    {'name': 'Running', 'description': 'Running to improve stamina.'},
    {'name': 'Swimming', 'description': 'Swimming for full-body workout.'},
    {'name': 'Cycling', 'description': 'Cycling to strengthen legs.'},
    {'name': 'Yoga', 'description': 'Yoga for flexibility and calm.'},
    {'name': 'Hiking', 'description': 'Hiking for endurance.'},
    {'name': 'Gym Workout', 'description': 'Strength training in the gym.'},
    {'name': 'Pilates', 'description': 'Core strengthening exercise.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises'),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(exercises[index]['name']!),
              subtitle: Text(exercises[index]['description']!),
              onTap: () {
                // Empty onTap function for now
              },
            ),
          );
        },
      ),
    );
  }
}
