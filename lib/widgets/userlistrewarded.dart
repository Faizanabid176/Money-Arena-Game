import 'dart:math';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class RandomAvatarList extends StatelessWidget {
  final int itemCount;

  RandomAvatarList({required this.itemCount});

  final Random _random = Random();

  final List<String> _imageUrls = [
    'https://randomuser.me/api/portraits/women/1.jpg',
    'https://randomuser.me/api/portraits/men/2.jpg',
    'https://randomuser.me/api/portraits/women/3.jpg',
    'https://randomuser.me/api/portraits/men/4.jpg',
    'https://randomuser.me/api/portraits/women/5.jpg',
    'https://randomuser.me/api/portraits/men/6.jpg',
    'https://randomuser.me/api/portraits/women/7.jpg',
    'https://randomuser.me/api/portraits/men/8.jpg',
    'https://randomuser.me/api/portraits/women/9.jpg',
    'https://randomuser.me/api/portraits/men/10.jpg',
  ];

  String _getRandomImageUrl() {
    int index = _random.nextInt(_imageUrls.length);
    return _imageUrls[index];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          String imageUrl = _getRandomImageUrl();
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Colors.transparent,
                  content: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
                radius: 30.0,
              ),
            ),
          );
        },
      ),
    ).p8();
  }
}
