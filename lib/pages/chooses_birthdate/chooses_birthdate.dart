import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase/user/UserController.dart';
import '../../firebase/user/UserModel.dart';

class ChooseBirthdate extends StatefulWidget {
  final String name, UserID, TOKEN, PhoneController, selectedArea;
  ChooseBirthdate(
      {super.key,
      required this.name,
      required this.UserID,
      required this.PhoneController,
      required this.TOKEN,
      required this.selectedArea});

  @override
  State<ChooseBirthdate> createState() => _ChooseBirthdateState();
}

class _ChooseBirthdateState extends State<ChooseBirthdate> {
  String birthday = "";
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    birthday = DateTime.now()
        .toString()
        .substring(0, 10); // Set initial birthday to today's date
  }

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
                padding: const EdgeInsets.only(top: 15),
                child: Image.asset(
                  "assets/images/iconsss.png",
                  // height: 150,
                  width: 150,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  "ما هو تاريخ ميلادك ؟ ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  widget.name,
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
                      setState(() {
                        birthday = selectedDate.toString().substring(0, 10);
                      });
                    },
                    activeColor: const Color(0xffB04759),
                    locale: "ar",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "اختر الجنس:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 'male',
                          groupValue: selectedGender,
                          activeColor: Color(0xffB04759),
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value as String?;
                            });
                          },
                        ),
                        Text(
                          'ذكر',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 20),
                        Radio(
                          value: 'female',
                          groupValue: selectedGender,
                          activeColor: Color(0xffB04759),
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value as String?;
                            });
                          },
                        ),
                        Text(
                          'أنثى',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonWidget(
                        name: "حفط",
                        height: 40,
                        width: 80,
                        BorderColor: MAIN_COLOR,
                        OnClickFunction: () async {
                          if (birthday == "") {
                            // Handle case where birthday is not set (optional)
                          } else {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('show_birthday', false);
                            await prefs.setString(
                                'gender', selectedGender.toString());
                            await prefs.setString('birthdate', birthday);
                            Navigator.pop(context);
                            UserItem updatedUser = UserItem(
                              name: widget.name.toString(),
                              id: widget.UserID.toString(),
                              token: widget.TOKEN.toString(),
                              email: "${widget.UserID}@email.com",
                              phone: widget.PhoneController.toString(),
                              gender: selectedGender.toString(),
                              birthdate: birthday.toString(),
                              city: widget.selectedArea.toString(),
                              area: widget.selectedArea.toString(),
                              address: widget.selectedArea.toString(),
                              password: '123',
                            );
                            await userService.updateUser(updatedUser,
                                updateBirthdate: true, updateGender: true);
                          }
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
  final UserService userService = UserService();
}
