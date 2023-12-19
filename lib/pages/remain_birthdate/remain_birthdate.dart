import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class RemainBirthdate extends StatefulWidget {
  const RemainBirthdate({super.key});

  @override
  State<RemainBirthdate> createState() => CchoosBbirthdateState();
}

class CchoosBbirthdateState extends State<RemainBirthdate> {
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
              Image.asset(
                "assets/images/b7a8d4cbd62a724fd1f53f20ebf6fbb2.png",
                // height: 100,
                width: 150,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  "أوه! ، باقي لعيد ميلادك 8 أشهر و 10 أيام",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  "نحن لا ننسى عيد ميلاد الشخص المميز",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25, top: 70),
                child: ButtonWidget(
                    name: "ابدأ بالتسوق",
                    height: 60,
                    width: double.infinity,
                    BorderColor: MAIN_COLOR,
                    OnClickFunction: () {},
                    BorderRaduis: 40,
                    ButtonColor: MAIN_COLOR,
                    NameColor: Colors.white),
              ),
            ],
          ),
        )),
      ),
    );
  }

  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();
}
