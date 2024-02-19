import 'dart:math';

import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';


class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimateIcon(
            key: UniqueKey(),
        onTap: () {},
        iconType: IconType.continueAnimation,
        height: 100,
        width: 100,
        color: Colors.pinkAccent,
        animateIcon: AnimateIcons.activity,
      ),
            const Text(
              'Your activty will show up here',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
