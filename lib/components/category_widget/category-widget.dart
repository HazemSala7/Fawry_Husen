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

  final List<String> shoeSizes = [];
  getSizesAndShow() async {
    shoeSizes.clear();
    setState(() {});
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
              height: 100,
              width: 100,
              child: Center(
                  child: CircularProgressIndicator(
                color: MAIN_COLOR,
              ))),
        );
      },
    );
    var sizes = await getSizesByCategory(widget.main_category, context);
    for (int i = 0; i < sizes.length; i++) {
      shoeSizes.add(sizes[i]);
      setState(() {});
    }
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
                      itemCount: shoeSizes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return sizeMethod(size: shoeSizes[index]);
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
        if (widget.name == "الأحذيه") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  content: SizedBox(
                height: 200,
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonWidget(
                        name: "الأحذيه الستاتيه",
                        height: 50,
                        width: double.infinity,
                        BorderColor: MAIN_COLOR,
                        OnClickFunction: () {
                          getSizesAndShow();
                        },
                        BorderRaduis: 4,
                        ButtonColor: MAIN_COLOR,
                        NameColor: Colors.white),
                    ButtonWidget(
                        name: "الأحذيه الرجاليه",
                        height: 50,
                        width: double.infinity,
                        BorderColor: MAIN_COLOR,
                        OnClickFunction: () {
                          getSizesAndShow();
                        },
                        BorderRaduis: 4,
                        ButtonColor: MAIN_COLOR,
                        NameColor: Colors.white),
                    ButtonWidget(
                        name: "أحذيه أطفال",
                        height: 50,
                        width: double.infinity,
                        BorderColor: MAIN_COLOR,
                        OnClickFunction: () {
                          getSizesAndShow();
                        },
                        BorderRaduis: 4,
                        ButtonColor: MAIN_COLOR,
                        NameColor: Colors.white),
                  ],
                ),
              ));
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
