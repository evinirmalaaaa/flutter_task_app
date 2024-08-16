import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_app/config.dart';
import 'package:flutter_task_app/models/task_model.dart';
import 'package:flutter_task_app/models/user_model.dart';
import 'package:flutter_task_app/pages/task_screen.dart';
import 'package:flutter_task_app/pages/tasks_screen.dart';
import 'package:flutter_task_app/providers/new_task_provider.dart';
import 'package:flutter_task_app/widgets/project_item.dart';
import 'package:flutter_task_app/widgets/task_item.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.red,
        title: Row(
          children: [
            const CircleAvatar(
              child: Icon(
                Icons.person_rounded,
                size: 40,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Evening!',
                  style: font.copyWith(
                      fontSize: 12, color: Colors.black.withOpacity(.6)),
                ),
                Text(
                  widget.user.name!,
                  style: font.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            )
          ],
        ),
        actions: const [
          Icon(
            Icons.search,
            color: Colors.black,
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            Icons.notifications_outlined,
            color: Colors.black,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Project',
                        style: font.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '18 Tasks Pending',
                        style: font.copyWith(color: Colors.black38),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward_ios_rounded))
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 5),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: index == 0
                        ? const EdgeInsets.only(left: 20, right: 20)
                        : const EdgeInsets.only(right: 20),
                    child: const ProjectItem(),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Recent Tasks',
                        style: font.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' ${Provider.of<NewTaskProvider>(context, listen: true).tasks.where((element) => element.isCompleted == false).toList().length} Tasks Pending',
                        style: font.copyWith(color: Colors.black38),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TasksScreen(),
                          ));
                    },
                    icon: const Icon(Icons.arrow_forward_ios_rounded))
              ],
            ),
          ),
          Consumer<NewTaskProvider>(
            builder: (context, value, child) {
              print(value.tasks.length);
              return Expanded(
                child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateTaskPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MemberImage extends StatelessWidget {
  final double size;
  const MemberImage({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: size - 2,
          height: size - 2,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Colors.deepPurple
              // image: DecorationImage(
              //     image: AssetImage('assets/images/onboard/Image-0.png'),
              //     fit: BoxFit.fill),
              ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
