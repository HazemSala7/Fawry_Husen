import 'package:fawri_app_refactor/LocalDB/Models/AddressItem.dart';
import 'package:fawri_app_refactor/LocalDB/Provider/AddressProvider.dart';
import 'package:fawri_app_refactor/components/app-bar-widget/app-bar-widget.dart';
import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/components/cutom-text-field/cutom-text-field.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/model/Area/area.dart';
import 'package:fawri_app_refactor/model/City/city.dart';
import 'package:fawri_app_refactor/services/dialogs/checkout/area_city_service/area_city_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  @override
  String finalSelectedArea = "";

  setControllers() async {
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

  String dropdownValue = 'اختر منطقتك';
  City? selectedCity;
  Area? selectedArea;
  City? selectedCity1;
  Area? selectedArea1;
  List<City> cities = [];
  List<Area> areas = [];
  TextEditingController cityController = TextEditingController();
  TextEditingController notesController = TextEditingController();
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
            padding: const EdgeInsets.only(right: 25, left: 25, top: 20),
            child: Column(
              children: [
                Container(
                  height: 51,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: MAIN_COLOR, width: 2.0)),
                  child: DropdownButtonFormField<City>(
                    value: selectedCity,
                    hint: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text('اختر المنطقة التابعة'),
                      ],
                    ),
                    onChanged: (City? city) async {
                      setState(() {
                        areas = [];
                        selectedCity = city;
                        selectedArea = null;
                      });
                      areas = await CityService().loadAreasFromCsv(city!);
                      setState(() {});
                    },
                    items: cities.map((city) {
                      return DropdownMenuItem<City>(
                        value: city,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(city.name),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                if (selectedCity != null)
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: MAIN_COLOR, width: 2.0)),
                    child: DropdownButtonFormField<Area>(
                      value: selectedArea,
                      hint: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text('اختر المنطقة التابعة'),
                        ],
                      ),
                      onChanged: (Area? area) {
                        setState(() {
                          selectedArea = area!;
                        });
                      },
                      items: areas.map((area) {
                        return DropdownMenuItem<Area>(
                          value: area,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(area.name),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    child: TextField(
                      controller: notesController,
                      obscureText: false,
                      maxLines: 5,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MAIN_COLOR, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0, color: MAIN_COLOR),
                        ),
                        hintText:
                            "المزيد من التفاصيل ( أسم الشارع , معلم مشهور)",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: ButtonWidget(
                      name: "تأكيد العنوان",
                      height: 50,
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
                          area_id: selectedArea!.id.toString(),
                          city_id: selectedCity!.id.toString(),
                          area_name: selectedArea!.name.toString(),
                          user_id: UserID,
                          name:
                              "${dropdownValue.toString() == "الضفه الغربيه" ? selectedCity!.name : cityController.text} ,${selectedArea!.name}",
                        );

                        addressProviderFinal.addToAddress(newItem);
                        Fluttertoast.showToast(msg: "تم اضافة العنوان بنجاح");

                        Navigator.pop(context);
                      },
                      BorderRaduis: 10,
                      ButtonColor: MAIN_COLOR,
                      NameColor: Colors.white),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
