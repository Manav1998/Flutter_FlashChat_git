import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/helpers/custom_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  late String? error;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    error = null;
  }

  Future<void> loginUser() async {
    setState(() => showSpinner = true);
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushNamed(context, ChatScreen.id);
      setState(() => error = null);
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          error = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          error = 'Wrong password provided for that user.';
        }
      });
    } catch (e) {
      error = 'Something went wrong';
    } finally {
      setState(() => showSpinner = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    onChanged: (value) {
                      email = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email',
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password',
                      errorText: error,
                      errorStyle: const TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  CustomButton(
                    navigateTo: () async {
                      await loginUser();
                    },
                    buttonColor: Colors.lightBlueAccent,
                    buttonText: 'Log In',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
