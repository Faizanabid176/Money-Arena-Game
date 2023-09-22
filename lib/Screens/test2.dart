import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AndroidAlarmManager.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Token App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TokenScreen(),
    );
  }
}

class TokenScreen extends StatefulWidget {
  @override
  _TokenScreenState createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen> {
  int tokenNumber = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadTokenNumber();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> loadTokenNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokenNumber = prefs.getInt('tokenNumber') ?? 0;
    });
  }

  void startTimer() {
    const duration = Duration(minutes: 30);
    timer = Timer.periodic(duration, (timer) {
      increaseTokenNumber();
      setState(() {
        tokenNumber++;
      });
    });
  }

  void increaseTokenNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int tokenNumber = prefs.getInt('tokenNumber') ?? 0;
    tokenNumber++;
    await prefs.setInt('tokenNumber', tokenNumber);
  }

  String formatDuration(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Token Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Token Number:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              tokenNumber.toString(),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CountdownTimer(),
          ],
        ),
      ),
    );
  }
}

class CountdownTimer extends StatefulWidget {
  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Duration duration = Duration(minutes: 30);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    duration = Duration(seconds: 1);
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        if (duration.inSeconds > 0) {
          duration -= Duration(seconds: 1);
        } else {
          duration = Duration(minutes: 30);
        }
      });
    });
  }

  String formatDuration(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Next Token in: ${formatDuration(duration)}',
      style: TextStyle(fontSize: 18),
    );
  }
}
