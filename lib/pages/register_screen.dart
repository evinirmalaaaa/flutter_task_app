import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task_app/config.dart';
import 'package:flutter_task_app/models/user_model.dart';
import 'package:flutter_task_app/pages/login_screen.dart';
import 'package:flutter_task_app/pages/main_page.dart';
import 'package:flutter_task_app/prefs.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _reTypePasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final reTypePasswordFocus = FocusNode();
  void _register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      final user = UserModel(
          id: userCredential.user!.uid,
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());
      await firebaseFirestore
          .collection('newUsers')
          .doc(userCredential.user!.uid)
          .set(user.toMap());
      await Prefs.setLoggedIn(true);
      await Prefs.setUser(user);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(
            user: user,
          ),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email ini sudah terdaftar. Gunakan email lain.';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        case 'operation-not-allowed':
          message = 'Registrasi dengan email dan kata sandi belum diaktifkan.';
          break;
        case 'weak-password':
          message =
              'Kata sandi terlalu lemah. Gunakan kombinasi yang lebih kuat.';
          break;
        case 'missing-email':
          message = 'Silakan masukkan email Anda.';
          break;
        case 'missing-password':
          message = 'Silakan masukkan kata sandi Anda.';
          break;
        default:
          message = 'Terjadi kesalahan. Coba lagi.';
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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    return null;
  }

  String? _validateRetypePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Retype Password tidak boleh kosong';
    }
    if (value != _passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  bool visiblePassword = false;
  bool visibleReTypePassword = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        passwordFocus.unfocus();
        emailFocus.unfocus();
        nameFocus.unfocus();
        reTypePasswordFocus.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text('Register',
                    style: font.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.deepPurple)),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  focusNode: nameFocus,
                  keyboardType: TextInputType.name,
                  style: font,
                  controller: _nameController,
                  validator: _validateName,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    labelText: 'Nama',
                    labelStyle: font,
                    hintText: 'Masukkan Nama Anda',
                    hintStyle: font,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  focusNode: emailFocus,
                  controller: _emailController,
                  validator: _validateEmail,
                  style: font,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    labelText: 'Email',
                    labelStyle: font,
                    hintStyle: font,
                    hintText: 'Masukkan Email Anda',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  focusNode: passwordFocus,
                  controller: _passwordController,
                  style: font,
                  validator: _validatePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan Password Anda',
                    labelStyle: font,
                    hintStyle: font,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() => visiblePassword = !visiblePassword),
                        icon: visiblePassword
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  obscureText: !visiblePassword,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  focusNode: reTypePasswordFocus,
                  controller: _reTypePasswordController,
                  style: font,
                  validator: _validateRetypePassword,
                  decoration: InputDecoration(
                    labelText: 'ReType Password',
                    hintText: 'Masukkan Kembali Password Anda',
                    labelStyle: font,
                    hintStyle: font,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () => setState(
                          () => visibleReTypePassword = !visibleReTypePassword),
                      icon: visibleReTypePassword
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  obscureText: !visibleReTypePassword,
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            nameFocus.unfocus();
                            passwordFocus.unfocus();
                            reTypePasswordFocus.unfocus();
                            if (_formKey.currentState!.validate()) {
                              _register();
                            }
                          },
                          child: Text(
                            'Sign Up',
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
                      'Already have an account?',
                      style: font,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: font,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                // ElevatedButton(
                //     onPressed: () async {
                //       for (var element in dummyUsers) {
                //         UserCredential userCredential =
                //             await _auth.createUserWithEmailAndPassword(
                //           email: element.email!,
                //           password: element.password!,
                //         );
                //         FirebaseFirestore firebaseFirestore =
                //             FirebaseFirestore.instance;

                //         final user = UserModel(
                //             id: userCredential.user!.uid,
                //             email: element.email,
                //             password: element.password,
                //             name: element.name,
                //             createdAt: DateTime.now(),
                //             updatedAt: DateTime.now());
                //         await firebaseFirestore
                //             .collection('newUsers')
                //             .doc(userCredential.user!.uid)
                //             .set(user.toMap());
                //       }
                //     },
                //     child: const Text('Dummy Users'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<UserModel> dummyUsers = [
  UserModel(
    email: 'user1@gmail.com',
    name: 'User1',
    password: 'password',
  ),
  UserModel(
    email: 'user2@gmail.com',
    name: 'User2',
    password: 'password',
  ),
  UserModel(
    email: 'user3@gmail.com',
    name: 'User3',
    password: 'password',
  ),
  UserModel(
    email: 'user4@gmail.com',
    name: 'User4',
    password: 'password',
  ),
  UserModel(
    email: 'user5@gmail.com',
    name: 'User5',
    password: 'password',
  ),
  UserModel(
    email: 'user6@gmail.com',
    name: 'User6',
    password: 'password',
  ),
  UserModel(
    email: 'user7@gmail.com',
    name: 'User7',
    password: 'password',
  ),
  UserModel(
    email: 'user8@gmail.com',
    name: 'User8',
    password: 'password',
  ),
];
