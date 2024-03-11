import 'package:bouncerwidget/bouncerwidget.dart';
import 'package:confetti/confetti.dart';
import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/firebase/order/OrderFirebaseModel.dart';
import 'package:fawri_app_refactor/pages/chooses_birthdate/chooses_birthdate.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';

import '../../../LocalDB/Models/AddressItem.dart';
import '../../../LocalDB/Provider/AddressProvider.dart';
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
  bool checkCopon = false;
  bool clicked = false;
  late PageController _pageController;
  setControllers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? buy = await prefs.getBool('buy') ?? false;
    if (buy) {
      String name = prefs.getString('name') ?? "";
      String phone = prefs.getString('phone') ?? "";
      editName = false;
      editPhone = false;
      chooseAddress = false;
      NameController.text = name.toString();
      PhoneController.text = phone.toString();
    } else {
      editName = true;
      editPhone = true;
      chooseAddress = true;
      NameController.text = "";
      PhoneController.text = "";
    }
  }

  double _progress = 0;
  @override
  void initState() {
    setControllers();
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
                    height: 600 - _progress * 30,
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
    return null;
  }

  bool editName = false;
  bool editPhone = false;
  bool chooseAddress = false;
  String selectedCity = 'الخليل';
  String selectedArea = 'اختر العنوان';
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  Widget SecondScreen() {
    return SingleChildScrollView(
      child: Column(
        key: Key("1"),
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "أسم المستخدم",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: MAIN_COLOR),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          editName
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15, top: 5),
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    child: TextField(
                                      controller: NameController,
                                      obscureText: false,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: MAIN_COLOR, width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2.0,
                                              color: Color(0xffD6D3D3)),
                                        ),
                                        hintText: "الأسم",
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        NameController.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 83, 83, 83),
                                            fontSize: 20),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              editName = true;
                                            });
                                          },
                                          icon: Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "رقم الهاتف",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: MAIN_COLOR),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          editPhone
                              ? Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 15, top: 5),
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: PhoneController,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: MAIN_COLOR, width: 2.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2.0,
                                                color: Color(0xffD6D3D3)),
                                          ),
                                          hintText: "رقم الهاتف",
                                        ),
                                        validator: validatePhoneNumber,
                                      ),
                                    ),
                                  ),
                                )
                              : Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 25),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          PhoneController.text,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 83, 83, 83),
                                              fontSize: 20),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                editPhone = true;
                                              });
                                            },
                                            icon: Icon(Icons.edit))
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, bottom: 10),
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
          Consumer<AddressProvider>(
            builder: (context, addressprovider, _) {
              List<AddressItem> addressItems = addressprovider.addressItems;
              return Visibility(
                visible: addressItems.length == 0 ? false : true,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: Container(
                    height: 55,
                    child: DropdownButtonFormField(
                      hint: Text("اختر العنوان"),
                      value: null,
                      items: addressItems
                          .map((address) => DropdownMenuItem(
                                child: Text(address.name),
                                value: address.name,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedArea = value.toString();
                        });
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MAIN_COLOR, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0, color: MAIN_COLOR),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 10),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      elevation: 0,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 15, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "المنطقة",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          DropdownButtonFormField(
                            value: selectedCity,
                            items: [
                              'الخليل',
                              'القدس',
                              'بيت لحم',
                              'جنين',
                              'رام الله',
                              'سلفيت',
                              'طوباس',
                              'قرى القدس',
                              'قلقيلة',
                              'نابلس ',
                              'مناطق ال 48'
                            ]
                                .map((area) => DropdownMenuItem(
                                      child: Text(area),
                                      value: area,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCity = value.toString();
                              });
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: MAIN_COLOR, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1.0, color: MAIN_COLOR),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 10, left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "العنوان",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          TextFormField(
                            controller: addressController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: MAIN_COLOR, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1.0, color: MAIN_COLOR),
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        ButtonWidget(
                            name: "تأكيد العنوان",
                            height: 40,
                            width: double.infinity,
                            BorderColor: MAIN_COLOR,
                            OnClickFunction: () async {
                              final addressProviderFinal =
                                  Provider.of<AddressProvider>(context,
                                      listen: false);
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String UserID = prefs.getString('user_id') ?? "";
                              final newItem = AddressItem(
                                user_id: UserID,
                                name:
                                    "$selectedCity ,${addressController.text} ",
                              );
                              addressProviderFinal.addToAddress(newItem);
                              Fluttertoast.showToast(
                                  msg: "تم اضافة العنوان بنجاح");
                              Navigator.pop(context);
                            },
                            BorderRaduis: 10,
                            ButtonColor: MAIN_COLOR,
                            NameColor: Colors.white)
                      ],
                    );
                  },
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.plus,
                    size: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "اضافة عنوان جديد",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "الوصف",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                child: Container(
                  height: 80,
                  width: double.infinity,
                  child: TextField(
                    controller: OrderController,
                    obscureText: false,
                    maxLines: 5,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MAIN_COLOR, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                      ),
                      hintText: "الوصف",
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
                              selectedArea.toString() == "" ||
                              selectedArea.toString() == "اختر العنوان") {
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
                            // if(editPhone){

                            // }
                            // else {

                            // }
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              var TOTALFINAL = dropdownValue.toString() ==
                                      "الداخل"
                                  ? 60.0 + double.parse(widget.total.toString())
                                  : dropdownValue.toString() == "القدس"
                                      ? 30.0 +
                                          double.parse(
                                              widget.total.toString().length > 5
                                                  ? widget.total
                                                      .toString()
                                                      .substring(0, 5)
                                                  : widget.total.toString())
                                      : dropdownValue.toString() ==
                                              "الضفه الغربيه"
                                          ? 20.0 +
                                              double.parse(widget.total
                                                          .toString()
                                                          .length >
                                                      5
                                                  ? widget.total
                                                      .toString()
                                                      .substring(0, 5)
                                                  : widget.total.toString())
                                          : widget.total.toString().length > 5
                                              ? widget.total
                                                  .toString()
                                                  .substring(0, 5)
                                              : widget.total.toString();
                              await addOrder(
                                  context: context,
                                  address: selectedArea.toString(),
                                  city: selectedArea.toString(),
                                  phone: PhoneController.text,
                                  name: NameController.text,
                                  description: OrderController.text,
                                  total: TOTALFINAL.toString());
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String UserID = prefs.getString('user_id') ?? "";
                              String? TOKEN =
                                  await prefs.getString('device_token');
                              await prefs.setString(
                                  'name', NameController.text);
                              await prefs.setString(
                                  'city', selectedArea.toString());
                              await prefs.setString(
                                  'area', AreaController.text);
                              await prefs.setString(
                                  'phone', PhoneController.text);
                              await prefs.setString(
                                  'address', selectedArea.toString());
                              UserItem updatedUser = UserItem(
                                id: UserID,
                                token: TOKEN.toString(),
                                email: "$UserID@email.com",
                                phone: PhoneController.text,
                                city: selectedArea.toString(),
                                area: selectedArea.toString(),
                                address: selectedArea.toString(),
                                password: '123',
                              );
                              try {
                                final cartProvider = Provider.of<CartProvider>(
                                    context,
                                    listen: false);
                                await userService.updateUser(updatedUser);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                getCoupunRedeem(CoponController.text);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: EdgeInsets.all(0),
                                        child: InkWell(
                                          onTap: () async {
                                            NavigatorFunction(context,
                                                HomeScreen(selectedIndex: 0));
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            bool? show = await prefs
                                                    .getBool('show_birthday') ??
                                                true;
                                            show
                                                ? NavigatorFunction(
                                                    context,
                                                    ChooseBirthdate(
                                                      name: NameController.text,
                                                    ))
                                                : null;
                                          },
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 40,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    NavigatorFunction(
                                                        context,
                                                        HomeScreen(
                                                            selectedIndex: 0));
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    bool? show =
                                                        await prefs.getBool(
                                                                'show_birthday') ??
                                                            true;
                                                    show
                                                        ? NavigatorFunction(
                                                            context,
                                                            ChooseBirthdate(
                                                              name:
                                                                  NameController
                                                                      .text,
                                                            ))
                                                        : null;
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
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.black),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                                  },
                                );

                                cartProvider.clearCart();
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('buy', true);
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
  bool coponed = false;

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
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: MAIN_COLOR, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xffD6D3D3)),
                          ),
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

                              if (!coponed) {
                                widget.total = widget.total * (1 - res);
                              }
                              coponed = true;
                              setState(() {});
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
                "₪${widget.total.toString().length > 5 ? widget.total.toString().substring(0, 5) : widget.total.toString()}",
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
                "₪${widget.total.toString().length > 5 ? widget.total.toString().substring(0, 5) : widget.total.toString()}",
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
                "₪${dropdownValue.toString() == "الداخل" ? 60.0 + double.parse(widget.total.toString()) : dropdownValue.toString() == "القدس" ? 30.0 + double.parse(widget.total.toString().length > 5 ? widget.total.toString().substring(0, 5) : widget.total.toString()) : dropdownValue.toString() == "الضفه الغربيه" ? 20.0 + double.parse(widget.total.toString().length > 5 ? widget.total.toString().substring(0, 5) : widget.total.toString()) : widget.total.toString().length > 5 ? widget.total.toString().substring(0, 5) : widget.total.toString()}",
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
  TextEditingController OrderController = TextEditingController();
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
