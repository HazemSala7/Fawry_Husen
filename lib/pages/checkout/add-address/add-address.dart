import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:fawri_app_refactor/LocalDB/Models/AddressItem.dart';
import 'package:fawri_app_refactor/LocalDB/Provider/AddressProvider.dart';
import 'package:fawri_app_refactor/components/app-bar-widget/app-bar-widget.dart';
import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/model/Area/area.dart';
import 'package:fawri_app_refactor/model/City/city.dart';
import 'package:fawri_app_refactor/services/dialogs/checkout/area_city_service/area_city_service.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  String finalSelectedArea = "";
  City? selectedCity;
  Area? selectedArea;
  List<City> cities = [];
  List<Area> areas = [];
  TextEditingController notesController = TextEditingController();

  setControllers() async {
    cities = await CityService().loadCities();
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
    super.initState();
    setControllers();
  }

  @override
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
                child: AppBarWidgetBack(cartKey: null, showCart: false),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 25, left: 25, top: 20),
                  child: Column(
                    children: [
                      DropdownSearch<City>(
                        items: cities,
                        itemAsString: (City c) => c.name,
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "اختر المنطقة التابعة",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        onChanged: (City? city) async {
                          setState(() {
                            selectedCity = city;
                            selectedArea = null;
                            areas = [];
                          });
                          areas = await CityService().loadAreasFromCsv(city!);
                          setState(() {});
                        },
                        selectedItem: selectedCity,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "ابحث عن مدينة",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      if (selectedCity != null)
                        DropdownSearch<Area>(
                          items: areas,
                          itemAsString: (Area a) => a.name,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "اختر المنطقة التابعة",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          onChanged: (Area? area) {
                            setState(() {
                              selectedArea = area!;
                            });
                          },
                          selectedItem: selectedArea,
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                hintText: "ابحث عن منطقة",
                                border: OutlineInputBorder(),
                              ),
                            ),
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
                              hintText:
                                  "المزيد من التفاصيل ( أسم الشارع , معلم مشهور)",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 25, left: 25),
              child: ButtonWidget(
                name: "تأكيد العنوان",
                height: 50,
                width: double.infinity,
                BorderColor: MAIN_COLOR,
                OnClickFunction: () async {
                  final addressProviderFinal =
                      Provider.of<AddressProvider>(context, listen: false);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String UserID = prefs.getString('user_id') ?? "";
                  final newItem = AddressItem(
                    city_name: selectedCity!.translatedName.toString(),
                    area_id: selectedArea!.id.toString(),
                    city_id: selectedCity!.id.toString(),
                    area_name: selectedArea!.name.toString(),
                    user_id: UserID,
                    name: "${selectedCity!.name}, ${selectedArea!.name}",
                  );

                  addressProviderFinal.addToAddress(newItem);
                  Fluttertoast.showToast(msg: "تم اضافة العنوان بنجاح");
                  Navigator.pop(context);
                },
                BorderRaduis: 10,
                ButtonColor: MAIN_COLOR,
                NameColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
