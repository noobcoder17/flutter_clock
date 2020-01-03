import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Digital Clock',
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.redAccent,
        backgroundColor: Colors.black,
      ),
      home: MyDigitalClock(),
    );
  }
}

class TimeDigits {
  int hour;
  int min;
  int sec;
  TimeDigits(DateTime time) {
    hour = time.hour;
    min = time.minute;
    sec = time.second;
  }

  int get getHour {
    print(hour);
    if (hour > 12) {
      return hour - 12;
    }
    return hour;
  }

  int get getMin {
    return min;
  }

  int get getSec {
    return sec;
  }
}

class MyDigitalClock extends StatefulWidget {
  @override
  _MyDigitalClockState createState() => _MyDigitalClockState();
}

class _MyDigitalClockState extends State<MyDigitalClock> {
  TimeDigits _myTime = TimeDigits(DateTime.now());

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        _myTime = TimeDigits(DateTime.now());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: 5 / 3,
            child: Container(
              height: height,
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      NumberMaker(_myTime.hour <= 12
                          ? _myTime.hour
                          : _myTime.hour - 12),
                      Dots(),
                      NumberMaker(_myTime.min),
                    ],
                  ),
                  LinearProgressIndicator(
                      value: _myTime.sec / 60,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Dots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            height: 20,
            width: 20,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          ),
          Container(
            height: 20,
            width: 20,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          )
        ],
      ),
    );
  }
}

class NumberMaker extends StatelessWidget {
  final int number;
  NumberMaker(this.number);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          DigitMaker(
            digit: number ~/ 10,
          ),
          SizedBox(
            width: 20,
          ),
          DigitMaker(
            digit: number % 10,
          ),
        ],
      ),
    );
  }
}

class DigitMaker extends StatelessWidget {
  final int digit;
  DigitMaker({@required this.digit});
  final Map<int, List<int>> segmentMap = {
    0: [0, 1, 1, 1, 1, 1, 1],
    1: [0, 0, 0, 0, 1, 1, 0],
    2: [1, 0, 1, 1, 0, 1, 1],
    3: [1, 0, 0, 1, 1, 1, 1],
    4: [1, 1, 0, 0, 1, 1, 0],
    5: [1, 1, 0, 1, 1, 0, 1],
    6: [1, 1, 1, 1, 1, 0, 1],
    7: [0, 0, 0, 0, 1, 1, 1],
    8: [1, 1, 1, 1, 1, 1, 1],
    9: [1, 1, 0, 1, 1, 1, 1]
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      //height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BarHorizontal(segmentMap[digit][6]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BarVertical(segmentMap[digit][1]),
              BarVertical(segmentMap[digit][5])
            ],
          ),
          BarHorizontal(segmentMap[digit][0]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BarVertical(segmentMap[digit][2]),
              BarVertical(segmentMap[digit][4])
            ],
          ),
          BarHorizontal(segmentMap[digit][3])
        ],
      ),
    );
  }
}

class BarHorizontal extends StatelessWidget {
  final int active;
  BarHorizontal(this.active);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ClipPath(
      clipper: HorBarClipper(),
      child: Container(
        height: 15,
        width: height * 0.18,
        decoration: BoxDecoration(
          color: active == 1 ? Colors.red : Colors.white10,
        ),
      ),
    );
  }
}

class BarVertical extends StatelessWidget {
  final int active;
  BarVertical(this.active);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ClipPath(
      clipper: VerBarClipper(),
      child: Container(
        height: height * 0.18,
        width: 15,
        decoration: BoxDecoration(
          color: active == 1 ? Colors.red : Colors.white10,
        ),
      ),
    );
  }
}

class HorBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width * 0.1, size.height);
    path.lineTo(size.width - size.width * 0.1, size.height);
    path.lineTo(size.width, size.height - size.height / 2);
    path.lineTo(size.width - size.width * 0.1, 0);
    path.lineTo(size.width * 0.1, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class VerBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.moveTo(0, size.height * 0.1);
    path.lineTo(0, size.height - size.height * 0.1);
    path.lineTo(size.width - size.width / 2, size.height);
    path.lineTo(size.width, size.height - size.height * 0.1);
    path.lineTo(size.width, size.height * 0.1);
    path.lineTo(size.width - size.width / 2, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
