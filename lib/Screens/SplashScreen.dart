import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:playandearnmoney/Screens/Homepage.dart';
import 'package:playandearnmoney/Screens/loginscreen.dart';
import 'package:playandearnmoney/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    timer();
    super.initState();
  }

  void timer() async {
    await Future.delayed(const Duration(seconds: 4)).then((value) {
      if (mounted) {
        final route =
            prefs.getBool('login') == false || prefs.getBool('login') == null
                ? MaterialPageRoute(builder: (context) => LoginPage())
                : MaterialPageRoute(builder: (context) => const HomeScreen());

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                route.builder(context),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              final tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          // Background image widget
          Positioned.fill(
            child: Image.asset(
              "assets/images/bgpic.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // Gaussian blur effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 7,
                sigmaY: 7,
              ),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          ),
          // Content in the center
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.1),
              Lottie.asset(
                "assets/animations/coinsanimation.json",
                width: width,
                //fit: BoxFit.cover,
              ),
              const Text(
                'Money\nArena',
                style: TextStyle(
                  fontFamily: 'myfont',
                  fontWeight: FontWeight.bold,
                  fontSize: 46,
                ),
              ),
              const Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Powered By Faizan & Aslam',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'myfont2',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
