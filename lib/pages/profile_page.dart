import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_app/config.dart';
import 'package:flutter_task_app/models/user_model.dart';
import 'package:flutter_task_app/pages/login_screen.dart';
import 'package:flutter_task_app/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.deepOrange,
      action: SnackBarAction(
        label: 'Tutup',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    // prefs.remove('userPref');
    await Prefs.setLoggedIn(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(
          'Profile Page',
          style: font,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const CircleAvatar(
            radius: 50,
            child: Icon(
              Icons.person_rounded,
              size: 100,
            ),
          ),
          Text(
            widget.user.name!,
            style: font.copyWith(fontSize: 24),
          ),
          Text(
            widget.user.email!,
            style: font.copyWith(fontSize: 16, color: Colors.black26),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            onTap: () {},
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          ListTile(
              onTap: () {},
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              )),
          ListTile(
            onTap: () async {
              await logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            title: const Text('Logout'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          )
        ],
      ),
    );
  }
}
