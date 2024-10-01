import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bouncerwidget/bouncerwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fawri_app_refactor/components/app-bar-widget/app-bar-widget.dart';
import 'package:fawri_app_refactor/pages/checkout/second-screen/second-screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';

class CheckoutFirstScreen extends StatefulWidget {
  var total, freeShipValue;
  CheckoutFirstScreen({
    Key? key,
    required this.total,
    required this.freeShipValue,
  }) : super(key: key);

  @override
  State<CheckoutFirstScreen> createState() => _CheckoutFirstScreenState();
}

class _CheckoutFirstScreenState extends State<CheckoutFirstScreen> {
  @override
  TextEditingController CoponController = TextEditingController();
  String dropdownValue = 'اختر منطقتك';
  bool _hasError = false;
  String CoponMessage = "";
  bool coponApplied = false;
  String discountPercentage = "0.0";
  bool checkCopon = false;
  bool status = false;
  bool coponed = false;
  var oldTotal;
  double delivery_price = 0.0;
  double discountPrice = 0.0;
  void _setDeliveryPrice() {
    if (dropdownValue == "الداخل") {
      if (discountPrice == 0) {
        delivery_price = 60.0;
      } else {
        delivery_price = 60.0 - discountPrice;
      }
    } else if (dropdownValue == "القدس") {
      if (discountPrice == 0) {
        delivery_price = 30.0;
      } else {
        delivery_price = 30.0 - discountPrice;
      }
    } else if (dropdownValue == "الضفه الغربيه") {
      if (discountPrice == 0) {
        delivery_price = 20.0;
      } else {
        delivery_price = 20.0 - discountPrice;
      }
    } else {
      delivery_price = 0.0;
    }
    if (widget.total >= int.parse(widget.freeShipValue.toString())) {
      delivery_price = delivery_price - 20;
    }
    setState(() {});
  }

  Timer? _couponMessageTimer;
  PageController _pageController = PageController();
  setControllers() async {
    oldTotal = widget.total.toString();
    setState(() {});
  }

