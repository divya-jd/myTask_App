import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  final CollectionReference _tasksCollection = FirebaseFirestore.instance.collection('tasks');
  String _selectedPriority = 'Low';

  Future<void> _addTask() async {
    if (_taskController.text.isNotEmpty) {
      await _tasksCollection.add({
        'name': _taskController.text,
        'completed': false,
        'priority': _selectedPriority,
      });
      _taskController.clear();
    }
  }

  Future<void> _deleteTask(String id) async {
    await _tasksCollection.doc(id).delete();
  }

  Future<void> _toggleCompletion(String id, bool currentStatus) async {
    await _tasksCollection.doc(id).update({'completed': !currentStatus});
  }

  Future<void> _setPriority(String id, String newPriority) async {
    await _tasksCollection.doc(id).update({'priority': newPriority});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task List')),
      body: Column(
        children: [
          TextField(
            controller: _taskController,
            decoration: InputDecoration(labelText: 'Enter Task'),
          ),
          DropdownButton<String>(
            value: _selectedPriority,
            items: ['High', 'Medium', 'Low'].map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() { _selectedPriority = newValue!; });
            },
          ),
          ElevatedButton(onPressed: _addTask, child: Text('Add Task')),
          Expanded(
            child: StreamBuilder(
              stream: _tasksCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return ListTile(
                      title: Text(doc['name']),
                      subtitle: Text('Priority: ${doc['priority']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: doc['completed'],
                            onChanged: (_) => _toggleCompletion(doc.id, doc['completed']),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteTask(doc.id),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
