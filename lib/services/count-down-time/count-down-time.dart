import 'dart:async';

class CountdownService {
  Timer? _countdownTimer;
  DateTime? _endDate;

  void startCountdown(String endDateStr, void Function(Duration) onTick) {
    _endDate = DateTime.parse(endDateStr);

    _countdownTimer?.cancel(); // Cancel any existing timer

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      Duration remaining = getRemainingTime();
      if (remaining.isNegative) {
        timer.cancel(); // Stop the timer when countdown ends
      }
      onTick(remaining);
    });
  }

  Duration getRemainingTime() {
    if (_endDate == null) return Duration.zero;
    return _endDate!.difference(DateTime.now());
  }

  void dispose() {
    _countdownTimer?.cancel();
  }
}
