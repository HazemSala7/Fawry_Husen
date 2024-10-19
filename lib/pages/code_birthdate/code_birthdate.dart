import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:lottie/lottie.dart';

class CodeBirthdate extends StatefulWidget {
  const CodeBirthdate({super.key});

  @override
  State<CodeBirthdate> createState() => CchoosBbirthdateState();
}

class CchoosBbirthdateState extends State<CodeBirthdate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_COLOR,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          "فوري",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
      ),
      body: Container(
        color: Color(0xffF5F5F5),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              Image.asset(
                "assets/images/iconssssss.png",
                // height: 150,
                width: double.infinity,
              ),
              Lottie.asset(
                  "assets/lottie_animations/Animation - 1703064221577.json",
                  height: 200,
                  reverse: true,
                  repeat: true,
                  fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  "تهنئك Fawri بعيد ميلادك",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  "لديك نسبة خصم 50%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "استخدم الكود",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: 40,
                  width: 170,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                    child: Text(
                      "3490DC",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }

  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();
}
