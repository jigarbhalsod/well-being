import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class PomodoroPage extends StatefulWidget {
  @override
  _PomodoroPageState createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  int _minutes = 25;
  int _seconds = 0;
  int _points = 120;
  bool _isRunning = false;
  Timer? _timer;
  bool _isPhoneFrozen = false;
  // Use a key for the dialog to prevent showing it multiple times
  final GlobalKey<State> _dialogKey = GlobalKey<State>();

  // Function to start the timer
  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _isPhoneFrozen = true;
    });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_minutes == 0 && _seconds == 0) {
        _stopTimer();
        _showFinishedDialog();
        return;
      } else if (_seconds == 0) {
        setState(() {
          _minutes--;
          _seconds = 59;
        });
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  // Function to stop the timer
  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _isRunning = false;
      _isPhoneFrozen = false;
    });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  // Function to show timer finished dialog
  void _showFinishedDialog() {
    // Use the global key to show the dialog only once
    if (_dialogKey.currentState != null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          key: _dialogKey, // Assign the global key to the dialog
          title: Text('Pomodoro Finished!'),
          content: Text('Time for a break!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _minutes = 25;
                  _seconds = 0;
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      // Reset the global key when the dialog is dismissed
      _dialogKey.currentState?.dispose();
    });
  }

  // Function to reset the timer
  void _resetTimer() {
    _stopTimer();
    setState(() {
      _minutes = 25;
      _seconds = 0;
      _isRunning = false;
    });
  }

  // Function to format the time
  String _formatTime(int minutes, int seconds) {
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    'Points: $_points',
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                Image.asset(
                  'assets/tomato.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                Text(
                  _formatTime(_minutes, _seconds),
                  style: TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _isRunning ? null : _startTimer,
                      child: Text(_isRunning ? 'Running' : 'Start'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isRunning ? Colors.grey : Colors.teal,
                        textStyle: TextStyle(fontSize: 20),
                        padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _isRunning ? _stopTimer : _resetTimer,
                      child: Text(_isRunning ? 'Stop' : 'Reset'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isRunning ? Colors.red : Colors.grey,
                        textStyle: TextStyle(fontSize: 20),
                        padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    _showSettingsDialog();
                  },
                  child: Text(
                    'Settings',
                    style: TextStyle(fontSize: 18.0, color: Colors.teal),
                  ),
                ),
              ],
            ),
          ),
          if (_isPhoneFrozen)
            GestureDetector(
              onTap: () {},
              child: Container(
                color: Colors.grey.withOpacity(0.8),
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Text(
                    "Timer is Running\nScreen is Locked\nDO NOT CLOSE APP",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        int tempMinutes = _minutes;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Settings'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Set Pomodoro Time (minutes):',
                      style: TextStyle(fontSize: 16)),
                  Slider(
                    value: tempMinutes.toDouble(),
                    min: 1,
                    max: 60,
                    divisions: 60,
                    label: tempMinutes.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        tempMinutes = value.round();
                      });
                    },
                  ),
                  Text('Selected Time: ${tempMinutes.round()} minutes',
                      style: TextStyle(fontSize: 14)),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _minutes = tempMinutes;
                      _seconds = 0;
                    });
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
  }
}

