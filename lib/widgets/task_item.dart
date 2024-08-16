import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task_app/config.dart';
import 'package:flutter_task_app/models/task_model.dart';
import 'package:flutter_task_app/pages/home_screen.dart';
import 'package:flutter_task_app/providers/new_task_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  const TaskItem({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(2, 2),
              blurRadius: 3,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.name,
                        style: font.copyWith(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        task.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: font.copyWith(color: Colors.black38),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (bool? value) {
                    Provider.of<NewTaskProvider>(context, listen: false)
                        .toggleTaskCompletion(task.id!, value!);
                  },
                ),
              ],
            ),
            const Divider(
              thickness: 3,
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                          'assets/images/bottom_navbar/calendar.svg'),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        DateFormat('E, d MMM y').format(task.endDate),
                        style:
                            font.copyWith(fontSize: 12, color: Colors.black45),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: task.members.length > 2 ? 70 : 50,
                  child: Stack(
                    children: [
                      if (task.members.length > 2)
                        ...task.members
                            .sublist(task.members.length - 2)
                            .asMap()
                            .entries
                            .map(
                          (e) {
                            return Positioned(
                                left: e.key * 15,
                                child: const MemberImage(
                                  size: 30,
                                ));
                          },
                        ),
                      if (task.members.length <= 2)
                        ...task.members.asMap().entries.map(
                              (e) => Positioned(
                                left: e.key * 15,
                                child: const MemberImage(
                                  size: 30,
                                ),
                              ),
                            ),
                      if (task.members.length > 2)
                        Positioned(
                            left: 30,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Colors.deepPurple,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                  child: Text(
                                // '+2',
                                '+${(task.members.length - 2).toString()}',
                                style: font.copyWith(
                                    fontSize: 14, color: Colors.white),
                              )),
                            )),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
