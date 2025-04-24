import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:health_wellness/screens/home_screen.dart'; // Import your home screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wellness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(), // Start with LoginPage
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate login delay.  In a real app, you'd authenticate here.
    Future.delayed(Duration(seconds: 1), () {
      setState(() => _isLoading = false);
      // After successful login, navigate to NameAgePage.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => NameAgePage()),
      );
    });
  }

  void _connectWithGoogle() {
    // Placeholder for Google Sign-In
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Google Sign-In not implemented yet')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Welcome Back',
                    style:
                    TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                _isLoading
                    ? SpinKitCircle(color: Colors.blue)
                    : ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _connectWithGoogle,
                  icon: Icon(Icons.g_mobiledata),
                  label: Text('Connect with Google'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NameAgePage extends StatefulWidget {
  @override
  _NameAgePageState createState() => _NameAgePageState();
}

class _NameAgePageState extends State<NameAgePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  int _age = 25;

  void _next() {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GenderPage(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          age: _age,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Name & Age")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            SizedBox(height: 16),
            Text("Age: $_age"),
            Slider(
              value: _age.toDouble(),
              min: 10,
              max: 100,
              divisions: 90,
              onChanged: (val) => setState(() => _age = val.round()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _next,
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GenderPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final int age;

  GenderPage({
    required this.firstName,
    required this.lastName,
    required this.age,
  });

  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  String? _gender;

  void _next() {
    if (_gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select your gender')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HeightWeightBMIPage(
          firstName: widget.firstName,
          lastName: widget.lastName,
          age: widget.age,
          gender: _gender!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Gender")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(border: OutlineInputBorder()),
              value: _gender,
              items: ['Male', 'Female', 'Other']
                  .map((g) => DropdownMenuItem(
                value: g,
                child: Text(g),
              ))
                  .toList(),
              onChanged: (val) => setState(() => _gender = val),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _next,
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HeightWeightBMIPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final int age;
  final String gender;

  HeightWeightBMIPage({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
  });

  @override
  _HeightWeightBMIPageState createState() => _HeightWeightBMIPageState();
}

class _HeightWeightBMIPageState extends State<HeightWeightBMIPage> {
  int _height = 170;
  int _weight = 70;
  double? _bmi;

  void _calculateBMI() {
    double heightInMeters = _height / 100;
    _bmi = _weight / (heightInMeters * heightInMeters);
  }

  void _next() {
    _calculateBMI();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GoalsPage(
          firstName: widget.firstName,
          bmi: _bmi ?? 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Height, Weight, BMI")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Height: $_height cm'),
            Slider(
              value: _height.toDouble(),
              min: 100,
              max: 250,
              divisions: 150,
              onChanged: (val) => setState(() => _height = val.round()),
            ),
            SizedBox(height: 16),
            Text('Weight: $_weight kg'),
            Slider(
              value: _weight.toDouble(),
              min: 30,
              max: 200,
              divisions: 170,
              onChanged: (val) => setState(() => _weight = val.round()),
            ),
            SizedBox(height: 16),
            if (_bmi != null)
              Text("BMI: ${_bmi!.toStringAsFixed(2)}"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _next,
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GoalsPage extends StatefulWidget {
  final String firstName;
  final double bmi;

  GoalsPage({required this.firstName, required this.bmi});

  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  List<String> _goals = [
    'Focus',
    'Meditation',
    'Weight Loss',
    'Muscle Gain',
    'Sleep Better',
    'Fitness',
  ];

  List<String> _selectedGoals = [];

  void _next() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Customizing the app according to your needs...'),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ),
          ),
    );

    Future.delayed(Duration(seconds: 2), () { // Changed to 2 seconds for faster transition
      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              HomePage(), // Navigate to the HomePage
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Goals")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _goals.map((goal) {
                bool isSelected = _selectedGoals.contains(goal);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected
                          ? _selectedGoals.remove(goal)
                          : _selectedGoals.add(goal);
                    });
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: isSelected ? Colors.blue : Colors
                        .grey[300],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        goal,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _selectedGoals.isEmpty
                  ? null
                  : _next, // disable button if no goals selected
              child: Text('Finish'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
