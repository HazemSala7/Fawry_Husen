import 'package:bouncerwidget/bouncerwidget.dart';
import 'package:fawri_app_refactor/components/app-bar-widget/app-bar-widget.dart';
import 'package:fawri_app_refactor/components/cutom-text-field/cutom-text-field.dart';
import 'package:fawri_app_refactor/firebase/user/UserController.dart';
import 'package:fawri_app_refactor/pages/checkout/add-address/add-address.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fawri_app_refactor/LocalDB/Models/AddressItem.dart';
import 'package:fawri_app_refactor/LocalDB/Provider/AddressProvider.dart';
import 'package:fawri_app_refactor/LocalDB/Provider/CartProvider.dart';
import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/firebase/user/UserModel.dart';
import 'package:fawri_app_refactor/model/Area/area.dart';
import 'package:fawri_app_refactor/model/City/city.dart';
import 'package:fawri_app_refactor/pages/chooses_birthdate/chooses_birthdate.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:fawri_app_refactor/pages/newest_orders/newest_orders.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:fawri_app_refactor/services/dialogs/checkout/area_city_service/area_city_service.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutSecondScreen extends StatefulWidget {
  var total;
  String dropdownValue = 'اختر منطقتك';
  CheckoutSecondScreen({
    Key? key,
    required this.total,
    required this.dropdownValue,
  }) : super(key: key);

  @override
  State<CheckoutSecondScreen> createState() => _CheckoutSecondScreenState();
}

