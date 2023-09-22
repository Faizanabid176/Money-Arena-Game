import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:playandearnmoney/config.dart';
import 'package:playandearnmoney/main.dart';
import 'package:scratcher/scratcher.dart';
import 'package:velocity_x/velocity_x.dart';

class ScratchScreen extends StatefulWidget {
  const ScratchScreen({Key? key}) : super(key: key);

  @override
  State<ScratchScreen> createState() => _ScratchScreenState();
}

class _ScratchScreenState extends State<ScratchScreen> {
  double scratchPercentage = 0.0;
  bool isScratchCompleted = false;
  late final GlobalKey<ScratcherState> _scratcherKey;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _scratcherKey = GlobalKey<ScratcherState>();
  }

  void updateCoins(String userId, int coins) async {
    var url = Uri.parse(
            'https://faizanabid007.000webhostapp.com/Api/scratchcardcoinsupdate.php')
        .replace(
            queryParameters: {'Userid': userId, 'Coins': coins.toString()});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('Coins updated successfully.');
    } else {
      print('Failed to update coins. Error: ${response.body}');
    }
  }

  void updateScratchPercentage(double newPercentage) {
    setState(() {
      scratchPercentage = newPercentage;
      if (scratchPercentage >= 50.0) {
        isScratchCompleted = true;
      }
    });
  }

  int _points = 0;
  Timer? _timer;
  int _timerDuration = 1800; // 10 minutes in seconds

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerDuration > 0) {
          _timerDuration--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _timerDuration = 1800; // Reset the timer to 10 minutes
      _startTimer();
    });
  }

  void _watchVideo() {
    setState(() {
      _points += 10; // Increase points by 10 when the video is watched
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: backgroundcolor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: schemecolor),
          title: Text(
            'Scratch to Win!',
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
                  sigmaX: 9,
                  sigmaY: 9,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0),
                ),
              ),
            ),
            Center(
                child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Scratch",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: (height + width) / 35,
                      ),
                    ),
                    Text(
                      "20/20",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: (height + width) / 50,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: schemecolor, width: 5),
                      borderRadius: BorderRadius.circular(5)),
                  height: 300,
                  width: 300,
                  child: Scratcher(
                    key: _scratcherKey,
                    image: Image.asset("assets/images/scratch.jpeg"),
                    color: Colors.white,
                    brushSize: 60,
                    threshold: 50,
                    onChange: (value) => updateScratchPercentage(value),
                    onThreshold: () {
                      if (isScratchCompleted) {
                        final Random random = Random();
                        final int earnedCoins = random.nextInt(401) +
                            200; // Random number between 500 and 600
                        updateCoins(prefs.getString('phoneno').toString(),
                            earnedCoins); // Replace 'your_user_id' with the actual user ID and 500 with the desired coin value
                        dialogBox(height, width, earnedCoins);
                      }
                    },
                    child: const Center(
                      child: Text(
                        'Congratulation!',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _resetTimer(),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // NYC gaming color
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer),
                          const SizedBox(width: 8.0),
                          Text(
                              '${_timerDuration ~/ 60} min ${_timerDuration % 60}'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const SizedBox(height: 16.0),
                    Stack(
                      children: [
                        ElevatedButton(
                          onPressed: () => _watchVideo(),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // NYC gaming color
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.video_library),
                              SizedBox(width: 8.0),
                              Text('Watch Video'),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: schemecolor,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20.0,
                              minHeight: 20.0,
                            ),
                            child: const Center(
                              child: Text(
                                '+2',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  'How does it work?',
                  style: TextStyle(
                      fontSize: (height + width) / 45,
                      fontWeight: FontWeight.bold),
                ).pOnly(top: 8),
                Row(
                  children: const [
                    Text(
                      "1. Scratch 50% of the Card!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ).pOnly(left: 30, top: 18),
                Row(
                  children: const [
                    Text(
                      "2. Watch videos to scratch more cards!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ).pOnly(left: 30, top: 18),
                Row(
                  children: const [
                    Text(
                      "3. You will get 1 Scratch Card Every 30 Min!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ).pOnly(left: 30, top: 18),
              ],
            )),
          ],
        ));
  }

  dialogBox(double heights, double widths, int earnedCoins) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: Theme(
            data: ThemeData(
              backgroundColor: Colors.transparent,
            ),
            child: AlertDialog(
              title: const Center(child: Text('Congratulations!')),
              content: Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.asset("assets/animations/scratchcardreward.json"),
                  Lottie.asset("assets/animations/rewardspinner.json"),
                  Lottie.asset("assets/animations/scratchreward.json"),
                ],
              ),
              contentPadding: EdgeInsets.zero,
              actionsPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero,
              actions: [
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'You have earned $earnedCoins ',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                          Icon(
                            CupertinoIcons.money_dollar_circle_fill,
                            size: 24,
                            color: goldencolor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text('OK'),
                      style: ElevatedButton.styleFrom(
                        primary: schemecolor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _scratcherKey.currentState?.reset();
                        setState(() {
                          isScratchCompleted = false;
                          scratchPercentage = 0.0;
                        });
                      },
                    ).pOnly(
                        left: widths * 0.2, right: widths * 0.2, bottom: 10),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
