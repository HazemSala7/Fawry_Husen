import 'dart:math';

import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';

class BestSellersWidget extends StatefulWidget {
  @override
  _BestSellersWidgetState createState() => _BestSellersWidgetState();
}

class _BestSellersWidgetState extends State<BestSellersWidget> {
  int currentPage = 1;
  List products = [];
  bool isLoading = false;
  final List<Color> darkColors = [
    Colors.black,
    Colors.brown,
    Colors.blue.shade900,
    Colors.green.shade900,
    Colors.grey.shade800,
    Colors.indigo.shade900,
  ];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    loadProducts(currentPage);
  }

  Future<void> loadProducts(int page) async {
    setState(() => isLoading = true);
    final newProducts = await getBestSellersProducts(page);
    if (newProducts != null && newProducts["data"].isNotEmpty) {
      setState(() {
        products.addAll(newProducts["data"]);
        currentPage++;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 370,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "الأكثر مبيعا",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 200,
                  height: 3,
                  color: Colors.black,
                ),
              ],
            ),
            SizedBox(height: 30),
            products.isEmpty
                ? CircularProgressIndicator()
                : Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification.metrics.pixels ==
                                scrollNotification.metrics.maxScrollExtent &&
                            !isLoading) {
                          loadProducts(currentPage);
                        }
                        return false;
                      },
                      child: PageView.builder(
                        itemCount: (products.length / 4).ceil(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, pageIndex) {
                          int start = pageIndex * 4;
                          int end = (start + 4 > products.length)
                              ? products.length
                              : start + 4;
                          List currentProducts = products.sublist(start, end);

                          return GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.5,
                            ),
                            itemCount: currentProducts.length,
                            itemBuilder: (context, gridIndex) {
                              var product = currentProducts[gridIndex];
                              Color randomColor =
                                  darkColors[random.nextInt(darkColors.length)];
                              return InkWell(
                                onTap: () {
                                  // Handle product tap
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          child: Container(
                                            color: randomColor,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 50,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      product["item_name"],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                product.containsKey("price") &&
                                                        product["price"] != null
                                                    ? Text(
                                                        product["price"]
                                                                is double
                                                            ? "₪${(product["price"] as double).toStringAsFixed(2)}"
                                                            : (double.tryParse(product[
                                                                            "price"]
                                                                        .toString()) !=
                                                                    null
                                                                ? "₪${double.parse(product["price"]).toStringAsFixed(2)}"
                                                                : "₪0"),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 24,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : Text(
                                                        "₪0",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 24,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(product[
                                                          "images"]
                                                      .isEmpty
                                                  ? "https://www.fawri.co/assets/about_us/fawri_logo.jpg"
                                                  : product["images"][0] ??
                                                      "https://www.fawri.co/assets/about_us/fawri_logo.jpg"),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
