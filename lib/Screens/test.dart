import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Test App'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CardWidget(
                  rewardText: 'You won a reward!',
                ),
              ),
              Expanded(
                child: CardWidget(
                  rewardText: 'b',
                ),
              ),
              Expanded(
                child: CardWidget(
                  rewardText: 'a',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatefulWidget {
  final String rewardText;

  CardWidget({required this.rewardText});

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;

  bool isCardExpanded = false;
  bool isCardClicked = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Increased animation speed
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _shakeAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _playAnimations() async {
    await _animationController.forward(from: 0.0);
    await _animationController.reverse(from: 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCardExpanded = !isCardExpanded;
          isCardClicked = true;
        });
        _playAnimations();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.translate(
              offset: Offset(isCardExpanded ? _shakeAnimation.value : 0, 0),
              child: Container(
                width: 200.0, // Adjust the width as needed
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: isCardClicked ? Colors.blue : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: isCardExpanded
                        ? Text(
                            widget.rewardText,
                            style: TextStyle(fontSize: 20.0),
                          )
                        : Text('Tap'),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ).p8();
  }
}
