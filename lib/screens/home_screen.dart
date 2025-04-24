import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'todo.dart'; // updated path
import 'loginpage.dart'; // you must create this screen

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<String> motivationalQuotes = [
    "Push yourself, because no one else is going to do it for you.",
    "Success is what comes after you stop making excuses.",
    "Every day is a second chance.",
    "Believe you can and you're halfway there.",
    "Start where you are. Use what you have. Do what you can.",
  ];

  late String selectedQuote;

  @override
  void initState() {
    super.initState();
    selectedQuote = (motivationalQuotes..shuffle()).first;
  }

  void _showMeditationOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [30, 60, 120, 300].map((seconds) {
              return ListTile(
                title: Text(
                  "${seconds ~/ 60 > 0 ? "${seconds ~/ 60} min" : "$seconds seconds"}",
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MeditationScreen(durationSeconds: seconds),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _onTabTapped(int index) {
    setState(() => currentIndex = index);
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ToDoHomePage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DashboardPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("How's your day going?"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Motivational Videos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  4,
                      (index) => Container(
                    width: 300,
                    margin: EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.shade200,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'http://img.youtube.com/vi/${[
                          'ZXsQAXx_ao0',
                          'mgmVOuLgFB0',
                          'wnHW6o8WMas',
                          'UNQhuFL6CWg'
                        ][index]}/0.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Center(child: Text('Video Unavailable')),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _optionCard(Icons.flag, 'Take a Challenge'),
                _optionCard(Icons.group, 'Join Community'),
                _optionCard(Icons.track_changes, 'Explore Goals'),
              ],
            ),
            SizedBox(height: 24),
            Text("Quote of the Day",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(selectedQuote,
                  style:
                  TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
            ),
            SizedBox(height: 24),
            Text("Feeling Anxious or Worried?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showMeditationOptions,
              child: Text("Meditate Now"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'To-Do'),
          BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety),
              label: 'Health & Well-being'),
        ],
      ),
    );
  }

  Widget _optionCard(IconData icon, String label) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('$label clicked!')));
          },
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.indigo.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: Colors.indigo),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

class MeditationScreen extends StatefulWidget {
  final int durationSeconds;
  const MeditationScreen({required this.durationSeconds});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  late int remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    remaining = widget.durationSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remaining == 0) {
        timer.cancel();
        Navigator.pop(context);
      } else {
        setState(() => remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Take Deep Breaths",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("${remaining}s",
                style: TextStyle(fontSize: 48, color: Colors.indigo)),
          ],
        ),
      ),
    );
  }
}
