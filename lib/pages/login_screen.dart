import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task_app/config.dart';
import 'package:flutter_task_app/models/user_model.dart';
import 'package:flutter_task_app/pages/main_page.dart';
import 'package:flutter_task_app/pages/register_screen.dart';
import 'package:flutter_task_app/prefs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print(userCredential.user!.uid);
      print(userCredential.user!.email);
      UserModel data = await FirebaseFirestore.instance
          .collection('newUsers')
          .where('email', isEqualTo: userCredential.user!.email!)
          .get()
          .then((querySnapshot) =>
              UserModel.fromDocument(querySnapshot.docs.first));
      // UserModel data = await FirebaseFirestore.instance
      //     .collection('newUsers')
      //     .doc(userCredential.user!.uid)
      //     .get()
      //     .then(
      //   (value) {
      //     return UserModel.fromDocument(value);
      //   },
      // );

      await Prefs.setUser(data);
      await Prefs.setLoggedIn(true);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(
            user: data,
          ),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else if (e.code == 'invalid-credential') {
        message = 'email atau password tidak sesuai';
      } else {
        message = e.code;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          style: font,
        ),
      ));
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Masukkan email yang valid';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    return null;
  }

  bool visiblePassword = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        emailFocus.unfocus();
        passwordFocus.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            emailFocus.unfocus();
            passwordFocus.unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text('Sign In',
                      style: font.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.deepPurple)),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    style: font,
                    focusNode: emailFocus,
                    controller: _emailController,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      labelText: 'Email',
                      hintText: 'Masukkan Email Anda',
                      labelStyle: font,
                      hintStyle: font,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    focusNode: passwordFocus,
                    style: font,
                    controller: _passwordController,
                    validator: _validatePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                          onPressed: () => setState(
                              () => visiblePassword = !visiblePassword),
                          icon: !visiblePassword
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)),
                      labelText: 'Password',
                      hintText: 'Masukkan Password',
                      labelStyle: font,
                      hintStyle: font,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    obscureText: !visiblePassword,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot password?',
                      style: font.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              emailFocus.unfocus();
                              passwordFocus.unfocus();
                              if (_formKey.currentState!.validate()) {
                                _login();
                              }
                            },
                            child: Text(
                              'Login',
                              style: font,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        'Don\'t have an account?',
                        style: font,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: font,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
