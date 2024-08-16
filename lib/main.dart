import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_task_app/models/user_model.dart';
import 'package:flutter_task_app/pages/login_screen.dart';
import 'package:flutter_task_app/pages/main_page.dart';
import 'package:flutter_task_app/pages/onboard_screen.dart';
import 'package:flutter_task_app/providers/member_provider.dart';
import 'package:flutter_task_app/providers/new_task_provider.dart';
import 'package:flutter_task_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyAH-EDHwtI2nAG3KpiMlLduQm5XfRYFOt4',
    appId: '1:463898515165:android:ed199a1f46ef3570a46d34',
    messagingSenderId: '',
    projectId: 'flutter-task-app-ae1d3',
  ));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    init();
  }

  bool loggedIn = false;
  UserModel? user;
  init() async {
    loggedIn = await Prefs.isLoggedIn();
    if (loggedIn) {
      user = await Prefs.getUser();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewTaskProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MemberProvider()),
      ],
      child: MaterialApp(
        title: 'Task List App',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: false,
        ),
        home: loggedIn
            ? user != null
                ? MainPage(user: user!)
                : const CircularProgressIndicator()
            : const OnboardingScreen(),
      ),
    );
  }
}
