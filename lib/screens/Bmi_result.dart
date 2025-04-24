import 'package:flutter/material.dart';

class BMIResultPage extends StatelessWidget {
  final double bmi;

  BMIResultPage({required this.bmi});

  String getInterpretation(double bmi) {
    if (bmi >= 30.0) {
      return 'Obese';
    } else if (bmi >= 25.0) {
      return 'Overweight';
    } else if (bmi > 18.5) {
      return 'Normal';
    } else {
      return 'Underweight';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your BMI is:',
              style: TextStyle(fontSize: 22.0),
            ),
            SizedBox(height: 10.0),
            Text(
              bmi.toStringAsFixed(1),
              style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 20.0),
            Text(
              getInterpretation(bmi),
              style: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the BMI Calculator page
              },
              child: Text('Recalculate'),
            ),
          ],
        ),
      ),
    );
  }
}

class BMICalculatorPage extends StatefulWidget {
  @override
  _BMICalculatorPageState createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  String? gender;

  void calculateBMI() {
    double? height = double.tryParse(heightController.text);
    double? weight = double.tryParse(weightController.text);

    if (height != null && weight != null && height > 0 && weight > 0) {
      // Convert height from cm to meters
      double heightInMeters = height / 100;
      double bmi = weight / (heightInMeters * heightInMeters);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BMIResultPage(bmi: bmi),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid height and weight.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        gender = 'male';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: gender == 'male' ? Colors.teal.shade100 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.male, size: 50.0, color: Colors.teal),
                          SizedBox(height: 8.0),
                          Text('Male'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        gender = 'female';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: gender == 'female' ? Colors.pink.shade100 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.female, size: 50.0, color: Colors.pink),
                          SizedBox(height: 8.0),
                          Text('Female'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Height (in cm)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight (in kg)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: calculateBMI,
              child: Text('Calculate BMI'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
