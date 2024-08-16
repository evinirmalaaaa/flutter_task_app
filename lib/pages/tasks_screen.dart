import 'package:flutter/material.dart';
import 'package:flutter_task_app/config.dart';
import 'package:flutter_task_app/models/task_model.dart';
import 'package:flutter_task_app/pages/task_screen.dart';
import 'package:flutter_task_app/providers/new_task_provider.dart';
import 'package:flutter_task_app/widgets/task_item.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Tasks',
          style: font,
        ),
        centerTitle: true,
      ),
      body: Consumer<NewTaskProvider>(
        builder: (context, value, child) {
          return Expanded(
            child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shrinkWrap: false,
                itemBuilder: (context, index) {
                  TaskModel task = value.tasks[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTaskPage(
                            task: task,
                          ),
                        ),
                      );
                    },
                    child: TaskItem(
                      task: task,
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                itemCount: value.tasks.length),
          );
        },
      ),
    );
  }
}