  @override
  void initState() {
    _setDeliveryPrice();
    setControllers();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
          child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBarWidgetBack(
              cartKey: null,
              showCart: false,
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              key: Key("2"),
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.easeInOut,
                      transform: _hasError
                          ? Matrix4.translationValues(5, 0, 0)
                          : Matrix4.identity(),
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: _hasError ? Colors.red : Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton<String>(
                          underline: Container(),
                          icon: Icon(Icons.arrow_drop_down_rounded),
                          isExpanded: true,
                          value: dropdownValue,
                          items: <String>[
                            "اختر منطقتك",
                            'القدس',
                            'الداخل',
                            'الضفه الغربيه'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                            _setDeliveryPrice();
                          },
                        ),
                      ),
                    )),
                Visibility(
                  visible: int.parse(widget.freeShipValue.toString()) > 0,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.yellow[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "🛒 قم بشراء منتجات بقيمة ₪${int.parse(widget.freeShipValue.toString())} أو أكثر واحصل على 🚚 توصيل مجاني للضفة، و💰 10 شيكل فقط للقدس، و💸 40 شيكل للمناطق الأخرى!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                copounField(context),
                SizedBox(
                  height: 30,
                ),
                Container(
                  // height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "مجموع القطع : ",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₪${_safeRound(oldTotal)}",
                              style: TextStyle(
                                color: Color(0xff8F5C4B),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: CoponMessage == "" ? false : true,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "نسبة الخصم : ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "%${discountPercentage.toString().substring(0, 2)}",
                                style: TextStyle(
                                  color: Color(0xffC01C1C),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: CoponMessage == "" ? false : true,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "مبلغ التوفير : ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "₪${_calculateTotalDifference(oldTotal, widget.total)}",
                                    style: TextStyle(
                                      color: Color(0xffA8AA57),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "المبلغ النهائي بعد الخصم",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₪${widget.total.round()}",
                              style: TextStyle(
                                color: Color(0xff905D4C),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "التوصيل : ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₪$delivery_price",
                              style: TextStyle(
                                color: Color(0xffA8AA57),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(right: 30, left: 30),
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "المبلغ للدفع : ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₪${(delivery_price + widget.total).round()}",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: BouncingWidget(
                    child: ButtonWidget(
                        name: "متابعة عملية الشراء",
                        height: 60,
                        width: double.infinity,
                        BorderColor: Colors.black,
                        OnClickFunction: () {
                          if (dropdownValue == "اختر منطقتك") {
                            setState(() {
                              _hasError = true;
                              Vibration.vibrate(duration: 100);
                              Future.delayed(Duration(milliseconds: 1000), () {
                                setState(() {
                                  _hasError = false;
                                });
                              });
                            });
                          } else if (widget.total <
                              int.parse(widget.freeShipValue.toString())) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      "📦 أضف المزيد من المنتجات ليصبح مجموعك ₪${int.parse(widget.freeShipValue.toString())} لتحصل على 🚚 خصم على التوصيل!"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("لا، شكرا"),
                                      onPressed: () {
                                        NavigatorFunction(
                                          context,
                                          CheckoutSecondScreen(
                                            initialCity:
                                                dropdownValue.toString(),
                                            dropdownValue:
                                                dropdownValue.toString(),
                                            total: double.parse(
                                                widget.total.toString()),
                                          ),
                                        );
                                      },
                                    ),
                                    TextButton(
                                      child: Text("تصفح المزيد"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            NavigatorFunction(
                              context,
                              CheckoutSecondScreen(
                                initialCity: dropdownValue.toString(),
                                dropdownValue: dropdownValue.toString(),
                                total: double.parse(widget.total.toString()),
                              ),
                            );
                          }
                        },
                        BorderRaduis: 10,
                        ButtonColor: Colors.black,
                        NameColor: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  Column copounField(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "اظهار كود الخصم",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              FlutterSwitch(
                activeColor: Colors.green,
                width: 60.0,
                height: 30.0,
                valueFontSize: 25.0,
                toggleSize: 27.0,
                value: status,
                borderRadius: 30.0,
                padding: 3.0,
                // showOnOff: true,
                onToggle: (val) {
                  setState(() {
                    status = !status;
                  });
                },
              ),
            ],
          ),
        ),
        Visibility(
          visible: status ? true : false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: TextField(
                        controller: CoponController,
                        obscureText: false,
                        onChanged: (_) {
                          if (_ != "") {
                            setState(() {
                              checkCopon = true;
                            });
                          } else {
                            setState(() {
                              checkCopon = false;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "كود الخصم",
                        ),
                      ),
                    ),
                    Visibility(
                      visible: checkCopon,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            if (!coponApplied) {
                              if (CoponController.text == "noTawseel") {
                                var res = await getCoupunDeleteCose() ?? null;
                                if (res["active"] == true) {
                                  if (double.parse(widget.total.toString()) >
                                      double.parse(res["above"].toString())) {
                                    setState(() {
                                      discountPrice = double.parse(
                                          res["remove"].toString());
                                      delivery_price = delivery_price -
                                          double.parse(
                                              res["remove"].toString());
                                      coponApplied = true;
                                    });

                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.success,
                                      animType: AnimType.rightSlide,
                                      btnOkText: "حسنا",
                                      btnCancelText: "اغلاق",
                                      title: 'تم الخصم بنجاح!',
                                      desc:
                                          'تم خصم سعر التوصيل بقيمة ${res["remove"].toString()} شيكل',
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {},
                                    )..show();
                                  } else {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      btnOkText: "حسنا",
                                      btnCancelText: "اغلاق",
                                      title:
                                          'قيمة الطلبية يجب أن تكون اعلى من ${res["above"].toString()}',
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {},
                                    )..show();
                                  }
                                } else {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    btnOkText: "حسنا",
                                    btnCancelText: "اغلاق",
                                    title: 'الكود غير مفعل',
                                    desc: 'لم يعد هذا الكود مفعل',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {},
                                  )..show();
                                }
                              } else {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String UserID =
                                    prefs.getString('user_id') ?? "";
                                bool couponExists = await checkCouponInFirebase(
                                    CoponController.text, UserID.toString());
                                if (couponExists) {
                                  CoponMessage =
                                      "الكوبون المدخل مستخدم من قبل , الرجاء المحاولة فيما بعد";
                                  setState(() {});
                                  _couponMessageTimer?.cancel();

                                  // Set a new timer to clear the message after 15 seconds
                                  _couponMessageTimer =
                                      Timer(Duration(seconds: 5), () {
                                    setState(() {
                                      CoponMessage = "";
                                    });
                                  });
                                } else {
                                  var res =
                                      await getCoupun(CoponController.text) ??
                                          null;
                                  if (res.toString() == "null" ||
                                      res.toString() == "false") {
                                    CoponMessage =
                                        "الكوبون المدخل خاطئ , الرجاء المحاولة فيما بعد";
                                    setState(() {});
                                    _couponMessageTimer?.cancel();

                                    // Set a new timer to clear the message after 15 seconds
                                    _couponMessageTimer =
                                        Timer(Duration(seconds: 5), () {
                                      setState(() {
                                        CoponMessage = "";
                                      });
                                    });
                                  } else {
                                    CoponMessage =
                                        "تم خصم قيمة الكوبون من مجموع الطلبية";

                                    if (!coponed) {
                                      widget.total = widget.total * (1 - res);

                                      double _discountPercentage =
                                          100 * double.parse(res.toString());

                                      discountPercentage =
                                          _discountPercentage.toString();
                                    }
                                    coponed = true;
                                    setState(() {});
                                  }
                                }
                              }
                            } else {
                              setState(() {
                                CoponMessage = "تم استخدام الكوبون من قبل";
                              });
                              // Optionally, you can use a timer to clear the message after a few seconds
                              Timer(Duration(seconds: 5), () {
                                setState(() {
                                  CoponMessage = "";
                                });
                              });
                            }
                          },
                          child: Container(
                            width: 70,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: MAIN_COLOR),
                            child: Center(
                              child: Text(
                                "فحص",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: CoponMessage == "" ? false : true,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    children: [
                      Text(
                        CoponMessage,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> checkCouponInFirebase(String coupon, String userId) async {
    try {
      // Query Firestore to check if the coupon and user_id match any record
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('used_copons')
          .where('copon', isEqualTo: coupon)
          .where('user_id', isEqualTo: userId)
          .get();

      // If there are any matching records, return true
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle any errors here
      print("Error checking coupon in Firebase: $e");
      return false;
    }
  }

  // Inside your State class
  @override
  void dispose() {
    // Dispose the timer when the widget is disposed to prevent memory leaks
    _couponMessageTimer?.cancel();
    super.dispose();
  }

  int _safeRound(dynamic value) {
    if (value == null) {
      return 0; // Default value if `oldTotal` is null
    }
    try {
      return double.parse(value.toString()).round();
    } catch (e) {
      return 0; // Default value in case of a parsing error
    }
  }

  String _calculateTotalDifference(dynamic oldTotal, dynamic newTotal) {
    // Handle null values by providing a default value of 0.0
    double oldTotalValue =
        oldTotal != null ? double.parse(oldTotal.toString()) : 0.0;
    double newTotalValue = 0.0;

    if (newTotal != null) {
      String newTotalStr = newTotal.toString();
      if (newTotalStr.length > 5) {
        newTotalStr = newTotalStr.substring(0, 5);
      }
      newTotalValue = double.parse(newTotalStr);
    }

    double difference = oldTotalValue - newTotalValue;
    return difference.round().toStringAsFixed(2);
  }
}
