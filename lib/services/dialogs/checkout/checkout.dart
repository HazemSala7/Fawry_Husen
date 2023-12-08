import 'package:bouncerwidget/bouncerwidget.dart';
import 'package:confetti/confetti.dart';
import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/firebase/order/OrderFirebaseModel.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';

import '../../../LocalDB/Provider/CartProvider.dart';
import '../../../firebase/cart/CartController.dart';
import '../../../firebase/user/UserController.dart';
import '../../../firebase/user/UserModel.dart';

class CheckoutBottomDialog extends StatefulWidget {
  var total;
  CheckoutBottomDialog({
    Key? key,
    required this.total,
  }) : super(key: key);

  @override
  State<CheckoutBottomDialog> createState() => _CheckoutBottomDialogState();
}

class _CheckoutBottomDialogState extends State<CheckoutBottomDialog> {
  @override
  String dropdownValue = 'اختر منطقتك';
  ConfettiController? _confettiController;

  bool status = false;
  bool clicked = false;
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
    _confettiController = ConfettiController(duration: Duration(seconds: 2));

    super.initState();
  }

  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: double.maxFinite,
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Material(
            child: Column(
              children: [
                Container(
                    height: 560 - _progress * 25,
                    width: double.infinity,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                      ),
                    ], color: Colors.white),
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children: [
                        FirstScreen(),
                        SecondScreen(),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (value.length != 10) {
      return 'يجب أن يكون مجموع خانات الهاتف 10 أرقام';
    }
    if (!value.startsWith('05')) {
      return 'رقم الهاتف يجب ان يبدأ ب 05';
    }
    return null; // Return null if the input is valid
  }

  Widget SecondScreen() {
    return SingleChildScrollView(
      child: Column(
        key: Key("1"),
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "الأسم",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    controller: NameController,
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MAIN_COLOR, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                      ),
                      hintText: "الأسم",
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "رقم الهاتف",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    child: TextFormField(
                      controller: PhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MAIN_COLOR, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                        ),
                        hintText: "رقم الهاتف",
                      ),
                      validator: validatePhoneNumber,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "المدينة",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    controller: CityController,
                    obscureText: false,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MAIN_COLOR, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                      ),
                      hintText: "المدينة",
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "العنوان",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    controller: AddressController,
                    obscureText: false,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MAIN_COLOR, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                      ),
                      hintText: "العنوان",
                    ),
                  ),
                ),
              ),
            ],
          ),
          loading
              ? Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Container(
                    height: 50,
                    width: 300,
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
                  padding: const EdgeInsets.only(top: 30),
                  child: BouncingWidget(
                    child: ButtonWidget(
                        name: "تأكيد عمليه الشراء",
                        height: 50,
                        width: 300,
                        BorderColor: Colors.black,
                        OnClickFunction: () async {
                          if (PhoneController.text == "" ||
                              AddressController.text == "" ||
                              CityController.text == "") {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                    "الرجاء تعبئه جميع البيانات",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  actions: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: MAIN_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: Text(
                                            "حسنا",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              await addOrder(
                                context: context,
                                address: AddressController.text,
                                city: CityController.text,
                                phone: PhoneController.text,
                                name: NameController.text,
                              );
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String UserID = prefs.getString('user_id') ?? "";
                              String? TOKEN =
                                  await prefs.getString('device_token');
                              await prefs.setString(
                                  'name', NameController.text);
                              await prefs.setString(
                                  'city', CityController.text);
                              await prefs.setString(
                                  'area', AreaController.text);
                              await prefs.setString(
                                  'phone', PhoneController.text);
                              await prefs.setString(
                                  'address', AddressController.text);
                              UserItem updatedUser = UserItem(
                                id: UserID,
                                token: TOKEN.toString(),
                                email: "$UserID@email.com",
                                phone: PhoneController.text,
                                city: CityController.text,
                                area: AreaController.text,
                                address: AddressController.text,
                                password: '123',
                              );
                              try {
                                final cartProvider = Provider.of<CartProvider>(
                                    context,
                                    listen: false);
                                await userService.updateUser(updatedUser);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: EdgeInsets.all(0),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Lottie.asset(
                                                  "assets/lottie_animations/Animation - 1701597212878.json",
                                                  height: 300,
                                                  reverse: true,
                                                  repeat: true,
                                                  fit: BoxFit.cover),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  "شكرا لشرائك من فوري ستحتاج الطلبية من ٣-٤ ايام ، يمكنك متابعة الطلب من قسم طلباتي الحالية",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 40,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  NavigatorFunction(
                                                      context,
                                                      HomeScreen(
                                                          selectedIndex: 0));
                                                },
                                                child: Container(
                                                  width: 200,
                                                  height: 40,
                                                  child: Center(
                                                      child: Text(
                                                    "الصفحة الرئيسية",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  )),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.black),
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                                  },
                                );

                                cartProvider.clearCart();
                                // NavigatorFunction(
                                //     context, HomeScreen(selectedIndex: 0));
                              } catch (e) {
                                print('Error updating user data: $e');
                              }
                            }
                          }
                        },
                        BorderRaduis: 10,
                        ButtonColor: Colors.black,
                        NameColor: Colors.white),
                  ),
                ),
        ],
      ),
    );
  }

  String CoponMessage = "";

  bool loading = false;

  Widget FirstScreen() {
    return Column(
      key: Key("2"),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "المنطقه : ",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                transform: _hasError
                    ? Matrix4.translationValues(5, 0, 0)
                    : Matrix4.identity(),
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: _hasError ? Colors.red : Colors.black,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton<String>(
                    underline: Container(),
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
                                fontSize: 14,
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
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "اظهار كود الخصم",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                padding: const EdgeInsets.only(top: 5, right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "كود الخصم",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    controller: CoponController,
                    obscureText: false,
                    decoration: InputDecoration(
                      suffix: Visibility(
                        visible: CoponController.text == "" ? false : true,
                        child: InkWell(
                          onTap: () async {
                            var res =
                                await getCoupun(CoponController.text) ?? null;
                            if (res.toString() == "null" ||
                                res.toString() == "false") {
                              CoponMessage =
                                  "الكوبون المدخل خاطئ , الرجاء المحاولة فيما بعد";
                              setState(() {});
                            } else {
                              CoponMessage =
                                  "تم خصم قيمة الكوبون من مجموع الطلبية";
                              setState(() {
                                widget.total = widget.total * (1 - res);
                              });
                            }
                            print("CoponMessage");
                            print(CoponMessage);
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
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MAIN_COLOR, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                      ),
                      hintText: "كود الخصم",
                    ),
                  ),
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
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "المجموع : ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "₪${widget.total}",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "المبلغ النهائي بعد الخصم",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "₪${widget.total}",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "التوصيل : ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "₪${dropdownValue.toString() == "الداخل" ? "60" : dropdownValue.toString() == "القدس" ? "30" : dropdownValue.toString() == "الضفه الغربيه" ? "20" : "0"}",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30, left: 30),
          child: Container(
            width: double.infinity,
            height: 1,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "المبلغ للدفع : ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "₪${dropdownValue.toString() == "الداخل" ? 60.0 + double.parse(widget.total.toString()) : dropdownValue.toString() == "القدس" ? 30.0 + double.parse(widget.total.toString()) : dropdownValue.toString() == "الضفه الغربيه" ? 20.0 + double.parse(widget.total.toString()) : double.parse(widget.total.toString())}",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: BouncingWidget(
            child: ButtonWidget(
                name: "تأكيد عمليه الشراء",
                height: 50,
                width: 300,
                BorderColor: Colors.black,
                OnClickFunction: () {
                  if (dropdownValue.toString() == "اختر منطقتك") {
                    setState(() {
                      _hasError = true;
                      Vibration.vibrate(duration: 100);
                      // Resetting error state after a short duration
                      Future.delayed(Duration(milliseconds: 1000), () {
                        setState(() {
                          _hasError = false;
                        });
                      });
                    });
                  } else {
                    setState(() {
                      clicked = true;
                    });
                    _pageController.animateToPage(1,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.ease);
                  }
                },
                BorderRaduis: 10,
                ButtonColor: Colors.black,
                NameColor: Colors.white),
          ),
        )
      ],
    );
  }

  bool _hasError = false;

  TextEditingController CoponController = TextEditingController();
  TextEditingController NameController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController CityController = TextEditingController();
  TextEditingController AreaController = TextEditingController();
  TextEditingController AddressController = TextEditingController();
  final UserService userService = UserService();

  Widget sizeWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          onTap: () {},
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 233, 233, 233),
                shape: BoxShape.circle),
            child: Center(
              child: Text(
                "40",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          )),
    );
  }
}
