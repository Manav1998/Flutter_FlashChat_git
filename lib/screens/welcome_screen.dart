import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/helpers/custom_button.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation textAnimation, backgroundAnimation, maintenaceAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 1, milliseconds: 10),
      vsync: this,
    );

    textAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.elasticOut,
    );
    backgroundAnimation = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white,
    ).animate(controller);
    maintenaceAnimation = ColorTween(
      end: Colors.blueAccent,
      begin: Colors.redAccent,
    ).animate(controller);

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundAnimation.value,
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Hero(
                        tag: 'logo',
                        child: SizedBox(
                          child: Image.asset('images/logo.png'),
                          height: textAnimation.value * 80,
                        ),
                      ),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey.shade600,
                        ),
                        child: AnimatedTextKit(
                          isRepeatingAnimation: false,
                          animatedTexts: [
                            TypewriterAnimatedText(
                              'Flash Chat',
                              speed: const Duration(milliseconds: 150),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  CustomButton(
                    navigateTo: () =>
                        Navigator.pushNamed(context, LoginScreen.id),
                    buttonColor: Colors.lightBlueAccent,
                    buttonText: 'Log In',
                  ),
                  CustomButton(
                    navigateTo: () =>
                        Navigator.pushNamed(context, RegistrationScreen.id),
                    buttonColor: Colors.blueAccent,
                    buttonText: 'Register',
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Maintenance scheduled for today. PLease come back later.\n Have a nice day!!',
                style: TextStyle(
                    color: maintenaceAnimation.value,
                    fontWeight: FontWeight.w500,
                    fontSize: 25.0,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const Scaffold(
            body: SpinKitRipple(
              color: Colors.blueAccent,
              size: 100.0,
            ),
          );
        },
      ),
    );
  }
}
