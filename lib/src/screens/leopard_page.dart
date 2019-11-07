import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sytravelanimation/src/screens/main_page.dart';
import 'dart:math' as math;

import 'package:sytravelanimation/styles/styles.dart';

class LeopardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 68,
        ),
        TheNumberText(),
        SizedBox(
          height: 10,
        ),
        TravelDescriptionLabel(),
        SizedBox(
          height: 32,
        ),
        LeopardDescriptionLabel(),
      ],
    );
  }
}

class TravelDescriptionLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Opacity(
          opacity: math.max(0, 1 - 4 * notifier.page),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 36.0),
        child: Text(
          "Travel Description",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class LeopardDescriptionLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Opacity(
          opacity: math.max(0, 1 - 4 * notifier.page),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: Text(
          "The leopard is distinguished by its well-camouflaged fur, opportunistic hunting behaviour, broad diet, and strength.",
          style: TextStyle(fontSize: 14, color: lightGrey),
        ),
      ),
    );
  }
}

class LeopardImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          left: -0.85 * notifier.offset,
          width: MediaQuery.of(context).size.width * 1.6,
          child: Transform.scale(
            alignment: Alignment(0.6, 0),
            scale: 1 - 0.2 * animation.value,
            child: Opacity(
              opacity: 1 - 0.6 * animation.value,
              child: child,
            ),
          ),
        );
      },
      child: IgnorePointer(
        child: Image.asset(
          'assets/leopard.png',
        ),
      ),
    );
  }
}

class TheNumberText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Transform.translate(
          offset: Offset(-35 - 0.5 * notifier.offset, 0),
          child: child,
        );
      },
      child: Container(
        alignment: Alignment.topLeft,
        child: RotatedBox(
          quarterTurns: 1,
          child: SizedBox(
            // height: 400,
            width: 430,
            child: FittedBox(
              alignment: Alignment.bottomCenter,
              fit: BoxFit.cover,
              child: Text(
                '72',
                style: TextStyle(
                  // fontSize: 350,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // return Image.asset('assets/leopard.png');
  }
}
