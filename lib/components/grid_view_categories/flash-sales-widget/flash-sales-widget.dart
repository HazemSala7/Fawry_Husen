import 'dart:async';
import 'package:fawri_app_refactor/components/count-down-widget/count-down-widget.dart';
import 'package:fawri_app_refactor/components/flash_sales_products/flash_sales_products.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:fawri_app_refactor/server/domain/domain.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class FlashSalesWidget extends StatefulWidget {
  final bool active;
  final String startDate;
  final String endDate;
  var flashSalesArray;

  FlashSalesWidget({
    required this.flashSalesArray,
    required this.active,
    required this.startDate,
    required this.endDate,
  });

  @override
  _FlashSalesWidgetState createState() => _FlashSalesWidgetState();
}

class _FlashSalesWidgetState extends State<FlashSalesWidget> {
  Duration countdownDuration = Duration();
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    final endDateTime = DateTime.parse(widget.endDate);
    countdownDuration = endDateTime.difference(DateTime.now());
    countdownTimer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        countdownDuration = countdownDuration - Duration(seconds: 1);
        if (countdownDuration.isNegative) {
          countdownTimer?.cancel();
          navigateToNextPage();
        }
      });
    });
  }

  void navigateToNextPage() {
    NavigatorFunction(
      context,
      HomeScreen(
        type: "Flash Sale Ended",
        url: URL_FLASH_SALES,
        title: "",
        slider: false,
        selectedIndex: 0,
        productsKinds: true,
      ),
    );
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  String get countdownText {
    final hours = countdownDuration.inHours;
    final minutes = countdownDuration.inMinutes.remainder(60);
    final seconds = countdownDuration.inSeconds.remainder(60);
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.active && isWithinDateRange()) {
      return Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            height: 525,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.yellow),
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 8),
              child: Column(
                children: [
                  // Flash sale header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: Lottie.asset(
                          "assets/lottie_animations/Animation - 1729073541927.json",
                          height: 40,
                          reverse: true,
                          repeat: true,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        widget.flashSalesArray["name"] ?? "Flash Sales",
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.w900,
                          fontSize: 36,
                          color: MAIN_COLOR,
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        width: 50,
                        height: 50,
                        child: Lottie.asset(
                          "assets/lottie_animations/Animation - 1729073541927.json",
                          height: 40,
                          reverse: true,
                          repeat: true,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  // Flash sale countdown
                  Text(
                    "ينتهي خلال",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 15),
                  CountdownTimerScreen(
                    endDate: widget.endDate,
                  ),
                  SizedBox(height: 10),

                  // Flash sale products
                  FlashSalesProducts(
                    productCardStyle: 4,
                    shortlisted: widget.flashSalesArray["items"],
                  ),
                ],
              ),
            ),
          ),

          // "See More" Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                NavigatorFunction(
                  context,
                  HomeScreen(
                    type: "ينتهي خلال ${countdownText}",
                    url: URL_FLASH_SALES,
                    title: "",
                    slider: false,
                    selectedIndex: 0,
                    productsKinds: true,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "اعرض بشكل أوسع",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MAIN_COLOR,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_circle_left_outlined),
                    ],
                  ),
                  Container(
                    width: 145,
                    height: 2,
                    color: MAIN_COLOR,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return SizedBox(); // Empty space if the conditions are not met
    }
  }

  bool isWithinDateRange() {
    DateTime now = DateTime.now();

    // Parse the start and end dates in ISO 8601 format
    DateTime start = DateTime.parse(widget.startDate);
    DateTime end = DateTime.parse(widget.endDate);

    // Check if the current time is between start and end dates
    return now.isAfter(start) && now.isBefore(end);
  }
}
