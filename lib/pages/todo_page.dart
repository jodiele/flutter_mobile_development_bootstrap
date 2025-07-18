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

  // adds new task to firestore
  void _addTask(String task) async {
    final user = FirebaseAuth.instance.currentUser;
    if (task.trim().isEmpty || user == null) return;

    await FirebaseFirestore.instance.collection('todos').add({
      'task': task.trim(),
      'timestamp': Timestamp.now(),
      'uid': user.uid,
      'done': false, // default is unchecked
    });

    _controller.clear();
  }

  // toggles if task is done
  void _toggleDone(String docId, bool currentState) {
    FirebaseFirestore.instance.collection('todos').doc(docId).update({
      'done': !currentState, // lets firebase know if task is done
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // input field and + button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Add Task:',
                      border: InputBorder.none,
                    ),
                    onSubmitted: _addTask, // can add task with enter key
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addTask(_controller.text), // can add task with + key
                ),
              ],
            ),
          ),

          const Divider(),

          // live task list from firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('todos')
                  .where('uid', isEqualTo: user?.uid) // fetch tasks from current user
                  .snapshots(),
              builder: (context, snapshot) {
                //if (snapshot.connectionState == ConnectionState.waiting) {
                  //return const Center(child: CircularProgressIndicator()); // will show if loading data
                //}

                final docs = snapshot.data?.docs ?? [];

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];

                    // extracting data from firestore for ui
                    try {
                      final data = doc.data() as Map<String, dynamic>;
                      final taskText = data['task'] ?? 'No task';
                      final timestamp = data['timestamp'] as Timestamp?;
                      final done = data['done'] as bool? ?? false;

                      if (timestamp == null) {
                        throw Exception("Missing timestamp");
                      }

                      // deleting tasks
                      return Dismissible(
                        key: Key(doc.id),
                        direction: DismissDirection.endToStart, // swipe left to delete
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          FirebaseFirestore.instance
                              .collection('todos')
                              .doc(doc.id)
                              .delete(); // delete from firestore
                        },

                        // checkbox and timestamp
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              done
                                  ? Icons.check_box // completed
                                  : Icons.check_box_outline_blank, // not completed
                              color: done ? Colors.grey : null,
                            ),
                            onPressed: () => _toggleDone(doc.id, done), // will toggle between if pressed
                          ),
                          title: Text(
                            taskText,
                            style: TextStyle(
                              decoration:
                              done ? TextDecoration.lineThrough : null, // line is crossed out when checked box
                              color: done ? Colors.grey : null,
                            ),
                          ),
                          subtitle:
                          Text('Added: ${timestamp.toDate().toLocal()}'),
                        ),
                      );
                    } catch (e) {
                      return ListTile(
                        title: const Text('Error loading task'),
                        subtitle: Text(e.toString()),
                      );
                    }
                  },
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
    _controller.dispose(); // clean up memory
    super.dispose();
  }
}