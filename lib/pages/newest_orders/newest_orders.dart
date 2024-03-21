import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:fawri_app_refactor/pages/order_details/order_details.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/constants.dart';
import '../../firebase/order/OrderFirebaseModel.dart';

class NewestOrders extends StatefulWidget {
  final user_id;
  const NewestOrders({super.key, this.user_id});

  @override
  State<NewestOrders> createState() => _NewestOrdersState();
}

class _NewestOrdersState extends State<NewestOrders> {
  DateTime fourDaysAgo = DateTime.now().subtract(Duration(days: 4));

  Widget build(BuildContext context) {
    String formattedDate = fourDaysAgo.toIso8601String().substring(0, 10);
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
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('user_id', isEqualTo: widget.user_id)
                .where('created_at', isGreaterThanOrEqualTo: formattedDate)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container(
                  width: double.infinity,
                  height: 400,
                  child: Center(
                    child: SpinKitPulse(
                      color: MAIN_COLOR,
                      size: 60,
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: double.infinity,
                  height: 400,
                  child: Center(
                    child: SpinKitPulse(
                      color: MAIN_COLOR,
                      size: 60,
                    ),
                  ),
                );
              }
              final List<DocumentSnapshot> documents = snapshot.data!.docs;
              final List<OrderFirebaseModel> orders = documents.map((doc) {
                return OrderFirebaseModel.fromMap(
                    doc.data() as Map<String, dynamic>?);
              }).toList();
              if (documents.length != 0) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  color: Color(0xffEEEEEE),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, right: 25, left: 25),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "طللباتك الحالية",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    "(${orders.length}) طلبية",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          itemCount: documents.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _heightList[index] =
                                      _heightList[index] == 100.0
                                          ? 550.0
                                          : 100.0;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 25, left: 25, top: 15),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  width: double.infinity,
                                  height: _heightList[index],
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      height: 100,
                                                      width: 4,
                                                      color: Color(0xff036A6A),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "رقم تتبع الطلبية",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10),
                                                        child: Text(
                                                          "# ${orders[index].order_id}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 13,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "اضغط لمشاهدة التفاصيل",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                            _heightList[index] ==
                                                                    100.0
                                                                ? Icons
                                                                    .keyboard_arrow_down
                                                                : Icons
                                                                    .keyboard_arrow_up,
                                                            color: Colors.grey,
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "عدد القطع",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "(${orders[index].number_of_products})",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                            color: Color(
                                                                0xff036A6A),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Text(
                                                      "${orders[index].sum}₪",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17,
                                                        color: Colors.black,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      _heightList[index] == 550.0
                                          ? FutureBuilder(
                                              future: getOrderDetails(
                                                  orders[index].order_id),
                                              builder: (context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return Center(
                                                    child: Text(
                                                        'Error fetching data'),
                                                  );
                                                } else {
                                                  var products = snapshot
                                                      .data["data"]["data"];
                                                  return Stack(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 450.0,
                                                            width:
                                                                double.infinity,
                                                            child: ListView
                                                                .builder(
                                                                    itemCount:
                                                                        products
                                                                            .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int indexProducts) {
                                                                      return Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              80,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: Color(0xffE1DEDE)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                FancyShimmerImage(
                                                                                  imageUrl: snapshot.data["data"]["data"][indexProducts]["image"].toString(),
                                                                                  height: 50,
                                                                                  width: 50,
                                                                                ),
                                                                                Column(
                                                                                  children: [
                                                                                    Text(
                                                                                      "SKU : ${snapshot.data["data"]["data"][indexProducts]["data"][0]["sku"]}",
                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                                                    ),
                                                                                    Text(
                                                                                      "size : ${snapshot.data["data"]["data"][indexProducts]["data"][0]["size"]}",
                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ButtonWidget(
                                                            name:
                                                                "تتبع حالة طلبك",
                                                            height: 50,
                                                            width: 150,
                                                            BorderColor:
                                                                MAIN_COLOR,
                                                            OnClickFunction:
                                                                () {
                                                              NavigatorFunction(
                                                                  context,
                                                                  OrderDetails(
                                                                    created_at:
                                                                        orders[index]
                                                                            .created_at,
                                                                    order_id: orders[
                                                                            index]
                                                                        .order_id,
                                                                    done: false,
                                                                    expected_date:
                                                                        "05/08/2023",
                                                                    sku: orders[
                                                                            index]
                                                                        .order_id,
                                                                    sun: snapshot
                                                                        .data[
                                                                            "data"]
                                                                            [
                                                                            "total_price"]
                                                                        .toString(),
                                                                  ));
                                                            },
                                                            BorderRaduis: 40,
                                                            ButtonColor:
                                                                MAIN_COLOR,
                                                            NameColor:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  );
                                                }
                                              },
                                            )
                                          : SizedBox(),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Text(
                      "لا يوجد أي طلبات لديك الأن",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  List<double> _heightList = List.generate(6, (index) => 100.0);
}
