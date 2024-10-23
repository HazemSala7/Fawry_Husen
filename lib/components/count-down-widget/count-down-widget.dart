import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerScreen extends StatefulWidget {
  final String endDate; // Accept the end date from the API

  CountdownTimerScreen({required this.endDate});

  @override
  _CountdownTimerScreenState createState() => _CountdownTimerScreenState();
}

class _CountdownTimerScreenState extends State<CountdownTimerScreen> {
  Timer? _timer;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _endTime =
        DateTime.parse(widget.endDate); // Parse the end date from the API
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {});
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
          width: 80,
          decoration: BoxDecoration(
            color: Color.fromARGB(181, 17, 17, 19),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 32,
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
