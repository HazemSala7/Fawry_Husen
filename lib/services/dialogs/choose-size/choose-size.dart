import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:flutter/material.dart';

class ChooseSizeShoes extends StatefulWidget {
  const ChooseSizeShoes({Key? key}) : super(key: key);

  @override
  State<ChooseSizeShoes> createState() => _ChooseSizeShoesState();
}

class _ChooseSizeShoesState extends State<ChooseSizeShoes> {
  @override
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
        child: Material(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "اختار الحجم",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 80,
                width: double.infinity,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {},
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                            child: Center(
                              child: Text(
                                "39",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            ),
                          )),
                    ),
                    sizeWidget(),
                    sizeWidget(),
                    sizeWidget(),
                    sizeWidget(),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ButtonWidget(
                  name: "التالي",
                  height: 50,
                  width: double.infinity,
                  BorderColor: Colors.black,
                  OnClickFunction: () {},
                  BorderRaduis: 10,
                  ButtonColor: Colors.black,
                  NameColor: Colors.white)
            ],
          ),
        ),
      ),
    );
  }

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
