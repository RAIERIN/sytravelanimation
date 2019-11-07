import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:sytravelanimation/styles/styles.dart';

import 'leopard_page.dart';

class PageOffsetNotifier with ChangeNotifier {
  double _offset = 0;
  double _page = 0;

  PageOffsetNotifier(PageController pageController) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = pageController.page;
      notifyListeners();
    });
  }
  double get page => _page;
  double get offset => _offset;
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final PageController _pagecontroller = PageController();
  AnimationController _animationController;
  double get maxHeight => 380;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 1000),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => PageOffsetNotifier(_pagecontroller),
      child: ListenableProvider.value(
        value: _animationController,
        child: Scaffold(
          body: GestureDetector(
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: SafeArea(
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  PageView(
                    controller: _pagecontroller,
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      LeopardPage(),
                      VulturePage(),
                    ],
                  ),
                  AppBar(),
                  LeopardImage(),
                  VultureImage(),
                  ShareButton(),
                  PageIndicator(),
                  ArrowIcon(),
                  TravelDetailLabel(),
                  StartCampLabel(),
                  StartTimeLabel(),
                  BaseCampLabel(),
                  BaseTimeLabel(),
                  DistanceLabel(),
                  TravelDots(),
                  MapButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _animationController.value -= details.primaryDelta / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController.isAnimating ||
        _animationController.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0)
      _animationController.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _animationController.fling(velocity: math.max(-2.0, -flingVelocity));
    else
      _animationController.fling(
          velocity: _animationController.value < 0.5 ? -2.0 : 2.0);
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(builder: (context, notifier, _) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: notifier.page.round() == 0 ? white : lightGrey,
                ),
                width: 6,
                height: 6,
              ),
              SizedBox(
                width: 6,
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: notifier.page.round() == 1 ? white : lightGrey,
                ),
                width: 6,
                height: 6,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class ArrowIcon extends StatelessWidget {
  const ArrowIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child) {
        print((1 - animation.value) * (68 + 430.0 + 10.0 - 4));
        return Positioned(
          top: 68 + (1 - animation.value) * (430.0 + 10.0 - 4),
          right: 24,
          child: child,
        );
      },
      child: Icon(
        Icons.keyboard_arrow_up,
        color: lighterGrey,
        size: 28,
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 24,
      bottom: 16,
      child: Icon(Icons.share),
    );
  }
}

class VultureImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          left:
              1.2 * MediaQuery.of(context).size.width - 0.85 * notifier.offset,
          height: MediaQuery.of(context).size.height / 2.0,
          child: Transform.scale(
            scale: 1 - 0.2 * animation.value,
            child: Opacity(
              opacity: 1 - 0.6 * animation.value,
              child: child,
            ),
          ),
        );
      },
      child: IgnorePointer(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Image.asset(
            'assets/vulture.png',
          ),
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
        child: Row(
          children: <Widget>[
            Text(
              'SY',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Spacer(),
            Icon(Icons.menu),
          ],
        ),
      ),
    );
  }
}

class TravelDetailLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          top: 68 + (1 - animation.value) * (430.0 + 10.0 - 4),
          left: 32 + MediaQuery.of(context).size.width - notifier.offset,
          child: Opacity(
            opacity: math.max(0, 4 * notifier.page - 3),
            child: child,
          ),
        );
      },
      child: Text(
        "Travel details",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class StartCampLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 68 + 430.0 + 10.0 + 8 + 32,
          width: (MediaQuery.of(context).size.width - 48) / 3,
          left: opacity * 10.0,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          "Start camp",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}

class StartTimeLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 68 + 430.0 + 10.0 + 8 + 32 + 40,
          width: (MediaQuery.of(context).size.width - 48) / 3,
          left: opacity * 10.0,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          "02:40 pm",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w300, color: lighterGrey),
        ),
      ),
    );
  }
}

class BaseCampLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 68 + 32 + 8 + 4 + (1 - animation.value) * (430.0 + 10.0 - 4),
          width: (MediaQuery.of(context).size.width - 48) / 3,
          right: opacity * 10.0,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Base camp",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}

class BaseTimeLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 68 + 8 + 32 + 40 + 4 + (1 - animation.value) * (430.0 + 10.0),
          width: (MediaQuery.of(context).size.width - 48) / 3,
          right: opacity * 10.0,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "07:30 am",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w300, color: lighterGrey),
        ),
      ),
    );
  }
}

class DistanceLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 68 + 430.0 + 10.0 + 8 + 32 + 40,
          width: MediaQuery.of(context).size.width,
          // left: (MediaQuery.of(context).size.width)/3,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Center(
        child: Text(
          "72 km",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: white),
        ),
      ),
    );
  }
}

class TravelDots extends StatelessWidget {
  const TravelDots({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double spacingfactor;
        double opacity;
        if (animation.value == 0) {
          spacingfactor = math.max(0, 4 * notifier.page - 3);
          opacity = spacingfactor;
        } else {
          spacingfactor = math.max(0, 1 - 6 * animation.value);
          opacity = 1;
        }

        return Positioned(
          top: 68 + 430.0 + 10.0 + 8 + 32 + 4,
          left: 0,
          right: 0,
          child: Center(
            child: Opacity(
              opacity: opacity,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: spacingfactor * 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lighterGrey,
                    ),
                    width: 4,
                    height: 4,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: spacingfactor * 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lighterGrey,
                    ),
                    width: 4,
                    height: 4,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: spacingfactor * 40),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: white)),
                    width: 8,
                    height: 8,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: spacingfactor * 40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: white,
                    ),
                    width: 8,
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MapButton extends StatelessWidget {
  const MapButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 10,
      child: Consumer<PageOffsetNotifier>(builder: (context, notifier, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Opacity(
          opacity: opacity,
          child: FlatButton(
            child: Text(
              "ON MAP",
              style: TextStyle(fontSize: 12),
            ),
            onPressed: () {
              Provider.of<AnimationController>(context).forward();
            },
          ),
        );
      }),
    );
  }
}

class VulturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: VultureCircle(),
    );
    // return Center(
    //   child: Padding(
    //     padding: const EdgeInsets.only(bottom: 80.0),
    //     child: Image.asset(
    //       'assets/vulture.png',
    //       height: MediaQuery.of(context).size.height / 2.5,
    //     ),
    //   ),
    // );
  }
}

class VultureCircle extends StatelessWidget {
  const VultureCircle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double multiplier;
        if (animation.value == 0) {
          multiplier = math.max(0, 4 * notifier.page - 3);
        } else {
          multiplier = math.max(0, 1 - 6 * animation.value);
        }
        double size = MediaQuery.of(context).size.width * 0.5 * multiplier;
        return Container(
          margin: EdgeInsets.only(bottom: 250, left: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: lightGrey,
          ),
          width: size,
        );
      },
    );
  }
}
