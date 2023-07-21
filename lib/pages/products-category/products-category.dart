import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../components/product_widget/product-widget.dart';
import '../../constants/constants.dart';
import '../../server/functions/functions.dart';

class ProductsCategories extends StatefulWidget {
  final category_id;
  const ProductsCategories({super.key, this.category_id});

  @override
  State<ProductsCategories> createState() => _ProductsCategoriesState();
}

class _ProductsCategoriesState extends State<ProductsCategories> {
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          body: _isFirstLoadRunning
              ? Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: SpinKitPulse(
                      color: MAIN_COLOR,
                      size: 60,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_sharp,
                                color: MAIN_COLOR,
                                size: 30,
                              ))
                        ],
                      ),
                    ),
                    AllProducts.length == 0
                        ? Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Text(
                              "لا يوجد أي منتج",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 30, right: 10, left: 10),
                              child: AnimationLimiter(
                                child: GridView.builder(
                                    controller: _controller,
                                    // scrollDirection: Axis.vertical,
                                    // physics: NeverScrollableScrollPhysics(),
                                    // shrinkWrap: true,
                                    // primary: false,
                                    itemCount: AllProducts.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 6,
                                      mainAxisSpacing: 6,
                                      childAspectRatio: 0.63,
                                    ),
                                    itemBuilder: (context, int index) {
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: SlideAnimation(
                                          horizontalOffset: 100.0,
                                          // verticalOffset: 100.0,
                                          child: FadeInAnimation(
                                            curve: Curves.easeOut,
                                            child: ProductWidget(
                                                index: index,
                                                name: AllProducts[index]
                                                    ["title"],
                                                new_price: 69.99,
                                                old_price: 30.99,
                                                image: AllProducts[index]
                                                    ["vendor_images_links"][0]),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ),
                    // when the _loadMore function is running
                    if (_isLoadMoreRunning == true)
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 40),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: MAIN_COLOR,
                          ),
                        ),
                      ),

                    // When nothing else to load
                    if (_hasNextPage == false)
                      Container(
                        padding: const EdgeInsets.only(top: 30, bottom: 40),
                        color: MAIN_COLOR,
                        child: const Center(
                          child: Text('You have fetched all of the products'),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  var AllProducts;
  // At the beginning, we fetch the first 20 posts
  int _page = 1;
  // you can change this value to fetch more or less posts per page (10, 15, 5, etc)
  final int _limit = 20;
  // There is next page or not
  bool _hasNextPage = true;
  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;
  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      var _products = await getProductByCategory(widget.category_id, _page);
      setState(() {
        AllProducts = _products["items"];
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller!.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      try {
        var _products = await getProductByCategory(widget.category_id, _page);
        if (_products.isNotEmpty) {
          setState(() {
            AllProducts.addAll(_products["items"]);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  // The controller for the ListView
  ScrollController? _controller;
  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller?.removeListener(_loadMore);
    super.dispose();
  }
}
