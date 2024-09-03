import 'package:fawri_app_refactor/LocalDB/Models/AddressItem.dart';
import 'package:fawri_app_refactor/LocalDB/Provider/AddressProvider.dart';
import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';

class AccountInformation extends StatefulWidget {
  final name, address, area, city, phone, birthday;
  const AccountInformation(
      {super.key,
      this.name,
      this.address,
      this.area,
      this.birthday,
      this.city,
      this.phone});

  @override
  State<AccountInformation> createState() => AaccounIinformationState();
}

class AaccounIinformationState extends State<AccountInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: MAIN_COLOR,
          centerTitle: true,
          title: Text(
            "فوري",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              )),
        ),
      ),
      body: widget.name == null ||
              widget.name == "" ||
              widget.name.toString == "null"
          ? Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Text(
                  "لا يوجد لدينا معلومات مسجلة لك",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 35, right: 25, left: 25),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
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
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Text(
                                      widget.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 83, 83, 83),
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
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
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Text(
                                      widget.phone,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 83, 83, 83),
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "تاريخ الميلاد",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: MAIN_COLOR),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Text(
                                          widget.birthday == "" ||
                                                  widget.birthday == null
                                              ? "00/00/0000"
                                              : widget.birthday.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 83, 83, 83),
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible:
                                          widget.birthday.toString() == "" ||
                                                  widget.birthday == null
                                              ? true
                                              : false,
                                      child: Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.plus,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "اضافة تاريخ ميلاد",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 25, left: 15, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "العنوان",
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

                        return Visibility(
                          visible: addressItems.length == 0 ? false : true,
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 15, left: 15),
                              child: Container(
                                decoration: BoxDecoration(border: Border.all()),
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: addressItems.length,
                                  itemBuilder: (context, index) {
                                    AddressItem item = addressItems[index];
                                    return Container(
                                      height: 50,
                                      decoration:
                                          BoxDecoration(border: Border.all()),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              item.name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15, right: 15, left: 15, bottom: 10),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shadowColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0))),
                                elevation: 0,
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 15, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                          borderSide: BorderSide(
                                              color: MAIN_COLOR, width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.0, color: MAIN_COLOR),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 10, left: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                          borderSide: BorderSide(
                                              color: MAIN_COLOR, width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.0, color: MAIN_COLOR),
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
                                        if (selectedCity.toString() == "" ||
                                            addressController.text == "") {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Text(
                                                  "الرجاء تعبئه جميع البيانات",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Center(
                                                        child: Text(
                                                          "حسنا",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          final addressProviderFinal =
                                              Provider.of<AddressProvider>(
                                                  context,
                                                  listen: false);
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          String UserID =
                                              prefs.getString('user_id') ?? "";
                                          final newItem = AddressItem(
                                            area_id: "1",
                                            area_name: "",
                                            city_id: "",
                                            user_id: UserID,
                                            name:
                                                "$selectedCity ,${addressController.text} ",
                                          );
                                          addressProviderFinal
                                              .addToAddress(newItem);
                                          Fluttertoast.showToast(
                                              msg: "تم اضافة العنوان بنجاح");
                                          Navigator.pop(context);
                                        }
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
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.only(top: 50),
                    //   child: ButtonWidget(
                    //       name: "حفظ",
                    //       height: 50,
                    //       width: double.infinity,
                    //       BorderColor: MAIN_COLOR,
                    //       OnClickFunction: () {},
                    //       BorderRaduis: 40,
                    //       ButtonColor: MAIN_COLOR,
                    //       NameColor: Colors.white),
                    // )
                  ],
                ),
              ),
            ),
    );
  }

  String selectedArea = 'اختر العنوان';
  String selectedCity = 'الخليل';

  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
}
