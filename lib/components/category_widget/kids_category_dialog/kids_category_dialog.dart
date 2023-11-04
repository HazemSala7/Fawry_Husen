import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class KidsCategoryDialog extends StatefulWidget {
  KidsCategoryDialog({super.key});

  @override
  State<KidsCategoryDialog> createState() => _KidsCategoryDialogState();
}

class _KidsCategoryDialogState extends State<KidsCategoryDialog> {
  @override
  List<CategoryItem> categoryItems = [
    CategoryItem(
        name: "قسم الأولاد",
        image: "assets/images/icons8-human-head-96 (1).png"),
    CategoryItem(name: "قسم البنات", image: "assets/images/icons8-girl-96.png"),
    CategoryItem(
        name: "كلاهما", image: "assets/images/icons8-select-all-100.png"),
  ];

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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/baby1.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Color(0xffEDF5F7).withOpacity(0.1),
            BlendMode.dstATop,
          ),
        )),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    categoryMethodForShoes(
                      name: categoryItems[0].name,
                      image: categoryItems[0].image,
                      isSelected: categoryItems[0].isSelected,
                      onTaped: () {
                        setState(() {
                          categoryItems[0].isSelected =
                              !categoryItems[0].isSelected;
                        });
                      },
                    ),
                    categoryMethodForShoes(
                      name: categoryItems[1].name,
                      image: categoryItems[1].image,
                      isSelected: categoryItems[1].isSelected,
                      onTaped: () {
                        setState(() {
                          categoryItems[1].isSelected =
                              !categoryItems[1].isSelected;
                        });
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: categoryMethodForShoes(
                    name: categoryItems[2].name,
                    image: categoryItems[2].image,
                    isSelected: categoryItems[2].isSelected,
                    onTaped: () {
                      setState(() {
                        categoryItems[2].isSelected =
                            !categoryItems[2].isSelected;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget categoryMethodForShoes(
      {String image = "",
      String name = "",
      Function? onTaped,
      required bool isSelected}) {
    return Column(
      children: [
        Visibility(
          visible: name == "كلاهما" ? false : true,
          child: Image.asset(
            image,
            height: 40,
            width: 40,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        InkWell(
          onTap: () {
            onTaped!();
          },
          child: Container(
            width: 180,
            height: 60,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 7,
                  blurRadius: 5,
                ),
              ],
              borderRadius: BorderRadius.circular(40),
              color: isSelected ? Colors.black : Colors.white,
            ),
            child: Center(
              child: Text(
                name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: isSelected ? Colors.white : Colors.black87),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryItem {
  final String image;
  final String name;
  bool isSelected;

  CategoryItem({
    required this.image,
    required this.name,
    this.isSelected = false,
  });
}
