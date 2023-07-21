import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/flutter_flow_icon_button/flutter_flow_icon_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? emailAddressController;
  TextEditingController? passwordLoginController;

  late bool passwordLoginVisibility;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    emailAddressController = TextEditingController();
    passwordLoginController = TextEditingController();
    passwordLoginVisibility = false;
  }

  @override
  void dispose() {
    emailAddressController?.dispose();
    passwordLoginController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [],
          flexibleSpace: FlexibleSpaceBar(
            title: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_circle_right_outlined,
                          color: MAIN_COLOR,
                        ))
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                  child: Text(
                    "تسجيل دخول",
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                ),
              ],
            ),
            centerTitle: true,
            expandedTitleScale: 1.0,
          ),
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                      child: Text(
                        "أدخل الى حسابك عن طريق تسجيل الدخول",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Color(0x4D101213),
                      offset: Offset(0, 2),
                    )
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: emailAddressController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: "ايميلك الشخصي... ",
                    // labelStyle: FlutterFlowTheme.of(context).bodyText2,
                    hintText: "ادخل ايميلك الشخصي...",
                    hintStyle: TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: Color(0xFF57636C),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Color(0xFFFFFFFF),
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                  ),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF57636C)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 0),
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Color(0x4D101213),
                      offset: Offset(0, 2),
                    )
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: passwordLoginController,
                  obscureText: !passwordLoginVisibility,
                  decoration: InputDecoration(
                    labelText: "كلمة المرور ",
                    // labelStyle: FlutterFlowTheme.of(context).bodyText2,
                    hintText: "ادخل كلمة المرور...",
                    hintStyle: TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: Color(0xFF57636C),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Color(0xFFFFFFFF),
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                    suffixIcon: InkWell(
                      onTap: () => setState(
                        () =>
                            passwordLoginVisibility = !passwordLoginVisibility,
                      ),
                      focusNode: FocusNode(skipTraversal: true),
                      child: Icon(
                        passwordLoginVisibility
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Color(0xFFFFFFFF),
                        size: 22,
                      ),
                    ),
                  ),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF57636C)),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                child: ButtonWidget(
                    name: "تسجيل دخول",
                    height: 50,
                    width: 200,
                    BorderColor: Colors.white,
                    OnClickFunction: () {},
                    BorderRaduis: 10,
                    ButtonColor: Colors.black,
                    NameColor: Colors.white)),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30,
                  borderWidth: 2,
                  buttonSize: 60,
                  icon: FaIcon(
                    FontAwesomeIcons.facebook,
                    color: Color(0xFD000000),
                    size: 33,
                  ),
                  onPressed: () async {
                    // final user = await signInWithFacebook(context);
                    // if (user == null) {
                    //   return;
                    // }
                    // bool firstRun = await IsFirstRun.isFirstRun();
                    // bool firstRunCart = await IsFirstRun.isFirstRun();
                    // bool firstRunBadge = await IsFirstRun.isFirstRun();
                    // bool firstRunproduct = await IsFirstRun.isFirstRun();

                    // setState(() {
                    //   FFAppState().firstrun = firstRun;
                    //   FFAppState().firstruncart = firstRunCart;
                    //   FFAppState().firstrunbadge = firstRunBadge;
                    //   FFAppState().firstrunproduct = firstRunproduct;
                    //   FFAppState().isstarting = true;
                    // });
                    // await Navigator.push(
                    //   context,
                    //   PageTransition(
                    //     type: PageTransitionType.fade,
                    //     duration: Duration(milliseconds: 300),
                    //     reverseDuration: Duration(milliseconds: 300),
                    //     child: CatsWidget(),
                    //   ),
                    // );
                  },
                ),
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30,
                  borderWidth: 2,
                  buttonSize: 60,
                  icon: FaIcon(
                    FontAwesomeIcons.google,
                    color: Color(0xFD000000),
                    size: 30,
                  ),
                  onPressed: () async {
                    // final user = await signInWithGoogle(context);
                    // if (user == null) {
                    //   return;
                    // }
                    // bool firstRun = await IsFirstRun.isFirstRun();
                    // bool firstRunCart = await IsFirstRun.isFirstRun();
                    // bool firstRunBadge = await IsFirstRun.isFirstRun();
                    // bool firstRunproduct = await IsFirstRun.isFirstRun();

                    // setState(() {
                    //   FFAppState().firstrun = firstRun;
                    //   FFAppState().firstruncart = firstRunCart;
                    //   FFAppState().firstrunbadge = firstRunBadge;
                    //   FFAppState().firstrunproduct = firstRunproduct;
                    //   FFAppState().isstarting = true;
                    // });
                    // await Navigator.push(
                    //   context,
                    //   PageTransition(
                    //     type: PageTransitionType.fade,
                    //     duration: Duration(milliseconds: 300),
                    //     reverseDuration: Duration(milliseconds: 300),
                    //     child: CatsWidget(),
                    //   ),
                    // );
                  },
                ),
              ],
            ),
            Padding(
                padding: EdgeInsetsDirectional.fromSTEB(30, 44, 9, 0),
                child: Text("هل نسيت كلمة المرور ؟")),
          ],
        ),
      ),
    );
  }
}
