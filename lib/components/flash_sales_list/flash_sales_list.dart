import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import '../../constants/constants.dart';
import '../../pages/product-screen/product-screen.dart';
import '../../server/domain/domain.dart';
import '../../server/functions/functions.dart';

class FlashSalesList extends StatefulWidget {
  final List shortlisted;
  final String title;

  FlashSalesList({
    Key? key,
    required this.shortlisted,
    required this.title,
  }) : super(key: key);

  @override
  _FlashSalesListState createState() => _FlashSalesListState();
}

class _FlashSalesListState extends State<FlashSalesList> {
  ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isEndReached = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels == 0) {
        // Reached the top
      } else {
        // Reached the bottom
        if (!_isLoading && !_isEndReached) {
          _loadMore();
        }
      }
    }
  }

  void _loadMore() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a delay to fetch more data (replace with your actual data fetching logic)
    await Future.delayed(Duration(seconds: 1));

    // Example logic to fetch more data and update the list
    var newItems = await getProducts(
        _currentPage + 1); // Replace with your actual data fetching logic

    setState(() {
      if (newItems.isEmpty) {
        _isEndReached = true; // Indicates no more data available
      } else {
        widget.shortlisted
            .addAll(newItems["items"]); // Append new items to the existing list
        _currentPage++;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
            child: Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: AnimationLimiter(
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      widget.shortlisted.length + (_isEndReached ? 0 : 1),
                  itemBuilder: (context, int index) {
                    if (index < widget.shortlisted.length) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          horizontalOffset: 100.0,
                          child: FadeInAnimation(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, left: 10),
                              child: InkWell(
                                onTap: () {
                                  List result = [];
                                  int startIndex = index - 20;
                                  int endIndex = index + 20;
                                  if (startIndex < 0) {
                                    startIndex = 0;
                                  }
                                  if (endIndex > widget.shortlisted.length) {
                                    endIndex = widget.shortlisted.length;
                                  }
                                  result.addAll(widget.shortlisted
                                      .sublist(startIndex, endIndex));
                                  result.insert(0, widget.shortlisted[index]);
                                  List<String> idsList = result
                                      .map((item) => item['id'].toString())
                                      .toList();
                                  String commaSeparatedIds = idsList.join(', ');
                                  NavigatorFunction(
                                      context,
                                      ProductScreen(
                                        priceMul: 1.0,
                                        price: widget.shortlisted[index]
                                                ["price"]
                                            .toString(),
                                        SIZES: [],
                                        ALL: true,
                                        SubCategories: [],
                                        url:
                                            "${URL}getAllItems?api_key=$key_bath&page=1",
                                        page: 1,
                                        Sub_Category_Key:
                                            sub_categories_women_appearel[0]
                                                    ["key"]
                                                .toString(),
                                        sizes: [],
                                        index: index,
                                        cart_fav: false,
                                        Images: [],
                                        favourite: false,
                                        id: widget.shortlisted[index]["id"],
                                        Product: result,
                                        IDs: commaSeparatedIds,
                                      ));
                                },
                                child: Container(
                                  width: 160,
                                  decoration:
                                      BoxDecoration(color: Colors.transparent),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 180,
                                                  child: FancyShimmerImage(
                                                    imageUrl: widget
                                                                .shortlisted[
                                                                    index][
                                                                    "vendor_images_links"]
                                                                .length ==
                                                            0
                                                        ? "https://www.fawri.co/assets/about_us/fawri_logo.jpg"
                                                        : widget.shortlisted[
                                                                        index][
                                                                    "vendor_images_links"]
                                                                [0] ??
                                                            "https://www.fawri.co/assets/about_us/fawri_logo.jpg",
                                                    width: double.infinity,
                                                    height: 240,
                                                    boxFit: BoxFit.cover,
                                                    errorWidget: Image.asset(
                                                      "assets/images/splash.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Opacity(
                                                opacity: 0.75,
                                                child: Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: Lottie.asset(
                                                      "assets/lottie_animations/Animation - 1720525210493.json",
                                                      height: 50,
                                                      reverse: true,
                                                      repeat: true,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 160,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 5, top: 3),
                                              child: Text(
                                                widget
                                                            .shortlisted[index]
                                                                ["title"]
                                                            .length >
                                                        15
                                                    ? widget.shortlisted[index]
                                                            ["title"]
                                                        .substring(0, 15)
                                                    : widget.shortlisted[index]
                                                        ["title"],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: Row(
                                          children: [
                                            Text(
                                              "₪${widget.shortlisted[index]["price"]}",
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
                                                      "₪${double.parse(widget.shortlisted[index]["price"].toString()) * 2.5}",
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox(width: 20); // Adjust width as needed
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
