import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:playandearnmoney/config.dart';

class DailyRewardsScreen extends StatefulWidget {
  const DailyRewardsScreen({Key? key}) : super(key: key);

  @override
  _DailyRewardsScreenState createState() => _DailyRewardsScreenState();
}

class _DailyRewardsScreenState extends State<DailyRewardsScreen> {
  int _rewardDays = 1;
  int _maxRewardDays = 7;
  bool _isTimerComplete = false;
  late DateTime _timerCompletionTime;

  @override
  void initState() {
    super.initState();
    // Start the timer when the screen is initialized
    startTimer();
  }

  void startTimer() {
    // Simulating the timer with a 24-hour duration
    final currentTime = DateTime.now();
    _timerCompletionTime = currentTime.add(const Duration(hours: 24));

    Future.delayed(_timerCompletionTime.difference(currentTime), () {
      setState(() {
        _isTimerComplete = true;
      });
    });
  }

  void claimReward(int rewardDay) {
    if (_isTimerComplete && rewardDay < _rewardDays) {
      setState(() {
        _rewardDays = rewardDay + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        title: const Text("Daily Rewards"),
        backgroundColor: schemecolor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: schemecolor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Get your daily reward!",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          _isTimerComplete
                              ? "00:00:00"
                              : _formatTimerDuration(),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: _isTimerComplete ? () {} : null,
                      child: Text(
                        "Get Daily Reward",
                        style: TextStyle(color: schemecolor),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "Claim Your Daily Reward After 24 Hours!",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.count(
                childAspectRatio: 0.7,
                crossAxisCount: 3,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                children: List.generate(_maxRewardDays, (index) {
                  int reward = (index + 1) * 50;
                  bool isClaimed = index < _rewardDays;
                  return GestureDetector(
                    onTap: () => claimReward(index),
                    child: Card(
                      color: isClaimed ? Colors.grey : Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/animations/dailygift.json',
                            width: 64.0,
                            height: 64.0,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            "$reward Coins",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            "${index + 1} Day${index == 0 ? '' : 's'}",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimerDuration() {
    final remainingDuration = _timerCompletionTime.difference(DateTime.now());
    final hours = remainingDuration.inHours.toString().padLeft(2, '0');
    final minutes =
        (remainingDuration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds =
        (remainingDuration.inSeconds % 60).toString().padLeft(2, '0');

    return "$hours:$minutes:$seconds";
  }
}
