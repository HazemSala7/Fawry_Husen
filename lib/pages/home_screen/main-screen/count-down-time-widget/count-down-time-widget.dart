import 'dart:async';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/services/count-down-time/count-down-time.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? endDate;
  Duration remainingTime = Duration.zero;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _loadEndDate();
  }

  // Load `endDate` from SharedPreferences
  Future<void> _loadEndDate() async {
    final prefs = await SharedPreferences.getInstance();
    endDate = prefs.getString('end_date_falsh');
    if (endDate != null) {
      _startCountdown();
    }
  }

  // Start countdown based on `endDate`
  void _startCountdown() {
    DateTime endDateTime = DateTime.parse(endDate!);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime = endDateTime.difference(DateTime.now());
        if (remainingTime.isNegative) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    return "${duration.inHours}:${duration.inMinutes.remainder(60)}:${duration.inSeconds.remainder(60)}";
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
              widget.type == "11.11" ||
                      widget.type == "Discount" ||
                      widget.type == "Best Seller"
                  ? widget.type
                  : "ينتهي خلال  ${_formatDuration(remainingTime)}",
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
