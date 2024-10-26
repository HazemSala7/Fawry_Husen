import 'dart:math';

import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/pages/product-screen/product-screen.dart';
import 'package:fawri_app_refactor/server/domain/domain.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SectionStyleFour extends StatefulWidget {
  final String sectionName;
  final String sectionURL;
  final Color backgroundColor;

  SectionStyleFour({
    Key? key,
    required this.sectionName,
    required this.sectionURL,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  State<SectionStyleFour> createState() => _SectionStyleFourState();
}

class _SectionStyleFourState extends State<SectionStyleFour> {
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
  Widget build(BuildContext context) {
    return Container(
      height: 370,
      width: double.infinity,
      decoration: BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.sectionName,
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
            FutureBuilder(
              future: getDynamicSectionProducts(widget.sectionURL, 1),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ListView.builder(
                        itemCount: 4,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Shimmer.fromColors(
                              baseColor:
                                  const Color.fromARGB(255, 196, 196, 196),
                              highlightColor:
                                  const Color.fromARGB(255, 129, 129, 129),
                              child: Container(
                                width: 160,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  var products = snapshot.data["items"];
                  int pageCount = (products.length / 4).ceil();

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.38,
                    child: PageView.builder(
                      itemCount: pageCount,
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
                                List result = [];
                                int startIndex = gridIndex - 20;
                                int endIndex = gridIndex + 20;
                                if (startIndex < 0) startIndex = 0;
                                if (endIndex > products.length)
                                  endIndex = products.length;
                                result.addAll(
                                    products.sublist(startIndex, endIndex));
                                result.insert(0, products[gridIndex]);
                                List<String> idsList = result
                                    .map((item) => item['id'].toString())
                                    .toList();
                                String commaSeparatedIds = idsList.join(', ');

                                NavigatorFunction(
                                  context,
                                  ProductScreen(
                                    hasAPI: false,
                                    priceMul: 1.0,
                                    price:
                                        products[gridIndex]["price"].toString(),
                                    SIZES: [],
                                    ALL: true,
                                    SubCategories: [],
                                    url:
                                        "${URL}getAllItems?api_key=$key_bath&page=1",
                                    page: 1,
                                    Sub_Category_Key:
                                        sub_categories_women_appearel[0]["key"]
                                            .toString(),
                                    sizes: [],
                                    index: gridIndex,
                                    cart_fav: false,
                                    Images: [],
                                    favourite: false,
                                    id: products[gridIndex]["id"],
                                    Product: result,
                                    IDs: commaSeparatedIds,
                                  ),
                                );
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
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    products[gridIndex]
                                                            ["title"] ??
                                                        "",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              products[gridIndex].containsKey(
                                                          "price") &&
                                                      products[gridIndex]
                                                              ["price"] !=
                                                          null
                                                  ? Text(
                                                      products[gridIndex]
                                                                  ["price"]
                                                              is double
                                                          ? "₪${(products[gridIndex]["price"] as double).toStringAsFixed(2)}"
                                                          : (double.tryParse(products[
                                                                              gridIndex]
                                                                          [
                                                                          "price"]
                                                                      .toString()) !=
                                                                  null
                                                              ? "₪${double.parse(products[gridIndex]["price"]).toStringAsFixed(2)}"
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
                                            image: NetworkImage(
                                              product["vendor_images_links"]
                                                          ?.isNotEmpty ==
                                                      true
                                                  ? product[
                                                      "vendor_images_links"][0]
                                                  : "https://www.fawri.co/assets/about_us/fawri_logo.jpg",
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
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
                  );
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    color: Colors.white,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
