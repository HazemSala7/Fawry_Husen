import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/pages/account_information/account_information.dart';
import 'package:fawri_app_refactor/pages/cart/cart.dart';
import 'package:fawri_app_refactor/pages/newest_orders/newest_orders.dart';
import 'package:fawri_app_refactor/pages/order_details/order_details.dart';
import 'package:fawri_app_refactor/pages/orders/orders.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../firebase/user/UserController.dart';
import '../../authentication/login_screen/login_screen.dart';
import '../../privacy_policy/privacy_policy.dart';
import '../../switch_policy/switch_policy.dart';
import '../../who/who.dart';
import '../home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  bool Login = false;
  String user_id = "";
  setControllers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? login = prefs.getBool('login');
    String UserID = prefs.getString('user_id') ?? "";
    user_id = UserID;
    if (login == true) {
      Login = true;
    } else {
      Login = false;
    }
    setState(() {});
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    setControllers();
  }

  final UserService userService = UserService();
  deleteUser() async {
    try {
      await userService.deleteUserById(user_id);
      Fluttertoast.showToast(msg: "تم حذف حسابك بنجاح!");
    } catch (e) {
      // Handle errors, show alerts, etc.
      print('Error deleting user: $e');
    }
  }

  _confirmDeleteUser() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("هل تريد بالتأكيد حذف هذا حسابك"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    await preferences.clear();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                    deleteUser();
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MAIN_COLOR),
                    child: Center(
                      child: Text(
                        "نعم",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MAIN_COLOR),
                    child: Center(
                      child: Text(
                        "لا",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 7,
                  blurRadius: 5,
                ),
              ], borderRadius: BorderRadius.circular(4), color: Colors.white),
              child: Column(
                children: [
                  addressMethod(name: "الملخص"),
                  lineMethod(),
                  profileCard(
                      name: "السله",
                      image: "assets/images/shopping-cart.png",
                      iconornot: false,
                      NavigatorFunction: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Cart()));
                      }),
                  lineMethod(),
                  profileCard(
                      name: "المفضله",
                      iconornot: false,
                      image: "assets/images/heart.png",
                      icon: Icons.request_quote,
                      NavigatorFunction: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      selectedIndex: 2,
                                    )));
                      }),
                  lineMethod(),
                  profileCard(
                      name: "طلباتي الحالية",
                      iconornot: false,
                      image: "assets/images/order-delivery.png",
                      icon: Icons.request_quote,
                      NavigatorFunction: () {
                        NavigatorFunction(
                            context,
                            NewestOrders(
                              user_id: user_id,
                            ));
                      }),
                  lineMethod(),
                  profileCard(
                      name: "طلباتي السابقة",
                      iconornot: true,
                      image: "assets/images/heart.png",
                      icon: Icons.request_quote,
                      NavigatorFunction: () {
                        NavigatorFunction(
                            context,
                            Orders(
                              user_id: user_id,
                            ));
                      }),
                  lineMethod(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 7,
                  blurRadius: 5,
                ),
              ], borderRadius: BorderRadius.circular(4), color: Colors.white),
              child: Column(
                children: [
                  addressMethod(name: "حسابي"),
                  lineMethod(),
                  profileCard(
                      name: "المعلومات الشخصيه",
                      icon: Icons.person,
                      iconornot: true,
                      NavigatorFunction: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String name = prefs.getString('name') ?? "";
                        String phone = prefs.getString('phone') ?? "";
                        String address = prefs.getString('address') ?? "";
                        String area = prefs.getString('area') ?? "";
                        String city = prefs.getString('city') ?? "";
                        String birthday = prefs.getString('birthdate') ?? "";
                        NavigatorFunction(
                            context,
                            AccountInformation(
                              address: address,
                              area: area,
                              city: city,
                              birthday: birthday,
                              name: name,
                              phone: phone,
                            ));
                      }),
                  lineMethod(),
                  Login
                      ? profileCard(
                          name: "تسجيل خروج",
                          icon: Icons.logout,
                          iconornot: true,
                          NavigatorFunction: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.clear();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          })
                      : profileCard(
                          name: "تسجيل دخول",
                          icon: Icons.login,
                          iconornot: true,
                          NavigatorFunction: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          }),
                  lineMethod(),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 20, right: 15, left: 15, bottom: 30),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 7,
                  blurRadius: 5,
                ),
              ], borderRadius: BorderRadius.circular(4), color: Colors.white),
              child: Column(
                children: [
                  addressMethod(name: "المزيد"),
                  // lineMethod(),
                  // profileCard(
                  //   name: "للمساعده & التواصل",
                  //   icon: Icons.person,
                  //   iconornot: true,
                  // ),
                  lineMethod(),
                  profileCard(
                      name: "معلومات عنا",
                      icon: Icons.info,
                      iconornot: true,
                      NavigatorFunction: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WhoWeAre()));
                      }),
                  lineMethod(),
                  profileCard(
                      name: "سياسه الخصوصيه",
                      icon: Icons.privacy_tip,
                      iconornot: true,
                      NavigatorFunction: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Privacy()));
                      }),
                  lineMethod(),
                  profileCard(
                      name: "سياسه التبديل",
                      icon: Icons.privacy_tip,
                      iconornot: true,
                      NavigatorFunction: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SwitchPolicy()));
                      }),
                  lineMethod(),
                  profileCard(
                      name: "حذف حسابي",
                      icon: Icons.delete,
                      iconornot: true,
                      NavigatorFunction: () {
                        _confirmDeleteUser();
                      }),
                  lineMethod(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addressMethod({String name = ""}) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 45,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Row(
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget lineMethod() {
    return Container(
      width: double.infinity,
      height: 1,
      color: Color(0xffD6D3D3),
    );
  }

  Widget profileCard(
      {String name = "",
      IconData? icon,
      Function? NavigatorFunction,
      bool iconornot = false,
      String image = ""}) {
    return InkWell(
      onTap: () {
        NavigatorFunction!();
      },
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 45,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  iconornot
                      ? Icon(
                          icon,
                          color: MAIN_COLOR,
                        )
                      : Image.asset(
                          image,
                          height: 25,
                          width: 25,
                          color: MAIN_COLOR,
                        ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    name,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Icon(Icons.arrow_right_sharp)
            ],
          ),
        ),
      ),
    );
  }
}
