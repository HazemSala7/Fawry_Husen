import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/material.dart';

import '../../pages/products-category/products-category.dart';
import '../../services/custom_icons/custom_icons.dart';

class CategoryWidget extends StatefulWidget {
  final image, name, main_category, CateIcon, CateImage;
  CategoryWidget({
    Key? key,
    required this.name,
    required this.image,
    required this.CateImage,
    required this.main_category,
    required this.CateIcon,
  }) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  IconData? getIconData(String iconName) {
    // Find the IconData based on the icon name

    switch (iconName) {
      case "FFIcons.kmenlogo":
        return FFIcons.kmenlogo;
      case "FFIcons.kshortDress":
        return FFIcons.kshortDress;
      // Add more cases here for other icons you might use
      default:
        return null;
    }
  }

  var Sizes;

  setSizesArray() {
    if (widget.name == "ملابس نسائيه") {
      Sizes = women__sizes;
    } else if (widget.name == "ملابس رجاليه") {
      Sizes = Men_sizes;
    } else if (widget.name == "ملابس أطفال") {
      Sizes = kids_boys_sizes;
    } else {
      Sizes = women__sizes;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setSizesArray();
  }

  getSizesAndShow() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'لتجربه أفضل , الرجاء اختيار الحجم',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: Container(
              height: 350,
              child: Column(
                children: [
                  Container(
                    height: 300.0,
                    width: 300.0,
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: Sizes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return sizeMethod(size: Sizes[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ButtonWidget(
                            name: "تخطي",
                            height: 40,
                            width: 120,
                            BorderColor: Colors.black,
                            OnClickFunction: () {
                              NavigatorFunction(
                                  context,
                                  ProductsCategories(
                                    category_id:
                                        widget.main_category.toString(),
                                  ));
                            },
                            BorderRaduis: 10,
                            ButtonColor: MAIN_COLOR,
                            NameColor: Colors.white),
                        ButtonWidget(
                            name: "التالي",
                            height: 40,
                            width: 120,
                            BorderColor: Colors.black,
                            OnClickFunction: () {
                              NavigatorFunction(
                                  context,
                                  ProductsCategories(
                                    category_id:
                                        widget.main_category.toString(),
                                  ));
                            },
                            BorderRaduis: 10,
                            ButtonColor: MAIN_COLOR,
                            NameColor: Colors.white),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        bool All = false;
        bool Women = false;
        bool Men = false;
        bool Kids = false;
        if (widget.name == "الأحذيه") {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                      content: SizedBox(
                    height: 280,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              value: All,
                              onChanged: (bool? value) {
                                setState(() {
                                  All = value!;
                                  Women = value;
                                  Men = value;
                                  Kids = value;
                                });
                              },
                            ),
                            ButtonWidget(
                                name: "الجميع",
                                height: 50,
                                width: 200,
                                BorderColor: MAIN_COLOR,
                                OnClickFunction: () {
                                  getSizesAndShow();
                                },
                                BorderRaduis: 4,
                                ButtonColor: MAIN_COLOR,
                                NameColor: Colors.white),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              value: Women,
                              onChanged: (bool? value) {
                                setState(() {
                                  Women = value!;
                                });
                              },
                            ),
                            ButtonWidget(
                                name: "الأحذيه الستاتيه",
                                height: 50,
                                width: 200,
                                BorderColor: MAIN_COLOR,
                                OnClickFunction: () {
                                  getSizesAndShow();
                                },
                                BorderRaduis: 4,
                                ButtonColor: MAIN_COLOR,
                                NameColor: Colors.white),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              value: Men,
                              onChanged: (bool? value) {
                                setState(() {
                                  Men = value!;
                                });
                              },
                            ),
                            ButtonWidget(
                                name: "الأحذيه الرجاليه",
                                height: 50,
                                width: 200,
                                BorderColor: MAIN_COLOR,
                                OnClickFunction: () {
                                  getSizesAndShow();
                                },
                                BorderRaduis: 4,
                                ButtonColor: MAIN_COLOR,
                                NameColor: Colors.white),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              value: Kids,
                              onChanged: (bool? value) {
                                setState(() {
                                  Kids = value!;
                                });
                              },
                            ),
                            ButtonWidget(
                                name: "أحذيه أطفال",
                                height: 50,
                                width: 200,
                                BorderColor: MAIN_COLOR,
                                OnClickFunction: () {
                                  getSizesAndShow();
                                },
                                BorderRaduis: 4,
                                ButtonColor: MAIN_COLOR,
                                NameColor: Colors.white),
                          ],
                        ),
                      ],
                    ),
                  ));
                },
              );
            },
          );
        } else {
          getSizesAndShow();
        }
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset(
                  widget.image,
                ).image,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0x80000000),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      widget.CateImage,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 180,
                      child: Center(
                        child: Text(
                          widget.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> selectedSizes = [];

  Widget sizeMethod({String size = "", int index = 0}) {
    final isSelected = selectedSizes.contains(size);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedSizes.remove(size);
            } else {
              selectedSizes.add(size);
            }
          });
        },
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              size,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }
}
