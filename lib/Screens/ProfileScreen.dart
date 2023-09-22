import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:playandearnmoney/Screens/loginscreen.dart';
import 'package:playandearnmoney/Screens/signupscreen.dart';
import 'package:playandearnmoney/Screens/test.dart';
import 'package:playandearnmoney/Screens/test2.dart';
import 'package:playandearnmoney/config.dart';
import 'package:playandearnmoney/main.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: schemecolor),
        title: Text(
          'My Profile',
          style: TextStyle(color: schemecolor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
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
                sigmaX: 8,
                sigmaY: 8,
              ),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                    radius: 70,
                    backgroundColor: schemecolor,
                    child: Image.asset(
                      "assets/images/user.png",
                      color: Colors.white,
                    ).p8()),
                Text(
                  prefs.getString('username').toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),
                ).pOnly(left: 8, top: 8),
                Text(prefs.getString('phoneno').toString(),
                        style: const TextStyle(fontSize: 20))
                    .p4(),
                Column(
                  children: [
                    Profilebutton(
                        icon: Icons.settings, title: 'Setting', onTap: () {}),
                    Profilebutton(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        onTap: () {}),
                    Profilebutton(
                        icon: Icons.security,
                        title: 'Terms & Conditions',
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TokenScreen()));
                        }),
                    Profilebutton(
                        icon: Icons.phone,
                        title: 'Contact Us',
                        onTap: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Test()));
                        }),
                    Profilebutton(
                        icon: Icons.logout_outlined,
                        title: 'LogOut',
                        onTap: () async {
                          await prefs.setBool('login', false);
                          await prefs.setString('username', '');
                          await prefs.setString('phoneno', '');
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        }),
                  ],
                ).pOnly(top: 15),
              ],
            ).pOnly(top: 30),
          )
        ],
      ),
    );
  }
}

class Profilebutton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const Profilebutton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 37,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          primary: schemecolor,
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
      ),
    ).pOnly(top: 20);
  }
}
