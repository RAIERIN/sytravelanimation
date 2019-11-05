import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class _MainPageState extends State<MainPage> {
  final PageController _pagecontroller = PageController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => PageOffsetNotifier(_pagecontroller),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              PageView(
                controller: _pagecontroller,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  FirstPage(),
                  SecondPage(),
                ],
              ),
              AppBar(),
              FirstImage(),
              SecondImage()
            ],
          ),
        ),
      ),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 70),
      alignment: Alignment.topLeft,
      child: Transform.translate(
        offset: Offset(-45, 0),
        child: RotatedBox(
          quarterTurns: 1,
          child: Text(
            '72',
            style: TextStyle(
              fontSize: 350,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
    // return Image.asset('assets/leopard.png');
  }
}

class FirstImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Positioned(
          left: -0.85 * notifier.offset,
          width: MediaQuery.of(context).size.width * 1.6,
          child: child,
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

class SecondImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Positioned(
          left:
              1.2 * MediaQuery.of(context).size.width - 0.85 * notifier.offset,
          height: MediaQuery.of(context).size.height / 2.0,
          child: child,
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

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
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
