import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 16,
          left: 16,
          top: 16),
      child: SingleChildScrollView(
        child: sms
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: SMSController,
                    decoration: InputDecoration(labelText: 'أدخل رمز التأكيد'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: phomeController.text,
                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent:
                            (String verificationId, int? resendToken) async {
                          String smsCode = SMSController.text;
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: smsCode);
                          await auth.signInWithCredential(credential);
                          Fluttertoast.showToast(msg: "تم تسجيل دخولك بنجاح!");
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    },
                    child: Text('تأكيد الرمز'),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: phomeController,
                    decoration: InputDecoration(labelText: 'أدخل رقم الهاتف'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        sms = true;
                      });
                    },
                    child: Text('ارسال الرمز'),
                  ),
                ],
              ),
      ),
    );
  }

  void _verifyOTP(BuildContext context) {
    // Perform OTP verification logic here
    // You can use a package like `sms_otp_auto_verify` for auto-verification
    // Once verification is successful, you can close the bottom dialog
    Navigator.pop(context);
    // You can also show a success message or navigate to a new screen
  }
}
