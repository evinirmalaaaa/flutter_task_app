import 'package:flutter/material.dart';
import 'package:flutter_task_app/config.dart';
import 'package:flutter_task_app/models/user_model.dart';
import 'package:flutter_task_app/providers/member_provider.dart';
import 'package:provider/provider.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Members',
          style: font,
        ),
        centerTitle: true,
      ),
      body: Consumer<MemberProvider>(
        builder: (context, value, child) {
          return Expanded(
            child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shrinkWrap: false,
                itemBuilder: (context, index) {
                  UserModel user = value.users[index];
                  return GestureDetector(
                      onTap: () {},
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.person_rounded,
                            size: 30,
                          ),
                        ),
                        title: Text(
                          user.name!,
                          style: font,
                        ),
                        subtitle: Text(
                          user.email!,
                          style: font,
                        ),
                      ));
                },
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                itemCount: value.users.length),
          );
        },
      ),
    );
  }
}
