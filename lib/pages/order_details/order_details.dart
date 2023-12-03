import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/constants.dart';

class OrderDetails extends StatefulWidget {
  final sku, sun, expected_date;
  bool done;
  OrderDetails(
      {super.key, this.sku, this.sun, this.expected_date, required this.done});

  @override
  State<OrderDetails> createState() => Oorder_detaDsState();
}

class Oorder_detaDsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
              backgroundColor: MAIN_COLOR,
              centerTitle: true,
              title: Text(
                "حالة طلبك",
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
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                statusOrderMethod(
                    first_text: "تم تقديم طلبك",
                    lines: true,
                    check_image: widget.done
                        ? "assets/images/icons8-check-mark-50 (1).png"
                        : "assets/images/icons8-check-mark-50.png",
                    second_text: "تم استلام طلبك لدينا 2/8/2023",
                    image: "assets/images/icons8-received-96.png"),
                SizedBox(
                  height: 10,
                ),
                statusOrderMethod(
                    lines: true,
                    first_text: "تجهيز الطلب",
                    second_text: "تم نقل طلبك 03/08/2023",
                    check_image: widget.done
                        ? "assets/images/icons8-check-mark-50 (1).png"
                        : "assets/images/icons8-check-mark-50.png",
                    image: "assets/images/icons8-shipping-to-door-64.png"),
                SizedBox(
                  height: 10,
                ),
                statusOrderMethod(
                    lines: true,
                    first_text: "جاهز للنقل",
                    second_text: "تم تجهيز الطلب 03/08/2023",
                    check_image: widget.done
                        ? "assets/images/icons8-check-mark-50 (1).png"
                        : "assets/images/icons8-check-mark-50.png",
                    image: "assets/images/icons8-shopping-bag-50 (2).png"),
                SizedBox(
                  height: 10,
                ),
                statusOrderMethod(
                    lines: true,
                    first_text: "تم الشحن",
                    second_text: "جاري شحن طلبك الأن الى العنوان المطلوب",
                    check_image: widget.done
                        ? "assets/images/icons8-check-mark-50 (1).png"
                        : "assets/images/icons8-check-mark-50.png",
                    image: "assets/images/icons8-shipping-50.png"),
                SizedBox(
                  height: 10,
                ),
                statusOrderMethod(
                    lines: false,
                    first_text: "تم التوصيل",
                    check_image: widget.done
                        ? "assets/images/icons8-check-mark-50 (1).png"
                        : "assets/images/icons8-check-mark-50.png",
                    second_text: "تم توصيل طلبك , تجربة ممتعة!",
                    image: "assets/images/icons8-delivery-64.png"),
              ],
            ),
          ),
        ),
        Material(
          child: Padding(
            padding: const EdgeInsets.only(right: 25, left: 25, bottom: 40),
            child: Container(
              width: double.infinity,
              height: 180,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 25, right: 25, left: 25),
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 231, 231, 231),
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "متوقع الوصول",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 90, 90, 90),
                                    fontSize: 11),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "05/08/2023",
                                style: TextStyle(
                                  color: MAIN_COLOR,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 50,
                            width: 1,
                            color: Color.fromARGB(255, 163, 163, 163),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "رقم تتبع القطعة",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 90, 90, 90),
                                    fontSize: 11),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.sku.toString(),
                                style: TextStyle(
                                  color: MAIN_COLOR,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/icons8-paid-30.png",
                                  height: 35,
                                  width: 35,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "المبلغ المطلوب عند الاستلام",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.white),
                                ),
                                Text(
                                  "شيقل",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          "${widget.sun}₪",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 7,
                  blurRadius: 5,
                ),
              ], borderRadius: BorderRadius.circular(20), color: MAIN_COLOR),
            ),
          ),
        )
      ],
    );
  }

  Widget statusOrderMethod(
      {String image = "",
      String check_image = "",
      String first_text = "",
      String second_text = "",
      bool lines = true}) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                check_image,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
              ),
              Visibility(
                visible: lines,
                child: Column(
                  children: List<Widget>.generate(7, (int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Container(
                        width: 2,
                        height: 4,
                        color: Color(0xff1B425E),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                image,
                height: 30,
                width: 30,
              ),
            ],
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    first_text,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 87, 86, 86),
                        fontSize: 18),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    second_text,
                    style: TextStyle(
                        color: const Color.fromARGB(255, 43, 43, 43),
                        fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
