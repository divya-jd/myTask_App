import 'package:flutter/material.dart';

enum SortBy { priority, dueDate, status }

class Task {
  final String name;
  final String priority; // e.g., 'high', 'medium', 'low'
  final DateTime dueDate;
  final bool isCompleted;

  Task({required this.name, required this.priority, required this.dueDate, required this.isCompleted});
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  SortBy _sortBy = SortBy.priority;
  List<Task> tasks = [
    Task(name: 'Task 1', priority: 'high', dueDate: DateTime.now().add(Duration(days: 1)), isCompleted: false),
    Task(name: 'Task 2', priority: 'medium', dueDate: DateTime.now().add(Duration(days: 3)), isCompleted: true),
    Task(name: 'Task 3', priority: 'low', dueDate: DateTime.now().add(Duration(days: 2)), isCompleted: false),
    // Add more tasks as needed
  ];

  void _sortTasks() {
    setState(() {
      tasks.sort((a, b) {
        switch (_sortBy) {
          case SortBy.priority:
            return _priorityValue(a.priority).compareTo(_priorityValue(b.priority));
          case SortBy.dueDate:
            return a.dueDate.compareTo(b.dueDate);
          case SortBy.status:
            return a.isCompleted == b.isCompleted
                ? 0
                : (a.isCompleted ? 1 : -1);
          default:
            return 0;
        }
      });
    });
  }

  int _priorityValue(String priority) {
    switch (priority) {
      case 'high':
        return 1;
      case 'medium':
        return 2;
      case 'low':
        return 3;
      default:
        return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          DropdownButton<SortBy>(
            value: _sortBy,
            items: SortBy.values.map((SortBy sort) {
              return DropdownMenuItem<SortBy>(
                value: sort,
                child: Text(sort.toString().split('.').last),
              );
            }).toList(),
            onChanged: (SortBy? newSort) {
              setState(() {
                _sortBy = newSort!;
              });
              _sortTasks(); // Call the sorting function
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.name),
            subtitle: Text('Priority: ${task.priority}, Due: ${task.dueDate.toLocal().toString().split(' ')[0]}'),
            trailing: Icon(
              task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: task.isCompleted ? Colors.green : Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
