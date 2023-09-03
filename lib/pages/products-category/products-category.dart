import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import '../../components/product_widget/product-widget.dart';
import '../../constants/constants.dart';
import '../../server/functions/functions.dart';
import '../../services/app_bar/app_bar.dart';
import '../home_screen/category-screen/category-screen.dart';
import '../home_screen/favourite-screen/favourite-screen.dart';
import '../home_screen/main-screen/main-screen.dart';
import '../home_screen/profile-screen/profile-screen.dart';

class ProductsCategories extends StatefulWidget {
  final category_id;
  const ProductsCategories({super.key, this.category_id});

  @override
  State<ProductsCategories> createState() => _ProductsCategoriesState();
}

class _ProductsCategoriesState extends State<ProductsCategories> {
  TextEditingController? textController;
  int selectedIndex = 0;
  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    List<Widget> _listOfWidget = <Widget>[
      ProductsCategoryMethod(),
      CategoryScreen(),
      Favourite(),
      ProfileScreen(),
    ];
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
            bottomNavigationBar: SlidingClippedNavBar(
              backgroundColor: Colors.white,
              onButtonPressed: onButtonPressed,
              iconSize: 30,
              activeColor: MAIN_COLOR,
              selectedIndex: selectedIndex,
              barItems: <BarItem>[
                BarItem(
                  icon: Icons.home,
                  title: "الرئيسيه",
                ),
                BarItem(
                  icon: Icons.category,
                  title: "الأقسام",
                ),
                BarItem(
                  icon: FontAwesomeIcons.heart,
                  title: "المفضله",
                ),
                BarItem(
                  icon: Icons.more,
                  title: "المزيد",
                ),
              ],
            ),
            appBar: PreferredSize(
                child: AppBarWidget(), preferredSize: Size.fromHeight(50)),
            body: _listOfWidget[selectedIndex]),
      ),
    );
  }

  Widget ProductsCategoryMethod() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                child: TextFormField(
                  onTap: () => textController!.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: textController!.value.text.length),
                  controller: textController,
                  onFieldSubmitted: (_) {},
                  obscureText: false,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: "ابحث هنا",
                    // labelStyle:
                    //     FlutterFlowTheme.of(context).bodyText2,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, right: 5, left: 5),
          child: Container(
            height: 40,
            width: double.infinity,
            child: ListView.builder(
                itemCount: SubCategories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (selectedIndexes.contains(index)) {
                            selectedIndexes.remove(index);
                          } else {
                            selectedIndexes.add(index);
                            _firstLoad();
                            Sub_Category_Key =
                                SubCategories[index]["key"].toString();
                            Sub_Category_Number = index;
                          }
                        });
                      },
                      child: Container(
                        height: 40,
                        //  width: ,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 2,
                              color: selectedIndexes.contains(index)
                                  ? Colors.red
                                  : Colors.black,
                            ),
                            color: Colors.black),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              SubCategories[index]["name"].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
        _isFirstLoadRunning
            ? Container(
                width: double.infinity,
                height: 400,
                child: Center(
                  child: SpinKitPulse(
                    color: MAIN_COLOR,
                    size: 60,
                  ),
                ),
              )
            : AllProducts.length == 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text(
                      "لا يوجد أي منتج",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10, right: 10, left: 10),
                      child: AnimationLimiter(
                        child: GridView.builder(
                            controller: _controller,
                            cacheExtent: 5000,
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
                              childAspectRatio: 0.5,
                            ),
                            itemBuilder: (context, int index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 500),
                                child: SlideAnimation(
                                  horizontalOffset: 100.0,
                                  // verticalOffset: 100.0,
                                  child: FadeInAnimation(
                                    curve: Curves.easeOut,
                                    child: ProductWidget(
                                        Images: AllProducts[index]
                                                ["vendor_images_links"] ??
                                            [],
                                        Products: AllProducts,
                                        index: index,
                                        name: AllProducts[index]["title"],
                                        thumbnail: AllProducts[index]
                                            ["thumbnail"],
                                        id: AllProducts[index]["id"],
                                        new_price: AllProducts[index]["price"],
                                        old_price:
                                            AllProducts[index]["price"] ?? 0.0,
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
    );
  }

  List<int> selectedIndexes = [0];
  int Sub_Category_Number = 0;
  String Sub_Category_Key = "";

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
      var _products = await getProductByCategory(
          widget.category_id, Sub_Category_Key, _page);
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
        var _products = await getProductByCategory(
            widget.category_id, Sub_Category_Key, _page);
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

  var SubCategories;

  setStaticSubCategories() {
    if (widget.category_id.toString() == "Women Apparel") {
      SubCategories = sub_categories_women_appearel;
    } else if (widget.category_id.toString() == "Men Apparel") {
      SubCategories = sub_categories_Men__sizes;
    } else if (widget.category_id.toString() == "Kids") {
      SubCategories = sub_categories_kids_sizes;
    } else {
      SubCategories = sub_categories_women_appearel;
    }
    Sub_Category_Key = SubCategories[0]["key"].toString();
    setState(() {});
  }

  // The controller for the ListView
  ScrollController? _controller;
  @override
  void initState() {
    setStaticSubCategories();
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
