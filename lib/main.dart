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

// Task data structure with isDone field
class Task {
  String title;
  DateTime dueDate;
  bool isDone;

  Task({required this.title, required this.dueDate, this.isDone = false});
}

class _TaskManagerHomeState extends State<TaskManagerHome> {
  List<Task> tasks = [];
  final TextEditingController taskController = TextEditingController();
  DateTime? selectedDate;

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

  void _addTask() {
    if (taskController.text.isNotEmpty && selectedDate != null) {
      setState(() {
        tasks.add(Task(title: taskController.text, dueDate: selectedDate!));
        taskController.clear();
        selectedDate = null;
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _toggleTaskDone(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Task input section
            Row(
              children: [
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

            // Task list display
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isDone,
                        onChanged: (_) => _toggleTaskDone(index),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: task.isDone ? Colors.grey : Colors.black,
                        ),
                      ),
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
