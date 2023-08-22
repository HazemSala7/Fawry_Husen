import 'dart:async';

import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/firebase/user/UserModel.dart';
import 'package:fawri_app_refactor/pages/authentication/register_screen/register_screen.dart';
import 'package:fawri_app_refactor/pages/authentication/sign_in/sign_in.dart';
import 'package:fawri_app_refactor/pages/category-splash/category-splash.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../components/button_widget/button_widget.dart';
import '../../../firebase/user/UserController.dart';
import '../../../services/auth/anonymous_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    bool isAppleDevice = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF14181B),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        // Video background
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1,
              decoration: BoxDecoration(
                color: Color(0xFF14181B),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(
                    'assets/images/video.gif',
                  ).image,
                ),
              ),
            ),
            loading
                ? Padding(
                    padding: EdgeInsets.only(right: 15, left: 15, top: 450),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.black)),
                      child: Center(
                          child: Container(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )),
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.only(right: 15, left: 15, top: 450),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonWidget(
                          OnClickFunction: () async {
                            setState(() {
                              loading = true;
                            });
                            Timer(Duration(seconds: 1), () async {
                              addUser();
                              // final user = await signInAnonymously(context);
                              // if (user == null) {
                              //   return;
                              // }
                            });
                          },
                          width: double.infinity,
                          height: 50,
                          name: "تخطي",
                          BorderRaduis: 40,
                          NameColor: Colors.white,
                          BorderColor: Colors.black,
                          ButtonColor: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Container(
                              width: double.infinity,
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: isAppleDevice,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: MAIN_COLOR),
                                      child: Center(
                                        child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              FontAwesome.apple,
                                              color: Colors.white,
                                              size: 30,
                                            )),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: MAIN_COLOR),
                                    child: Center(
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            FontAwesome.facebook,
                                            color: Colors.white,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: MAIN_COLOR),
                                    child: Center(
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.mail,
                                            color: Colors.white,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: MAIN_COLOR),
                                    child: Center(
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  final UserService userService = UserService();
  addUser() async {
    String user_Id = Uuid().v4();
    UserItem newItem = UserItem(
      id: user_Id,
      email: "$user_Id@gmail.com",
      password: "",
      address: '',
      area: '',
      city: '',
      phone: '',
    );
    userService.addUser(newItem).then((_) async {
      setState(() {
        loading = false;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user_Id);
      await prefs.setBool('login', true);
      NavigatorFunction(context, CategorySplash());
    }).catchError((error) {
      setState(() {
        loading = false;
      });
    });
  }

  bool loading = false;
}
