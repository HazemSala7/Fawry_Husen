import 'dart:async';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  final bool hasAPI;
  final String type; // Assuming this is the initial time in "HH:MM:SS" format
  const CountdownTimerWidget(
      {Key? key, required this.hasAPI, required this.type})
      : super(key: key);

  @override
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Duration remainingTime;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  void _initializeTimer() {
    try {
      // Extract only the time part if there is any extra text in `widget.type`
      final timeString = RegExp(r'(\d{1,2}):(\d{2}):(\d{2})')
          .firstMatch(widget.type)
          ?.group(0);

      if (timeString == null) {
        throw FormatException("Invalid time format");
      }

      final timeParts = timeString.split(":").map(int.parse).toList();

      // Set the remaining time based on the parsed hours, minutes, and seconds
      remainingTime = Duration(
        hours: timeParts[0],
        minutes: timeParts[1],
        seconds: timeParts[2],
      );

      countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (remainingTime.inSeconds > 0) {
          setState(() {
            remainingTime -= Duration(seconds: 1);
          });
        } else {
          timer.cancel();
        }
      });
    } catch (e) {
      print("Error parsing time: $e");
      remainingTime = Duration.zero; // Default to 0 if parsing fails
    }
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.hasAPI,
      child: Opacity(
        opacity: 0.7,
        child: Container(
          width: double.infinity,
          height: 40,
          color: MAIN_COLOR,
          child: Center(
            child: Text(
              "ينتهي خلال  ${_formatDuration(remainingTime)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
