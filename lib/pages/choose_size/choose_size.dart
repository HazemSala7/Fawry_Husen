import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:flutter/material.dart';

class ChooseSize extends StatefulWidget {
  const ChooseSize({super.key});

  @override
  State<ChooseSize> createState() => _ChooseSizeState();
}

class _ChooseSizeState extends State<ChooseSize> {
  @override
  List<bool> selectedStates =
      List.generate(women__sizes.length, (index) => false);
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 2,
            centerTitle: true,
            title: Text(
              "اختر الحجم",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15, right: 15, bottom: 15),
                  child: Row(
                    children: [
                      Text(
                        "الرجاء اختر الحجم المناسب لك ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                        cacheExtent: 5000,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: women__sizes.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 30,
                          childAspectRatio: 3.0,
                        ),
                        itemBuilder: (context, int index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedStates[index] = !selectedStates[index];
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                    ),
                                  ],
                                  color: selectedStates[index]
                                      ? Colors.red
                                      : Colors.white,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(50)),
                              height: 30,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    women__sizes[index],
                                    style: TextStyle(
                                        color: selectedStates[index]
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 70,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonWidget(
                name: "حفظ البيانات",
                height: 50,
                width: double.infinity,
                BorderColor: MAIN_COLOR,
                OnClickFunction: () {},
                BorderRaduis: 4,
                ButtonColor: MAIN_COLOR,
                NameColor: Colors.white),
          ),
        )
      ],
    );
  }
}
