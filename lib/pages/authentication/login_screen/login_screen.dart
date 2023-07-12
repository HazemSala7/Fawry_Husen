import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import '../../../components/button_widget/button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF14181B),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        // Video background
        child: Container(
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
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color(0x990F1113),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [
                // Fawri image in arabic
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                  child: Align(
                    alignment: AlignmentDirectional(-0.05, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/fawri_arabic.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
                // Just for space
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(10, 250, 10, 10),
                        child: Text(""),
                      ),
                    ),
                  ],
                ),
                // Login Button
                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: ButtonWidget(
                    OnClickFunction: () {},
                    width: double.infinity,
                    height: 40,
                    name: "تسجيل الدخول",
                    BorderRaduis: 0,
                    NameColor: Colors.black,
                    BorderColor: Colors.white,
                    ButtonColor: Colors.white,
                  ),
                ),
                // Create New Account Button
                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
                  child: ButtonWidget(
                    OnClickFunction: () {},
                    width: double.infinity,
                    height: 40,
                    name: "انشاء حساب جديد",
                    BorderRaduis: 0,
                    NameColor: Colors.white,
                    BorderColor: Colors.white,
                    ButtonColor: Color(0x6CFFFFFF),
                  ),
                ),
                // Skip Button
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loading
                          ? Container(
                              width: 160,
                              height: 40,
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
                            )
                          : ButtonWidget(
                              OnClickFunction: () {
                                setState(() {
                                  loading = true;
                                });
                                NavigatorFunction(context, HomeScreen());
                              },
                              width: 160,
                              height: 40,
                              name: "تخطي",
                              BorderRaduis: 40,
                              NameColor: Colors.white,
                              BorderColor: Colors.black,
                              ButtonColor: Colors.black,
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool loading = false;
}
