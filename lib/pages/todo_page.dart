import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final TextEditingController _controller = TextEditingController(); // manages user input

  // adds tasks to firestore
  void _addTask(String task) async {
    final user = FirebaseAuth.instance.currentUser;
    if (task.trim().isEmpty || user == null) return;

    await FirebaseFirestore.instance.collection('todos').add({
      'task': task.trim(),
      'timestamp': Timestamp.now(),
      'uid': user.uid,
    });

    _controller.clear();
  }

  // ui
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    //print('Current user UID: ${user?.uid}'); // just to make sure the uid matches on firestore

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
          // live firestore task list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('todos')
                  .where('uid', isEqualTo: user?.uid) // gets the task for specific user
                  //.orderBy('timestamp', descending: true) // this breaks my screen for some reason
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // shows if data is still loading
                }

                final docs = snapshot.data?.docs ?? [];

                return ListView.builder(
                  itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      try {
                        final data = doc.data() as Map<String, dynamic>; // gets doc field
                        final taskText = data['task'] ?? 'No task';
                        final timestamp = data['timestamp'] as Timestamp?;

                        if (timestamp == null) {
                          throw Exception("Missing timestamp"); // ensures timestamp is shown
                        }

                        // dismissible tile to delete tasks
                        return Dismissible(
                          key: Key(doc.id),
                          direction: DismissDirection.endToStart, // swipe left
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (_) {
                            FirebaseFirestore.instance.collection('todos').doc(doc.id).delete(); // also deletes task from firestore
                          },
                          child: ListTile(
                            leading: const Icon(Icons.check_box_outline_blank), // will make interactable later
                            title: Text(taskText),
                            subtitle: Text('Added: ${timestamp.toDate()}'), // timestamp
                          ),
                        );
                      } catch (e) { // if task can't be be read
                        return ListTile(
                          title: const Text('Error: could not load task'),
                          subtitle: Text(e.toString()),
                        );
                      }
                    }
                );
              },
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