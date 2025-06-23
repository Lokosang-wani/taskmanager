import 'package:flutter/material.dart';

void main() {
  runApp(const TaskManagerApp());
}

// Root of the app
class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      home: const TaskManagerHome(),
    );
  }
}

// Home screen with StatefulWidget to track tasks
class TaskManagerHome extends StatefulWidget {
  const TaskManagerHome({super.key});

  @override
  State<TaskManagerHome> createState() => _TaskManagerHomeState();
}

// Task data structure
class Task {
  String title;
  DateTime dueDate;

  Task({required this.title, required this.dueDate});
}

class _TaskManagerHomeState extends State<TaskManagerHome> {
  // List of tasks
  List<Task> tasks = [];

  // Controllers for input fields
  final TextEditingController taskController = TextEditingController();
  DateTime? selectedDate;

  // Show date picker and update selectedDate
  Future<void> _pickDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Add new task to the list
  void _addTask() {
    if (taskController.text.isNotEmpty && selectedDate != null) {
      setState(() {
        tasks.add(Task(title: taskController.text, dueDate: selectedDate!));
        taskController.clear();
        selectedDate = null;
      });
    }
  }

  // Delete a task by index
  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with custom style
      appBar: AppBar(
        title: const Text('Task Manager'),
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Task input field and add button
            Row(
              children: [
                // Expanded lets input field take remaining width
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task',
                      filled: true,
                      fillColor: Color(0xFFE3F2FD),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _pickDueDate(context),
                  child: const Icon(Icons.date_range),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _addTask, child: const Text('Add')),
              ],
            ),

            const SizedBox(height: 20),

            // Display task list
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(task.title),
                      subtitle: Text(
                        'Due: ${task.dueDate.toString().split(' ')[0]}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTask(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
