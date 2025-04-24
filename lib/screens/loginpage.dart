import 'package:flutter/material.dart';
import 'Bmi_result.dart';
import 'pomodoro_page.dart';
import 'package:collection/collection.dart'; // Import for List equality

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health & Wellness App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _footsteps = 0; // Placeholder for footsteps data
  //List<double> _sleepQualities = [8.0, 7.5, 4.0, 6.5, 7.0];  //  keep last 7 days
  List<double> _sleepQualities = [];
  double _averageSleepHours = 0.0;
  String _sleepDescription = '';
  double _calories = 0; // Placeholder for calculated calories
  bool _waterIntake = false; // Placeholder for water intake status
  final int _maxSleepEntries = 9; // Maximum number of sleep entries to keep
  final TextEditingController _sleepInputController =
  TextEditingController(); // Controller for the TextField

  @override
  void dispose() {
    _sleepInputController.dispose(); // Dispose the controller
    super.dispose();
  }

  // Function to calculate calories (placeholder logic)
  void _calculateCalories() {
    // Example: Assume 100 calories burned per 2000 steps
    _calories = _footsteps / 2000 * 100;
  }

  // Function to add sleep quality and update average
  void _addSleepQuality(double quality) {
    setState(() {
      if (_sleepQualities.length >= _maxSleepEntries) {
        _sleepQualities.removeAt(0); // Remove the oldest entry
      }
      _sleepQualities.add(quality);
      _updateAverageSleep();
    });
  }

  // Function to update average sleep hours and description
  void _updateAverageSleep() {
    if (_sleepQualities.isNotEmpty) {
      _averageSleepHours =
          _sleepQualities.sum / _sleepQualities.length; // Calculate average
    } else {
      _averageSleepHours = 0.0;
    }
    // Determine sleep description
    if (_averageSleepHours >= 7) {
      _sleepDescription = 'Good';
    } else if (_averageSleepHours >= 5.5) {
      _sleepDescription = 'Average';
    } else {
      _sleepDescription = 'Poor';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BMICalculatorPage()),
                );
              },
              child: Text('BMI Calculator'),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 60)),
            ),
            SizedBox(height: 20),
            // Interactive Dashboard Elements
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Footsteps Display
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  width: 150,
                  child: Column(
                    children: [
                      Text(
                        'Footsteps',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('$_footsteps Steps'), // Display steps
                    ],
                  ),
                ),
                // Water Intake Checkbox
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Water Intake',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Checkbox(
                        value: _waterIntake,
                        onChanged: (value) {
                          setState(() {
                            _waterIntake = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Calories Display
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  width: 150,
                  child: Column(
                    children: [
                      Text(
                        'Calories',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${_calories.toStringAsFixed(2)} Cal'), // Display calories
                    ],
                  ),
                ),
                // Sleep Quality Input and Display
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  width: 150,
                  child: Column(
                    children: [
                      Text(
                        'Sleep Quality',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: _sleepInputController,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true), // Allow decimal input
                        decoration: InputDecoration(
                          labelText: 'Hours',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          // You could validate the input here if needed
                          if (double.tryParse(value) != null) {
                            double sleepTime = double.parse(value);
                            _addSleepQuality(sleepTime);
                          }
                        },
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Average: ${_averageSleepHours.toStringAsFixed(1)} Hours',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _sleepDescription,
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PomodoroPage()),
                );
              },
              child: Text('POMODORO MODE'),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 60)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Simulate fetching initial data
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _footsteps = 3500;
        _calculateCalories();
        _sleepQualities = [8.0, 7.5, 8.0, 6.5, 7.0]; // Initial sleep data
        _updateAverageSleep();
      });
    });
  }

  @override
  void didUpdateWidget(covariant DashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu")),
      body: Center(child: Text("Menu Page")),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(child: Text("Login Page")),
    );
  }
}

class FootstepsCaloriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Footsteps & Calories")),
      body: Center(
        child: Text(
          "This is the Footsteps & Calories Module",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}