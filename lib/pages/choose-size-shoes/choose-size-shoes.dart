import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scaled_list/scaled_list.dart';

class ChooseSizeShoes extends StatefulWidget {
  const ChooseSizeShoes({super.key});

  @override
  State<ChooseSizeShoes> createState() => _ChooseSizeShoesState();
}

class _ChooseSizeShoesState extends State<ChooseSizeShoes> {
  @override
  int clickedIndex = -1;
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
          child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            backgroundColor: MAIN_COLOR,
            centerTitle: true,
            title: Text(
              "فوري",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
        body: SingleChildScrollView(
          child: Column(children: [
            ScaledList(
              showDots: false,
              itemCount: 10,
              itemColor: (index) {
                return Colors.white;
              },
              itemBuilder: (index, selectedIndex) {
                return Image.network(
                  "https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/99486859-0ff3-46b4-949b-2d16af2ad421/custom-nike-dunk-high-by-you-shoes.png",
                  fit: BoxFit.cover,
                );
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Row(
                children: [
                  Text(
                    "الرجاء اختيار رقم حذائك لتجربة أكثر متعة",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 102, 102, 102),
                        fontSize: 18),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              height: 45,
              width: double.infinity,
              child: ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        clickedIndex = index;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 15, left: 15),
                          height: 45,
                          width: 50,
                          color: clickedIndex == index
                              ? MAIN_COLOR
                              : Color.fromARGB(255, 238, 238, 238),
                          child: Center(
                            child: Text(
                              "42",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: clickedIndex == index
                                    ? Colors.white
                                    : MAIN_COLOR,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        if (clickedIndex == index)
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Center(
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.close,
                                  size: 17,
                                  color: Colors.red,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100, right: 25, left: 25),
              child: ButtonWidget(
                  name: "حفظ",
                  height: 50,
                  width: double.infinity,
                  BorderColor: MAIN_COLOR,
                  OnClickFunction: () {},
                  BorderRaduis: 10,
                  ButtonColor: MAIN_COLOR,
                  NameColor: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "تخطي",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              ),
            )
          ]),
        ),
      )),
    );
  }
}
