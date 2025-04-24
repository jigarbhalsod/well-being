import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Your ToDoModel class (or any model class)
class ToDoModel extends ChangeNotifier {
  final List<String> _tasks = [];

  List<String> get tasks => _tasks;

  void addTask(String task) {
    _tasks.add(task);
    notifyListeners(); // Important:  Notify listeners of changes!
  }

  // Example of removing
  void removeTask(int index){
    _tasks.removeAt(index);
    notifyListeners();
  }
}

// Your ToDoHomePage widget
class ToDoHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the ToDoModel using context.watch or context.read
    final toDoModel = context.watch<ToDoModel>(); // Use context.watch for rebuilds on changes
    //final toDoModel = context.read<ToDoModel>(); //use context.read if you don't want to rebuild.

    return Scaffold(
      appBar: AppBar(title: Text('To Do List')),
      body: ListView.builder(
        itemCount: toDoModel.tasks.length,
        itemBuilder: (context, index) {
          final task = toDoModel.tasks[index];
          return ListTile(
            title: Text(task),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                toDoModel.removeTask(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show a dialog to add a new task
          showDialog(
            context: context,
            builder: (context) {
              String newTask = ''; //local variable to hold new task
              return AlertDialog(
                title: Text('Add New Task'),
                content: TextField(
                  onChanged: (value) {
                    newTask = value;
                  },
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
                      if (newTask.isNotEmpty) {
                        toDoModel.addTask(newTask);
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// Your main.dart file
void main() {
  runApp(
    // Wrap your entire app with a Provider (or MultiProvider)
    ChangeNotifierProvider( // Use ChangeNotifierProvider for ChangeNotifier models
      create: (context) => ToDoModel(),
      child: MaterialApp(
        title: 'To Do App',
        home: ToDoHomePage(),
      ),
    ),
  );
}
