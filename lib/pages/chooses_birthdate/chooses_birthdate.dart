import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseBirthdate extends StatefulWidget {
  const ChooseBirthdate({super.key});

  @override
  State<ChooseBirthdate> createState() => CchoosBbirthdateState();
}

class CchoosBbirthdateState extends State<ChooseBirthdate> {
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
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Image.asset(
                  "assets/images/iconsss.png",
                  // height: 150,
                  width: 150,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  "ما هو تاريخ ميلادك ؟ ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  "Yasmeen Yahia",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  " للحصول على المزيد من الخصومات",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color.fromARGB(255, 173, 173, 173)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  color: Color(0xffD9D9D9),
                  child: EasyDateTimeLine(
                    initialDate: DateTime.now(),
                    onDateChange: (selectedDate) {
                      //`selectedDate` the new date selected.
                    },
                    activeColor: const Color(0xffB04759),
                    locale: "ar",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonWidget(
                        name: "حفط",
                        height: 40,
                        width: 80,
                        BorderColor: MAIN_COLOR,
                        OnClickFunction: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('show_birthday', false);
                          Navigator.pop(context);
                        },
                        BorderRaduis: 10,
                        ButtonColor: MAIN_COLOR,
                        NameColor: Colors.white),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "تخطي",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )
                  ],
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
