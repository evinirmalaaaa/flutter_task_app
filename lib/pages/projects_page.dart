import 'package:flutter/material.dart';
import 'package:flutter_task_app/config.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Project', style: font,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Project',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
