import 'package:flutter/material.dart';

class WeeklySchedulePage extends StatefulWidget {
  const WeeklySchedulePage({super.key});

  @override
  State<WeeklySchedulePage> createState() => _WeeklySchedulePageState();
}

class _WeeklySchedulePageState extends State<WeeklySchedulePage> {
  final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  // stores list of tasks for each day
  final Map<String, List<String>> _tasks = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
  };

  // adding a task, with showdialog
  void _addTask(String day) {
    String newTask = '';

    // popup to add a task when clicked
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task for $day'),
        content: TextField(
          autofocus: true,
          onChanged: (value) {
            newTask = value; // updates with user input
          },
          decoration: const InputDecoration(hintText: 'Enter task'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // cancels, closes dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (newTask.isNotEmpty) { // add it to task list
                setState(() {
                  _tasks[day]!.add(newTask);
                });
              }
              Navigator.pop(context); // closes dialog after adding task
            },
            child: const Text('Add task'),
          ),
        ],
      ),
    );
  }

  // ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Schedule'),
        centerTitle: true,
      ),

      // main screen
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        // creates cards and displays each day of the week
        child: ListView.builder(
          itemCount: days.length, // 5
          itemBuilder: (context, index) {
            final day = days[index]; // current day
            final dayTasks = _tasks[day]!; // task list on that day

            // has expandable section
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ExpansionTile( // kind of like a drop down, expand/collapse section
                title: Text(day),
                children: [
                  // displays the task as a list
                  for (var task in dayTasks)
                    ListTile(
                      title: Text(task),
                      leading: const Icon(Icons.check_box_outline_blank), // icon for checking, will edit this later to change when clicked
                    ),


                  TextButton.icon(
                    onPressed: () => _addTask(day),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Task'),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}