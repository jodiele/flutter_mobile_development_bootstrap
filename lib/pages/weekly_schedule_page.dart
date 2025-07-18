import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeeklySchedulePage extends StatefulWidget {
  const WeeklySchedulePage({super.key});

  @override
  State<WeeklySchedulePage> createState() => _WeeklySchedulePageState();
}

class _WeeklySchedulePageState extends State<WeeklySchedulePage> {
  final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  // adds task to firestore
  void _addTask(String day, String taskText) async {
    final user = FirebaseAuth.instance.currentUser;
    if (taskText.trim().isEmpty || user == null) return;

    await FirebaseFirestore.instance.collection('weekly_tasks').add({ // saves to weekly_tasks collection in firestore
      'task': taskText.trim(),
      'day': day,
      'timestamp': Timestamp.now(),
      'uid': user.uid,
    });
  }

  // show dialog for inputting a task for a day
  void _showAddTaskDialog(String day) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task for $day'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter task'),
        ),
        actions: [
          TextButton( // cancels button
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'), // closes show dialog
          ),
          TextButton( // add task button
            onPressed: () {
              _addTask(day, controller.text);
              Navigator.pop(context);
            },
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }

  // weekly schedule ui
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Schedule'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder( // builds scrollable list of days
          itemCount: days.length,
          itemBuilder: (context, index) {
            final day = days[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ExpansionTile( // expands to show tasks for each day
                title: Text(day),
                children: [
                  StreamBuilder<QuerySnapshot>( // shows that day's tasks
                    stream: FirebaseFirestore.instance
                        .collection('weekly_tasks')
                        .where('uid', isEqualTo: user?.uid)
                        .where('day', isEqualTo: day)
                        .snapshots(),
                    builder: (context, snapshot) {
                      //if (snapshot.connectionState == ConnectionState.waiting) { // in case of data needing to be loaded
                        //return const Center(child: CircularProgressIndicator());
                      //}
                      final docs = snapshot.data?.docs ?? [];
                      if (docs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('No tasks yet'), // will show this if there are no tasks
                        );
                      }

                      // building list of tasks
                      return Column(
                        children: docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final task = data['task'] ?? 'No task';
                          final timestamp = data['timestamp'] as Timestamp?;

                          return Dismissible( // swipe to delete, swipe left
                            key: Key(doc.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) {
                              FirebaseFirestore.instance // would delete task from firestore as well
                                  .collection('weekly_tasks')
                                  .doc(doc.id)
                                  .delete();
                            },
                            child: ListTile(
                              leading: IconButton( // interactive check box
                                icon: Icon(
                                  data['done'] == true
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                ),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('weekly_tasks')
                                      .doc(doc.id)
                                      .update({'done': !(data['done'] == true)}); // updates in firestore
                                },
                              ),
                              title: Text(
                                task,
                                style: TextStyle(
                                  decoration: data['done'] == true
                                      ? TextDecoration.lineThrough // line through task when checked
                                      : TextDecoration.none,
                                  color: data['done'] == true ? Colors.grey : null,
                                ),
                              ),
                              subtitle: timestamp != null
                                  ? Text('Added: ${timestamp.toDate()}')
                                  : null,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  TextButton.icon( // add task button
                    onPressed: () => _showAddTaskDialog(day),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Task'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
