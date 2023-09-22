// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:playandearnmoney/Screens/ProfileScreen.dart';
import 'package:http/http.dart' as http;
import 'package:playandearnmoney/Screens/scratchscree.dart';
import 'package:playandearnmoney/Screens/spinningscreen.dart';
import 'package:playandearnmoney/Screens/walletscreen.dart';
import 'package:playandearnmoney/config.dart';
import 'package:playandearnmoney/main.dart';
import 'package:playandearnmoney/widgets/Getgiftdialogbox.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  StreamController<List<Map<String, dynamic>>> _dataStreamController =
      StreamController<List<Map<String, dynamic>>>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

// Dispose the StreamController when it's no longer needed
  @override
  void dispose() {
    _dataStreamController.close();
    super.dispose();
  }

  void fetchData() async {
    while (true) {
      try {
        // Fetch data from the API
        Response response = await http.get(Uri.parse(
            'https://faizanabid007.000webhostapp.com/Api/getDashboard.php?userid=${prefs.getString('phoneno')}'));
        List<dynamic> jsonData = jsonDecode(response.body);
        List<Map<String, dynamic>> newData =
            List<Map<String, dynamic>>.from(jsonData);

        // Add the new data to the stream
        _dataStreamController.add(newData);

        // Delay before fetching the next update
        await Future.delayed(Duration(seconds: 5));
      } catch (e) {
        // Handle any errors
        print('Error fetching data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
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
              sigmaX: 7,
              sigmaY: 7,
            ),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
        ),
        StreamBuilder<List<Map<String, dynamic>>>(
            stream: _dataStreamController.stream,
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                // Data is available, update the UI
                List<Map<String, dynamic>> data = snapshot.data!;
                Map<String, dynamic> firstItem = data.first;
                String mainCaption1 = firstItem['s_MainCaption1'];
                String mainCaption2 = firstItem['s_MarqueeText'];
                String mainCaption3 = firstItem['s_MainCaption2'];
                String marqeetext = firstItem['s_MainCaption3'];
                int coins = firstItem['iCoins'];

                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ProfileScreen()));
                                      },
                                      icon: Icon(
                                        Icons.person,
                                        color: schemecolor,
                                        size: 29,
                                      )),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${prefs.getString('username')}',
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 13),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons
                                                .money_dollar_circle_fill,
                                            size: 14,
                                            color: goldencolor,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            NumberFormat("#,##0", "en_US")
                                                .format(coins),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WalletScreen(
                                                  coinss: coins,
                                                )));
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.wallet,
                                    color: schemecolor,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.notifications,
                                    color: schemecolor,
                                    size: 29,
                                  ))
                            ],
                          ),
                        ).pOnly(left: 5, right: 5, bottom: 10),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: schemecolor,
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: schemecolor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.4),
                                        spreadRadius: 4,
                                        blurRadius: 20,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Lottie.asset("assets/animations/play.json",
                              //     fit: BoxFit.cover, height: 100, width: 120),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                width: 110,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: goldencolor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.yellow.withOpacity(0.4),
                                      spreadRadius: 4,
                                      blurRadius: 20,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ScratchScreen(),
                                        ));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.play_circle_filled,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                      const SizedBox(width: 8.0),
                                      const Text(
                                        'Play',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ).p4(),
                                ),
                              ).pOnly(bottom: 10),
                              Positioned(
                                top: 20,
                                left: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mainCaption1,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (height + width) / 50,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      mainCaption2,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (height + width) / 50,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons
                                              .money_dollar_circle_fill,
                                          size: (height + width) / 50,
                                          color: goldencolor,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          mainCaption3,
                                          style: TextStyle(
                                              letterSpacing: 1,
                                              color: Colors.white,
                                              fontSize: (height + width) / 40,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Lottie.asset(
                                    "assets/animations/scratch.json",
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 120),
                              ),
                            ],
                          ),
                        ),
                        Container(
                                height: (height + width) / 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: goldencolor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Marquee(
                                  text: marqeetext,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: (height + width) / 80,
                                      color: const Color.fromARGB(
                                          255, 255, 17, 0)),
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  blankSpace: 20.0,
                                  velocity: 100.0,
                                  pauseAfterRound: const Duration(seconds: 1),
                                  accelerationDuration:
                                      const Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration:
                                      const Duration(milliseconds: 1000),
                                  decelerationCurve: Curves.bounceIn,
                                ).pOnly(top: 6))
                            .p4(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: SizedBox(
                              height: 200,
                              width: 150,
                              child: Stack(
                                children: [
                                  const SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  const Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      height: 100,
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 2,
                                      )),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 20,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const DailyRewardsScreen(),
                                            ));
                                      },
                                      child: Column(
                                        children: [
                                          Lottie.asset(
                                              "assets/animations/treasurebox.json",
                                              fit: BoxFit.fitHeight,
                                              height: 140,
                                              width: 140),
                                          Text(
                                            'Daily Reward',
                                            style: TextStyle(
                                              fontSize: (height + width) / 80,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            Expanded(
                                child: SizedBox(
                              height: 200,
                              width: 150,
                              child: Stack(
                                children: [
                                  const SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  const Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      height: 100,
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 2,
                                      )),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 20,
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const CustomDialogBox();
                                          },
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Lottie.asset(
                                              "assets/animations/giftbox.json",
                                              fit: BoxFit.cover,
                                              height: 140,
                                              width: 140),
                                          Text(
                                            'Get Gifts',
                                            style: TextStyle(
                                              fontSize: (height + width) / 80,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ).pOnly(top: 6),
                      ],
                    ).p16(),
                  ),
                ); // Display a loading indicator while waiting for the response.
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                // Access the API response data and display it
                return Center(
                  child: CircularProgressIndicator(
                    color: schemecolor,
                    strokeWidth: 2,
                  ),
                );
              }
            })
      ],
    ));
  }
}
