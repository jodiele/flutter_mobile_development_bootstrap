import 'package:flutter/material.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final List<String> _tasks = []; // list to store all tasks
  final TextEditingController _controller = TextEditingController(); // manages user input

  void _addTask(String task) {
    if (task.trim().isEmpty) return; // can't add blank tasks
    setState(() {
      _tasks.add(task.trim());
    });
    _controller.clear(); // clears input area after adding a task
  }

  // method for removing tasks
  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  // ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        centerTitle: true,
      ),

      // main screen
      body: Column(
        children: [
          // user input, adding + button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField( // expands it horizontally
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Add Task:',
                      border: InputBorder.none,
                    ),
                    onSubmitted: _addTask, // keying enter would also work to add
                  ),
                ),

                IconButton( // sits to the right of the text field
                  icon: const Icon(Icons.add),
                  onPressed: () => _addTask(_controller.text), // would also add if button is tapped
                ),
              ],
            ),
          ),

          const Divider(),

          // list of tasks underneath user input and divider ui
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) => Dismissible( // widget for swiping to delete tasks
                key: Key(_tasks[index]),
                direction: DismissDirection.endToStart, // swipe left to delete
                background: Container(
                  color: Colors.red, // changes background to red when swiped
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white), // trash can icon when swiping
                ),

                onDismissed: (_) => _removeTask(index),
                child: ListTile( // tasks are shown as a list
                  leading: const Icon(Icons.check_box_outline_blank), // checkbox icon, will make it interactable
                  title: Text(_tasks[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // clean up controller memory
    super.dispose();
  }
}