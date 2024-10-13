import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/pages/product-screen/product-screen.dart';
import 'package:fawri_app_refactor/server/domain/domain.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:lottie/lottie.dart';

class ProductWidgetStyleFour extends StatefulWidget {
  int index;
  var shortlisted;
  bool fire;
  ProductWidgetStyleFour({
    Key? key,
    required this.index,
    required this.shortlisted,
    required this.fire,
  }) : super(key: key);

  @override
  State<ProductWidgetStyleFour> createState() => _ProductWidgetStyleFourState();
}

class _ProductWidgetStyleFourState extends State<ProductWidgetStyleFour> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
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
              result.map((item) => item['item_id'].toString()).toList();
          String commaSeparatedIds = idsList.join(', ');
          NavigatorFunction(
              context,
              ProductScreen(
                priceMul: 1.0,
                price: widget.shortlisted[widget.index]["new_price"].toString(),
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
                Images: [],
                favourite: false,
                id: widget.shortlisted[widget.index]["item_id"],
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
                      width: 150,
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  child: FancyShimmerImage(
                                    shimmerDuration: Duration(milliseconds: 0),
                                    imageUrl: widget
                                                .shortlisted[widget.index]
                                                    ["images"]
                                                .length ==
                                            0
                                        ? "https://www.fawri.co/assets/about_us/fawri_logo.jpg"
                                        : widget.shortlisted[widget.index]
                                                ["images"][0] ??
                                            "https://www.fawri.co/assets/about_us/fawri_logo.jpg",
                                    width: double.infinity,
                                    height: 200,
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
                                    widget
                                                .shortlisted[widget.index]
                                                    ["item_name"]
                                                .length >
                                            15
                                        ? widget.shortlisted[widget.index]
                                                ["item_name"]
                                            .substring(0, 15)
                                        : widget.shortlisted[widget.index]
                                            ["item_name"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
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
                                // Check if new_price exists and is not null
                                widget.shortlisted[widget.index]
                                            .containsKey("new_price") &&
                                        widget.shortlisted[widget.index]
                                                ["new_price"] !=
                                            null
                                    ? Text(
                                        widget.shortlisted[widget.index]
                                                ["new_price"] is double
                                            ? "₪${(widget.shortlisted[widget.index]["new_price"] as double).toStringAsFixed(2)}"
                                            : (double.tryParse(widget
                                                        .shortlisted[widget
                                                            .index]["new_price"]
                                                        .toString()) !=
                                                    null
                                                ? "₪${double.parse(widget.shortlisted[widget.index]["new_price"]).toStringAsFixed(2)}"
                                                : "₪0"),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.red,
                                        ),
                                      )
                                    : Container(), // Hide if new_price is missing or null
                                SizedBox(width: 5),
                                // Check if old_price exists and is not null
                                widget.shortlisted[widget.index]
                                            .containsKey("old_price") &&
                                        widget.shortlisted[widget.index]
                                                ["old_price"] !=
                                            null
                                    ? Column(
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Text(
                                                "₪${(double.parse(widget.shortlisted[widget.index]["old_price"].toString()) * 2.5).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Container(
                                                height: 1,
                                                width: 50,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Container(), // Hide if old_price is missing or null
                              ],
                            ),
                          )
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
