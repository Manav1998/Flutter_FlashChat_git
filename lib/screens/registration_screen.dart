import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/helpers/custom_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String email;
  late String password;
  late String? error;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    error = null;
  }

  Future<void> registerUser() async {
    setState(() => showSpinner = true);
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushNamed(context, ChatScreen.id);
      setState(() => error = null);
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'weak-password') {
          error = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          error = 'The account already exists for that email.';
        }
      });
    } catch (e) {
      error = 'Something went wrong.';
    } finally {
      setState(() => showSpinner = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
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
                        )),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  CustomButton(
                    navigateTo: () async {
                      await registerUser();
                    },
                    buttonColor: Colors.blueAccent,
                    buttonText: 'Register',
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
