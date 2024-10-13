import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimerScreen extends StatefulWidget {
  @override
  _CountdownTimerScreenState createState() => _CountdownTimerScreenState();
}

class _CountdownTimerScreenState extends State<CountdownTimerScreen> {
  Timer? _timer;
  DateTime _endTime =
      DateTime.now().add(Duration(hours: 24)); // 24-hour countdown

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {}); // Trigger UI update every minute instead of every second
      if (_remainingTime.inSeconds <= 0) {
        timer.cancel();
      }
    });
  }

  Duration get _remainingTime {
    return _endTime.difference(DateTime.now());
  }

  String get formattedTime {
    int hours = _remainingTime.inHours;
    int minutes = _remainingTime.inMinutes % 60;
    int seconds = _remainingTime.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    int hours = _remainingTime.inHours;
    int minutes = _remainingTime.inMinutes % 60;
    int seconds = _remainingTime.inSeconds % 60;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTimeContainer(seconds.toString().padLeft(2, '0'), "SECONDS"),
          buildSeparator(),
          buildTimeContainer(minutes.toString().padLeft(2, '0'), "MINUTES"),
          buildSeparator(),
          buildTimeContainer(hours.toString().padLeft(2, '0'), "HOURS"),
        ],
      ),
    );
  }

  Widget buildTimeContainer(String value, String label) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Color.fromARGB(171, 121, 121, 121),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        ":",
        style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
