import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartme/devicepage.dart';
import 'package:smartme/profilepage.dart';
import 'package:smartme/sportspage.dart'; // Import the intl package for date formatting

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // List of pages including the ProfilePage
  final List<Widget> _pages = [
    HealthDashboard(),
    SportsPage(),
    DevicePage(),
    ProfilePage(), // Navigate to the ProfilePage
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health'),
      ),
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Sports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.model_training_rounded),
            label: 'AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HealthDashboard extends StatelessWidget {
  final List<Map<String, dynamic>> healthData = [
    {
      'icon': Icons.directions_run,
      'title': 'Sports Record',
      'data': '0m 0s',
    },
    {
      'icon': Icons.local_fire_department,
      'title': 'Calories',
      'data': '0 Kcal',
      'target': 'Target: 300Kcal',
    },
    {
      'icon': Icons.favorite,
      'title': 'Heart Rate',
      'data': '-- bpm',
      'chartData': [
        50,
        60,
        70,
        80,
        90,
        80,
        70,
        60,
        50,
        60,
        70,
        80
      ], // Sample chart data
    },
    {
      'icon': Icons.water_drop,
      'title': 'Blood Oxygen',
      'data': '-- %',
    },
    {
      'icon': Icons.bedtime,
      'title': 'Sleep',
      'data': DateFormat('MM-dd HH:mm')
          .format(DateTime.now()), // Current date and time
    },
    {
      'icon': Icons.bloodtype,
      'title': 'Blood Pressure',
      'data': '80/120',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          color: Colors.orange,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today's Data",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Goal For Today: 5000 Steps",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Distance: 0.00Km",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Goal Completion: 0%",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: healthData.length,
            itemBuilder: (context, index) {
              return buildHealthCard(healthData[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget buildHealthCard(Map<String, dynamic> data) {
    return Card(
      child: InkWell(
        onTap: () {}, // Empty onPressed function
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                data['icon'],
                size: 40,
              ),
              SizedBox(height: 10),
              Text(
                data['title'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                data['data'],
                style: TextStyle(fontSize: 16),
              ),
              if (data['target'] != null)
                Text(
                  data['target'],
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
