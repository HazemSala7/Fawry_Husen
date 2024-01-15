import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

import '../../../../components/button_widget/button_widget.dart';
import '../../../../constants/constants.dart';

class BottomDialog extends StatefulWidget {
  @override
  State<BottomDialog> createState() => _BottomDialogState();
}

class _BottomDialogState extends State<BottomDialog> {
  @override
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController phomeController = TextEditingController();

  TextEditingController SMSController = TextEditingController();

  bool sms = false;
  List<String> list = <String>[
    '972+',
    '970+',
  ];
  String dropdownValue = "972+";
  late PageController _pageController;
  double _progress = 0;
  @override
  void initState() {
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _progress = _pageController.page ?? 0;
        });
      });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 16,
          left: 16,
          top: 16),
      child: SingleChildScrollView(
        child:
            // sms
            //     ? Column(
            //         mainAxisSize: MainAxisSize.min,
            //         children: <Widget>[
            //           Text(
            //             "هيا نتحقق من الرقم",
            //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            //           ),
            //           TextField(
            //             controller: SMSController,
            //             decoration: InputDecoration(labelText: 'أدخل رمز التأكيد'),
            //           ),
            //           SizedBox(height: 16.0),
            //           ElevatedButton(
            //             onPressed: () async {
            //               await FirebaseAuth.instance.verifyPhoneNumber(
            //                 phoneNumber: phomeController.text,
            //                 verificationCompleted:
            //                     (PhoneAuthCredential credential) {},
            //                 verificationFailed: (FirebaseAuthException e) {},
            //                 codeSent:
            //                     (String verificationId, int? resendToken) async {
            //                   String smsCode = SMSController.text;
            //                   PhoneAuthCredential credential =
            //                       PhoneAuthProvider.credential(
            //                           verificationId: verificationId,
            //                           smsCode: smsCode);
            //                   await auth.signInWithCredential(credential);
            //                   Fluttertoast.showToast(msg: "تم تسجيل دخولك بنجاح!");
            //                 },
            //                 codeAutoRetrievalTimeout: (String verificationId) {},
            //               );
            //             },
            //             child: Text('تأكيد الرمز'),
            //           ),
            //         ],
            //       )
            // :
            Container(
                height: 660 - _progress * 25,
                width: double.infinity,
                // decoration: BoxDecoration(boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.2),
                //     blurRadius: 5,
                //   ),
                // ], color: Colors.white),
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    EnterPhoneMethod(),
                    VerificationMethod(),
                    DoneSuccessPhone(),
                  ],
                )),
        // EnterPhoneMethod(),
      ),
    );
  }

  Widget EnterPhoneMethod() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "هيا نتحقق من الرقم",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Image.asset(
            "assets/images/opt1.png",
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "من فضلك ادخل رقم موبايلك لتسليمك رمز الحقق",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 50, left: 50, top: 40),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xffCBCBCB))),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 40,
                    child: TextField(
                      controller: phomeController,
                      obscureText: false,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(right: 10, left: 10),
                        hintText: "Ex : 599 567 124",
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Container(
                      height: 40,
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: SizedBox(),
                        elevation: 16,
                        // style: const TextStyle(color: Colors.deepPurple),
                        underline: SizedBox(),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.arrow_drop_down),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  value,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Image.network(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Flag_of_Palestine.svg/1200px-Flag_of_Palestine.svg.png",
                                  height: 35,
                                  width: 25,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    )),
              ],
            ),
          ),
        ),
        // TextField(
        //   controller: phomeController,
        //   decoration: InputDecoration(labelText: 'أدخل رقم الهاتف'),
        // ),
        SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonWidget(
              name: "أرسل",
              height: 40,
              width: double.infinity,
              BorderColor: MAIN_COLOR,
              OnClickFunction: () {
                _pageController.animateToPage(1,
                    duration: Duration(milliseconds: 200), curve: Curves.ease);
              },
              BorderRaduis: 4,
              ButtonColor: MAIN_COLOR,
              NameColor: Colors.white),
        ),
        // ElevatedButton(
        //   onPressed: () async {
        //     setState(() {
        //       sms = true;
        //     });
        //   },
        //   child: Text('ارسال الرمز'),
        // ),
      ],
    );
  }

  Widget DoneSuccessPhone() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "رائع !",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Image.asset(
            "assets/images/opt3.png",
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "تم التحقق من رقم هاتفك بنجاح !",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
          ),
        ),
        SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonWidget(
              name: "انطلق",
              height: 40,
              width: double.infinity,
              BorderColor: Colors.green,
              OnClickFunction: () {
                _pageController.animateToPage(1,
                    duration: Duration(milliseconds: 200), curve: Curves.ease);
              },
              BorderRaduis: 4,
              ButtonColor: MAIN_COLOR,
              NameColor: Colors.white),
        ),
        // ElevatedButton(
        //   onPressed: () async {
        //     setState(() {
        //       sms = true;
        //     });
        //   },
        //   child: Text('ارسال الرمز'),
        // ),
      ],
    );
  }

  Widget VerificationMethod() {
    return Column(
      children: <Widget>[
        Text(
          "أدخل رمز التحقق",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Image.asset(
            "assets/images/opt2.png",
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          "من فضلك أدخل رمز التحقق الذي أرسل الى الرقم ${phomeController.text}",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
        ),
        SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: TextFieldPin(
                textController: textEditingController,
                autoFocus: true,
                codeLength: _otpCodeLength,
                alignment: MainAxisAlignment.center,
                defaultBoxSize: 55.0,
                margin: 10,
                selectedBoxSize: 55.0,
                textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                // defaultDecoration: _pinPutDecoration.copyWith(
                //     border: Border.all(
                //         color:
                //             Theme.of(context).primaryColor.withOpacity(0.6))),
                selectedDecoration: BoxDecoration(
                  border: Border.all(color: MAIN_COLOR, width: 2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                defaultDecoration: BoxDecoration(
                  border: Border.all(color: Color(0xffD9D9D9), width: 2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                onChange: (code) {
                  setState(() {});
                }),
          ),
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            Text(
              "ألم يتم الارسال ؟ ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "الارسال مجددا",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color.fromARGB(255, 23, 124, 27)),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        ButtonWidget(
            name: "تأكيد الرمز",
            height: 40,
            width: double.infinity,
            BorderColor: MAIN_COLOR,
            OnClickFunction: () {},
            BorderRaduis: 4,
            ButtonColor: MAIN_COLOR,
            NameColor: Colors.white)
      ],
    );
  }

  int _otpCodeLength = 4;
  TextEditingController textEditingController = TextEditingController();
  String _otpCode = "";

  void _verifyOTP(BuildContext context) {
    // Perform OTP verification logic here
    // You can use a package like `sms_otp_auto_verify` for auto-verification
    // Once verification is successful, you can close the bottom dialog
    Navigator.pop(context);
    // You can also show a success message or navigate to a new screen
  }
}
