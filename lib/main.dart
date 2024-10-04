import 'package:flutter/material.dart';

void main() {
  runApp(HealthDashboard());
}

class HealthDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Health'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Today's Data Card
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.orange[400],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Data",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Goal For Today: 5000 Steps',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Distance: 0.00 Km\nGoal Completion: 0%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Steps',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),

                // Grid section with tappable items
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Action for each grid button
                        print('Tapped on: $index');
                      },
                      child: _buildGridCard(
                        _getGridTitle(index),
                        _getGridValue(index),
                        _getGridIcon(index),
                        _getGridColor(index),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.0),

                // Horizontal Exercise Suggestions Section
                Container(
                  height: 150.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5, // Number of exercise suggestions
                    itemBuilder: (context, index) {
                      return _buildExerciseSuggestionCard(
                        'Exercise $index',
                        Icons.fitness_center,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.flash_on),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_run),
              label: 'Sports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.watch),
              label: 'Device',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),
    );
  }

  // Helper method to build each card in the grid view
  Widget _buildGridCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32.0),
            Spacer(),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build exercise suggestion cards
  Widget _buildExerciseSuggestionCard(String exerciseName, IconData icon) {
    return Container(
      width: 120.0,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue, size: 32.0),
            SizedBox(height: 8.0),
            Text(
              exerciseName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Methods to get grid details for each index
  String _getGridTitle(int index) {
    switch (index) {
      case 0:
        return 'Sports Record';
      case 1:
        return 'Calories';
      case 2:
        return 'Heart Rate';
      case 3:
        return 'Blood Oxygen';
      case 4:
        return 'Sleep';
      case 5:
        return 'Blood Pressure';
      default:
        return '';
    }
  }

  String _getGridValue(int index) {
    switch (index) {
      case 0:
        return '0m 0s';
      case 1:
        return '0 Kcal';
      case 2:
        return '-- bpm';
      case 3:
        return '-- %';
      case 4:
        return '10-04';
      case 5:
        return '--';
      default:
        return '';
    }
  }

  IconData _getGridIcon(int index) {
    switch (index) {
      case 0:
        return Icons.directions_run;
      case 1:
        return Icons.local_fire_department;
      case 2:
        return Icons.favorite;
      case 3:
        return Icons.opacity;
      case 4:
        return Icons.bedtime;
      case 5:
        return Icons.monitor_heart;
      default:
        return Icons.help_outline;
    }
  }

  Color _getGridColor(int index) {
    switch (index) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.amber;
      case 2:
        return Colors.red;
      case 3:
        return Colors.redAccent;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
