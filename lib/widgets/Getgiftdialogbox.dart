import 'package:flutter/material.dart';
import 'package:playandearnmoney/config.dart';

class CustomDialogBox extends StatelessWidget {
  const CustomDialogBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: GestureDetector(
        onTap: () {
          // Do nothing on tap outside the dialog
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close_outlined),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog box
                  },
                ),
              ),
              Image.asset(
                'assets/images/adpic.png', // Replace with your image path
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              const Text(
                'Watch video and get up to 1,000 coins',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Implement your logic to watch the video
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Watch ad'),
                style: ElevatedButton.styleFrom(
                  primary: schemecolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
