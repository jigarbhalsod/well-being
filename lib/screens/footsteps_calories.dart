import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FootstepsCaloriesPage extends StatefulWidget {
  @override
  _FootstepsCaloriesPageState createState() => _FootstepsCaloriesPageState();
}

class _FootstepsCaloriesPageState extends State<FootstepsCaloriesPage> {
  int _steps = 0;
  double _caloriesBurned = 0;

  @override
  void initState() {
    super.initState();

    // Delay heavy work until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedSteps();
    });
  }

  // Load previously saved steps from local storage
  void _loadSavedSteps() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _steps = prefs.getInt('steps') ?? 0;
      _caloriesBurned = _steps * 0.04;
    });
  }

  // Save steps locally
  void _saveSteps() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('steps', _steps);
  }

  // Increment steps manually
  void _incrementSteps(int stepCount) {
    setState(() {
      _steps += stepCount;
      _caloriesBurned = _steps * 0.04;
    });
    _saveSteps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Footsteps & Calories")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Steps Walked: $_steps", style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text(
              "Calories Burned: ${_caloriesBurned.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _incrementSteps(100),
              child: Text("+100 Steps"),
            ),
            ElevatedButton(
              onPressed: () => _incrementSteps(500),
              child: Text("+500 Steps"),
            ),
            ElevatedButton(
              onPressed: () => _incrementSteps(1000),
              child: Text("+1000 Steps"),
            ),
          ],
        ),
      ),
    );
  }
}
