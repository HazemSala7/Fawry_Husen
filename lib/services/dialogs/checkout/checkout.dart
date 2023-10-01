import 'package:bouncerwidget/bouncerwidget.dart';
import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../LocalDB/Provider/CartProvider.dart';
import '../../../firebase/cart/CartController.dart';
import '../../../firebase/user/UserController.dart';
import '../../../firebase/user/UserModel.dart';

class CheckoutBottomDialog extends StatefulWidget {
  final total;
  const CheckoutBottomDialog({Key? key, this.total}) : super(key: key);

  @override
  State<CheckoutBottomDialog> createState() => _CheckoutBottomDialogState();
}

class _CheckoutBottomDialogState extends State<CheckoutBottomDialog> {
  @override
  String dropdownValue = 'اختر منطقتك';
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
                    height: 550 - _progress * 104,
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
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget SecondScreen() {
    return Column(
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
                    "رقم الهاتف",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  controller: PhoneController,
                  obscureText: false,
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    "المنطقة",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  controller: AreaController,
                  obscureText: false,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MAIN_COLOR, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                    ),
                    hintText: "المنطقة",
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            AreaController.text == "" ||
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
                          setState(() {
                            loading = true;
                          });
                          print("dropdownValue");
                          print(dropdownValue);
                          print(PhoneController.text);
                          print(CityController.text);
                          print(AreaController.text);
                          print(AddressController.text);
                          await addOrder(
                            context: context,
                            address: AddressController.text,
                            city: CityController.text,
                            phone: PhoneController.text,
                          );
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String UserID = prefs.getString('user_id') ?? "";
                          UserItem updatedUser = UserItem(
                            id: UserID,
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
                            Fluttertoast.showToast(
                                msg: "تم اضافه الطلبيه بنجاح");
                            cartProvider.clearCart();
                            NavigatorFunction(context, HomeScreen());
                          } catch (e) {
                            print('Error updating user data: $e');
                          }
                        }
                      },
                      BorderRaduis: 10,
                      ButtonColor: Colors.black,
                      NameColor: Colors.white),
                ),
              ),
      ],
    );
  }

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
              Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(),
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
                    // controller: valueafterController,
                    obscureText: false,
                    readOnly: true,
                    decoration: InputDecoration(
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text("خطأ"),
                          content: Text("الرجاء اختيار المنطقه"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("موافق"),
                            ),
                          ],
                        );
                      },
                    );
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
