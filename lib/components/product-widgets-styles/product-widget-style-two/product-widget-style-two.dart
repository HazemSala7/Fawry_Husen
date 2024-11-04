import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/pages/product-screen/product-screen.dart';
import 'package:fawri_app_refactor/server/domain/domain.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:lottie/lottie.dart';

class ProductWidgetStyleTwo extends StatefulWidget {
  int index;
  var shortlisted;
  bool fire, check11;
  bool hasAPI = false;
  ProductWidgetStyleTwo({
    Key? key,
    required this.check11,
    required this.hasAPI,
    required this.index,
    required this.shortlisted,
    required this.fire,
  }) : super(key: key);

  @override
  State<ProductWidgetStyleTwo> createState() => _ProductWidgetStyleTwoState();
}

class _ProductWidgetStyleTwoState extends State<ProductWidgetStyleTwo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: InkWell(
        onTap: () {
          List result = [];
          int startIndex = widget.index - 20;
          int endIndex = widget.index + 20;
          if (startIndex < 0) {
            startIndex = 0;
          }
          if (endIndex > widget.shortlisted.length) {
            endIndex = widget.shortlisted.length;
          }
          result.addAll(widget.shortlisted.sublist(startIndex, endIndex));
          result.insert(0, widget.shortlisted[widget.index]);
          List<String> idsList =
              result.map((item) => item['id'].toString()).toList();
          String commaSeparatedIds = idsList.join(', ');

          NavigatorFunction(
              context,
              ProductScreen(
                hasAPI: false,
                priceMul: 1.0,
                price: widget.shortlisted[widget.index]["price"].toString(),
                SIZES: [],
                ALL: true,
                SubCategories: [],
                url: "${URL}getAllItems?api_key=$key_bath&page=1",
                page: 1,
                Sub_Category_Key:
                    sub_categories_women_appearel[0]["key"].toString(),
                sizes: [],
                index: widget.index,
                cart_fav: false,
                Images: widget.shortlisted[widget.index]["vendor_images_links"],
                favourite: false,
                id: widget.shortlisted[widget.index]["id"] ?? 0,
                Product: result,
                IDs: commaSeparatedIds,
              ));
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              children: [
                Container(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      width: 20,
                    ),
                    Container(
                      width: 130,
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 150,
                                  child: FancyShimmerImage(
                                    shimmerDuration: Duration(milliseconds: 0),
                                    imageUrl: widget
                                                .shortlisted[widget.index]
                                                    ["vendor_images_links"]
                                                .length ==
                                            0
                                        ? "https://www.fawri.co/assets/about_us/fawri_logo.jpg"
                                        : widget.shortlisted[widget.index]
                                                ["vendor_images_links"][0] ??
                                            "https://www.fawri.co/assets/about_us/fawri_logo.jpg",
                                    width: double.infinity,
                                    height: 180,
                                    boxFit: BoxFit.cover,
                                    errorWidget: Image.asset(
                                      "assets/images/playstore.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 130,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, top: 3),
                                  child: Text(
                                    widget.shortlisted[widget.index]["title"]
                                                .length >
                                            15
                                        ? widget.shortlisted[widget.index]
                                                ["title"]
                                            .substring(0, 15)
                                        : widget.shortlisted[widget.index]
                                            ["title"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: widget.check11
                                          ? Colors.white
                                          : MAIN_COLOR,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Row(
                              children: [
                                Text(
                                  widget.shortlisted[widget.index]["price"] !=
                                          null
                                      ? (widget.shortlisted[widget.index]
                                              ["price"] is double
                                          ? "₪${(widget.shortlisted[widget.index]["price"] as double).toStringAsFixed(2)}"
                                          : (double.tryParse(widget.shortlisted[
                                                      widget.index]["price"]) !=
                                                  null
                                              ? "₪${double.parse(widget.shortlisted[widget.index]["price"]).toStringAsFixed(2)}"
                                              : "₪0"))
                                      : "₪0",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Text(
                                          "₪${(double.parse(widget.shortlisted[widget.index]["price"].toString()) * 2.5).toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: widget.check11
                                                ? Colors.white
                                                : MAIN_COLOR,
                                          ),
                                        ),
                                        Container(
                                          height: 1,
                                          width: 50,
                                          color: widget.check11
                                              ? Colors.yellow
                                              : Colors.black,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Visibility(
              visible: widget.fire,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Lottie.asset(
                  "assets/lottie_animations/Animation - 1720525210493.json",
                  height: 40,
                  reverse: true,
                  repeat: true,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