class _CheckoutSecondScreenState extends State<CheckoutSecondScreen> {
  @override
  bool editName = false;
  bool editPhone = false;
  bool chooseAddress = false;
  bool loading = false;
  bool coponed = false;
  City? selectedCity;
  AddressItem? selectedArea;
  String finalSelectedArea = "";
  City? selectedCity1;
  Area? selectedArea1;
  List<City> cities = [];
  List<Area> areas = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController NameController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController CoponController = TextEditingController();
  TextEditingController AreaController = TextEditingController();
  TextEditingController OrderController = TextEditingController();
  final UserService userService = UserService();

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
    cities = CityService().loadCities();
    final addressItems = context.read<AddressProvider>().addressItems;
    if (addressItems.isNotEmpty && selectedArea == null) {
      setState(() {
        finalSelectedArea = addressItems[0].name;
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    setControllers();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
          child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: AppBarWidgetBack(
                  cartKey: null,
                  showCart: false,
                )),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 25,
                  left: 25,
                ),
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
                                    editName
                                        ? CustomTextField(
                                            onEdit: () {},
                                            showEdit: false,
                                            validator: null,
                                            controller: NameController,
                                            hintText: 'أسم المستخدم',
                                            icon: Icons.person,
                                            height:
                                                _formKey.currentState != null
                                                    ? _formKey.currentState!
                                                            .validate()
                                                        ? 50
                                                        : 70
                                                    : 50,
                                            keyboardType: TextInputType.text,
                                            onChanged: (value) {
                                              // Handle email text changes
                                            },
                                            borderRadius: 0,
                                            borderColor: Colors.black,
                                            backgroundColor: Colors.white,
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15, left: 25),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      NameController.text,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 83, 83, 83),
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
                                                Container(
                                                  width: double.infinity,
                                                  height: 1,
                                                  color: Color.fromARGB(
                                                      255, 39, 38, 38),
                                                )
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
                                            child: CustomTextField(
                                              onEdit: () {},
                                              showEdit: false,
                                              validator: validatePhoneNumber,
                                              controller: PhoneController,
                                              hintText: 'رقم الهاتف',
                                              icon: Icons.phone,
                                              height:
                                                  _formKey.currentState != null
                                                      ? _formKey.currentState!
                                                              .validate()
                                                          ? 50
                                                          : 70
                                                      : 50,
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                // Handle email text changes
                                              },
                                              borderRadius: 0,
                                              borderColor: Colors.black,
                                              backgroundColor: Colors.white,
                                            ))
                                        : Form(
                                            key: _formKey,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15, left: 25),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        PhoneController.text,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    83,
                                                                    83,
                                                                    83),
                                                            fontSize: 20),
                                                      ),
                                                      IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              editPhone = true;
                                                            });
                                                          },
                                                          icon:
                                                              Icon(Icons.edit))
                                                    ],
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: 1,
                                                    color: Color.fromARGB(
                                                        255, 39, 38, 38),
                                                  )
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
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "العنوان : ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Consumer<AddressProvider>(
                      builder: (context, addressprovider, _) {
                        List<AddressItem> addressItems =
                            addressprovider.addressItems;
                        AddressItem? selectedValue =
                            addressItems.isNotEmpty ? addressItems[0] : null;
                        if (selectedArea == null && addressItems.isNotEmpty) {
                          finalSelectedArea = addressItems[0].name;
                          selectedArea = addressItems[0] as AddressItem?;
                        }

                        return Visibility(
                          visible: addressItems.isNotEmpty,
                          child: Container(
                            height: 65,
                            child: DropdownButtonFormField<AddressItem>(
                              hint: Text("اختر العنوان"),
                              value: selectedValue,
                              items: addressItems
                                  .map((address) =>
                                      DropdownMenuItem<AddressItem>(
                                        child: Text(address.name),
                                        value: address,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedArea = value! as AddressItem?;
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
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15, right: 15, left: 15, bottom: 10),
                      child: InkWell(
                        onTap: () {
                          NavigatorFunction(context, AddAddress());
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              child: Image.asset("assets/images/add.png"),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "اضافة عنوان جديد ؟ ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, right: 15, left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "ملاحظات",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Container(
                            height: 80,
                            width: double.infinity,
                            child: TextField(
                              controller: OrderController,
                              obscureText: false,
                              maxLines: 5,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: MAIN_COLOR, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1.0, color: MAIN_COLOR),
                                ),
                                hintText: "أضف ملاحظاتك",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          loading
              ? Padding(
                  padding: EdgeInsets.only(top: 30, left: 25, right: 25),
                  child: Container(
                    height: 50,
                    width: double.infinity,
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
                      const EdgeInsets.only(bottom: 20, left: 25, right: 25),
                  child: BouncingWidget(
                    child: ButtonWidget(
                        name: "تأكيد عمليه الشراء",
                        height: 60,
                        width: double.infinity,
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
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });

                              var TOTALFINAL = widget.dropdownValue
                                          .toString() ==
                                      "الداخل"
                                  ? 60.0 + double.parse(widget.total.toString())
                                  : widget.dropdownValue.toString() == "القدس"
                                      ? 30.0 +
                                          double.parse(
                                              widget.total.toString().length > 5
                                                  ? widget.total
                                                      .toString()
                                                      .substring(0, 5)
                                                  : widget.total.toString())
                                      : widget.dropdownValue.toString() ==
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

                              final orderSuccess = await addOrder(
                                  context: context,
                                  address: finalSelectedArea.toString(),
                                  city: selectedArea!.city_name.toString(),
                                  phone: PhoneController.text,
                                  name: NameController.text,
                                  description: OrderController.text,
                                  total: TOTALFINAL.toString(),
                                  copon: CoponController.text,
                                  areaID: selectedArea!.area_id.toString(),
                                  areaName: selectedArea!.area_name.toString(),
                                  cityID: selectedArea!.city_id.toString());
                              if (orderSuccess.toString() == "200" ||
                                  orderSuccess.toString() == "201") {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String UserID =
                                    prefs.getString('user_id') ?? "";
                                String? TOKEN =
                                    await prefs.getString('device_token');
                                await prefs.setString(
                                    'name', NameController.text);
                                await prefs.setString(
                                    'city', finalSelectedArea.toString());
                                await prefs.setString(
                                    'area', AreaController.text);
                                await prefs.setString(
                                    'phone', PhoneController.text);
                                await prefs.setString(
                                    'address', finalSelectedArea.toString());
                                UserItem updatedUser = UserItem(
                                  name: NameController.text,
                                  id: UserID,
                                  token: TOKEN.toString(),
                                  email: "$UserID@email.com",
                                  phone: PhoneController.text,
                                  gender: '',
                                  birthdate: '',
                                  city: finalSelectedArea.toString(),
                                  area: finalSelectedArea.toString(),
                                  address: finalSelectedArea.toString(),
                                  password: '123',
                                );
                                try {
                                  final cartProvider =
                                      Provider.of<CartProvider>(context,
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
                                              NavigatorFunction(
                                                  context,
                                                  HomeScreen(
                                                    title: "",
                                                    selectedIndex: 0,
                                                    slider: false,
                                                    url: "",
                                                  ));
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              bool? show = await prefs.getBool(
                                                      'show_birthday') ??
                                                  true;
                                              show
                                                  ? NavigatorFunction(
                                                      context,
                                                      ChooseBirthdate(
                                                        name:
                                                            NameController.text,
                                                        PhoneController:
                                                            PhoneController
                                                                .text,
                                                        TOKEN: TOKEN.toString(),
                                                        UserID:
                                                            UserID.toString(),
                                                        selectedArea:
                                                            selectedArea
                                                                .toString(),
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                      "شكرا لشرائك من فوري ستحتاج الطلبية من ٣-٤ ايام ، يمكنك متابعة الطلب من قسم طلباتي الحالية",
                                                      textAlign:
                                                          TextAlign.center,
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
                                                              title: "",
                                                              slider: false,
                                                              url: "",
                                                              selectedIndex:
                                                                  0));
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
                                                                PhoneController:
                                                                    PhoneController
                                                                        .text,
                                                                TOKEN: TOKEN
                                                                    .toString(),
                                                                UserID: UserID
                                                                    .toString(),
                                                                selectedArea:
                                                                    selectedArea
                                                                        .toString(),
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
                                                            color:
                                                                Colors.white),
                                                      )),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      NavigatorFunction(
                                                          context,
                                                          NewestOrders(
                                                            user_id: UserID
                                                                .toString(),
                                                          ));
                                                    },
                                                    child: Container(
                                                      width: 200,
                                                      height: 40,
                                                      child: Center(
                                                          child: Text(
                                                        "تتبع طلبياتي",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      )),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.black),
                                                    ),
                                                  ),
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
                              } else {
                                setState(() {
                                  loading = false;
                                });
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: EdgeInsets.all(0),
                                        child: InkWell(
                                          onTap: () async {
                                            NavigatorFunction(
                                                context,
                                                HomeScreen(
                                                    title: "",
                                                    slider: false,
                                                    url: "",
                                                    selectedIndex: 0));
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
                                                    "assets/lottie_animations/Animation - 1726476947033.json",
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
                                                    "حدث خطأ ما , الرجاء التواصل معنا على فريق الدعم الفني",
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
                                                    final _url = Uri.parse(
                                                        "https://www.facebook.com/FawriCOD?mibextid=LQQJ4d");
                                                    if (!await launchUrl(_url,
                                                        mode: LaunchMode
                                                            .externalApplication)) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "لم يتم التمكن من الدخول الرابط , الرجاء المحاولة فيما بعد");
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 200,
                                                    height: 40,
                                                    child: Center(
                                                        child: Text(
                                                      "التواصل معنا",
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
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    NavigatorFunction(
                                                        context,
                                                        HomeScreen(
                                                            title: "",
                                                            slider: false,
                                                            url: "",
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
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                                  },
                                );
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
      )),
    );
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء أدخل رقم الهاتف';
    }
    if (value.length != 10) {
      return 'يجب أن يكون مجموع خانات الهاتف 10 أرقام';
    }
    if (!value.startsWith('05')) {
      return 'رقم الهاتف يجب ان يبدأ ب 05';
    }
    return null;
  }
}
