import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';

import '../../LocalDB/Provider/CartProvider.dart';
import '../../LocalDB/Provider/FavouriteProvider.dart';
import '../../components/product_widget/product-widget.dart';
import '../../constants/constants.dart';
import '../../server/domain/domain.dart';
import '../../server/functions/functions.dart';
import '../../services/app_bar/app_bar.dart';
import '../../services/dash_point/dash_point.dart';
import '../home_screen/category-screen/category-screen.dart';
import '../home_screen/favourite-screen/favourite-screen.dart';
import '../home_screen/main-screen/main-screen.dart';
import '../home_screen/profile-screen/profile-screen.dart';
import '../search_screen/search_screen.dart';

class ProductsCategories extends StatefulWidget {
  final category_id, size;
  var sizes, containerWidths, keys, main_category, name, title, type, SIZES;
  bool search;
  ProductsCategories(
      {super.key,
      this.category_id,
      this.size,
      this.title,
      this.type,
      required this.sizes,
      required this.SIZES,
      required this.name,
      required this.search,
      required this.main_category,
      required this.keys,
      required this.containerWidths});

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

  GlobalKey _one = GlobalKey();

  // Function to check if the showcase has been shown before
  Future<bool> hasShowcaseBeenShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('showcaseShown') ?? false;
  }

  // Function to mark the showcase as shown
  Future<void> markShowcaseAsShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showcaseShown', true);
  }

  void startShowCase() async {
    bool showcaseShown = await hasShowcaseBeenShown();

    if (!showcaseShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([_one]);
      });

      // Mark the showcase as shown
      markShowcaseAsShown();
    }
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
                child: ShowCaseWidget(
                    builder: Builder(
                        builder: (context) => AppBarWidget(
                              main_Category: widget.category_id,
                              containerWidths: widget.containerWidths,
                              keys: widget.keys,
                              name: widget.name,
                              sizes: widget.sizes,
                            ))),
                preferredSize: Size.fromHeight(50)),
            body: _listOfWidget[selectedIndex]),
      ),
    );
  }

  var selectedCategoryKeys = [];

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    _page += 1;
    try {
      String concatenatedNames =
          Sub_Category_Key.join('.').replaceAll('.', ',');
      var _products = await getProductByCategory(
          widget.category_id == "Women Shoes" ||
                  widget.category_id == "Men Shoes"
              ? "Shoes"
              : widget.category_id == "Underwear & Sleepwear"
                  ? "Underwear %26 Sleepwear"
                  : widget.category_id ==
                          "Home %26 Living,Tools %26 Home Improvement"
                      ? "Home %26 Living,Tools %26 Home Improvement"
                      : widget.category_id == "Sports & Outdoor"
                          ? "Sports %26 Outdoor"
                          : widget.category_id == "Women Apparel Baby"
                              ? "Women Apparel"
                              : widget.category_id == "Jewelry & Watches"
                                  ? "Jewelry %26 Watches"
                                  : widget.category_id == "Beauty & Health"
                                      ? "Beauty %26 Health"
                                      : widget.category_id == "Bags & Luggage"
                                          ? "Bags %26 Luggage"
                                          : widget.category_id ==
                                                  "Weddings & Events"
                                              ? "Women Apparel"
                                              : widget.category_id ==
                                                      "Kids Boys"
                                                  ? "Kids"
                                                  : widget.category_id ==
                                                          "Kids Girls"
                                                      ? "Kids"
                                                      : widget.category_id ==
                                                              "Kids Shoes"
                                                          ? "Kids"
                                                          : widget.category_id,
          concatenatedNames,
          widget.size,
          '',
          _page);
      if (_products["items"].isNotEmpty) {
        setState(() {
          AllProducts = [];

          AllProducts = _products["items"];
        });
      } else {
        print("_hasNextPage = false");
      }
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong!');
      }
    }
  }

  List<int> selectedIndexesFirstList = [];
  bool isListView = true;

  Widget ProductsCategoryMethod() {
    final cartProvider = Provider.of<CartProvider>(context);
    return isListView
        ? Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                      child: TextFormField(
                        onTap: () {
                          showSearchDialog(context, widget.category_id);
                        },
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
                          suffixIcon: Container(
                            width: 85,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Visibility(
                                  visible:
                                      SubCategories.length == 0 ? false : true,
                                  child: Showcase(
                                    key: _one,
                                    title: 'اختيار القسم الفرعي',
                                    description: 'هنا يتم اختيار القسم الفرعي',
                                    child: IconButton(
                                      icon: isListView
                                          ? Icon(
                                              Icons.grid_on,
                                              size: 20,
                                            )
                                          : Icon(Icons.list, size: 15),
                                      padding: EdgeInsets.all(5),
                                      onPressed: () {
                                        setState(() {
                                          // Toggle between list and grid view
                                          isListView = !isListView;
                                          if (isListView) {
                                            _page = 1;
                                            _firstLoad();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: SubCategories.length == 0 ? false : true,
                child: Padding(
                    padding: const EdgeInsets.only(top: 5, right: 5, left: 5),
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: SubCategories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Visibility(
                            visible: index == 0
                                ? true
                                : selectedIndexes.contains(index)
                                    ? false
                                    : true,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5, left: 5),
                              child: InkWell(
                                onTap: () {
                                  if (index == 0) {
                                    setState(() {
                                      // Clear both lists
                                      selectedCategoryKeys.clear();
                                      selectedIndexes.clear();
                                      Sub_Category_Key.clear();
                                      Sub_Category_Key.add("");
                                      selectedIndexes.add(0);
                                      SubCategories.add({
                                        "name": "جميع الأقسام",
                                        "key": "",
                                      });
                                      _page = 1;
                                      _firstLoad();
                                    });
                                  } else {
                                    setState(() {
                                      if (selectedIndexes.contains(index)) {
                                        if (Sub_Category_Key.length == 1) {
                                        } else {
                                          int removeIndex =
                                              Sub_Category_Key.indexWhere(
                                                  (key) =>
                                                      key ==
                                                      SubCategories[index]
                                                              ["key"]
                                                          .toString());

                                          if (removeIndex != -1) {
                                            // Remove elements based on the found index
                                            selectedIndexes.remove(index);
                                            Sub_Category_Key.removeAt(
                                                removeIndex);
                                            String categoryName =
                                                SubCategories[index]["name"]
                                                    .toString();
                                            selectedCategoryKeys.removeWhere(
                                                (name) =>
                                                    name["name"] ==
                                                    categoryName);
                                            _page = 1;
                                            _firstLoad();
                                          }
                                        }
                                      } else {
                                        if (Sub_Category_Key[0].toString() ==
                                                "Women Clothing" ||
                                            Sub_Category_Key[0].toString() ==
                                                "" ||
                                            Sub_Category_Key[0].toString() ==
                                                "Weddings & Events" ||
                                            Sub_Category_Key[0].toString() ==
                                                "Kids Shoes" ||
                                            Sub_Category_Key[0].toString() ==
                                                "Men Shoes" ||
                                            Sub_Category_Key[0].toString() ==
                                                "Women Shoes" ||
                                            Sub_Category_Key[0].toString() ==
                                                "Maternity Clothing, Baby" ||
                                            Sub_Category_Key[0].toString() ==
                                                "Women's Fashion Jewelry" ||
                                            Sub_Category_Key[0].toString() ==
                                                "Kids Shoes, Men Shoes, Women Shoes" ||
                                            Sub_Category_Key[0].toString() ==
                                                "Young Boys Clothing,Tween Boys Clothing" ||
                                            Sub_Category_Key[0].toString() ==
                                                "Young Girls Clothing,Tween Girls Clothing") {
                                          selectedIndexes.removeAt(0);
                                          Sub_Category_Key.removeAt(0);
                                        }
                                        selectedIndexes.add(index);

                                        Sub_Category_Key.add(
                                            SubCategories[index]["key"]
                                                .toString());

                                        selectedCategoryKeys.add({
                                          "name": SubCategories[index]["name"]
                                              .toString(),
                                          "key": SubCategories[index]["key"]
                                              .toString(),
                                          "index": index
                                        });
                                        _page = 1;
                                        _firstLoad();
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  height: 40,
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
                            ),
                          );
                        },
                      ),
                    )),
              ),
              Visibility(
                visible: selectedCategoryKeys.length == 0 ? false : true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, right: 5, left: 5),
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    child: ListView.builder(
                        itemCount: selectedCategoryKeys.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 5, left: 5),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (selectedCategoryKeys.length > 1) {
                                        int removeIndex =
                                            Sub_Category_Key.indexWhere((key) =>
                                                key ==
                                                selectedCategoryKeys[index]
                                                        ["key"]
                                                    .toString());
                                        if (removeIndex != -1) {
                                          selectedIndexes.removeWhere(
                                              (selectedIndex) =>
                                                  selectedIndex ==
                                                  selectedCategoryKeys[index]
                                                      ["index"]);
                                          Sub_Category_Key.removeAt(
                                              removeIndex);
                                        }
                                        // Remove sub-category from the second list
                                        selectedCategoryKeys.removeAt(
                                            index); // Remove based on index in this list
                                        _page = 1;
                                        _firstLoad();
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.black,
                                        ),
                                        color: Colors.white),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          selectedCategoryKeys[index]["name"]
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: MAIN_COLOR),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 5, bottom: 5),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (selectedCategoryKeys.length > 1) {
                                        int removeIndex =
                                            Sub_Category_Key.indexWhere((key) =>
                                                key ==
                                                selectedCategoryKeys[index]
                                                        ["key"]
                                                    .toString());
                                        if (removeIndex != -1) {
                                          selectedIndexes.removeWhere(
                                              (selectedIndex) =>
                                                  selectedIndex ==
                                                  selectedCategoryKeys[index]
                                                      ["index"]);
                                          Sub_Category_Key.removeAt(
                                              removeIndex);
                                        }
                                        // Remove sub-category from the second list
                                        selectedCategoryKeys.removeAt(
                                            index); // Remove based on index in this list
                                        _page = 1;
                                        _firstLoad();
                                      }
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/images/x-button.png",
                                    height: 17,
                                    width: 17,
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                  ),
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
                  : no_internet
                      ? Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            "لا يوجد اتصال بالانترنت , الرجاء التحقق منه",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        )
                      : AllProducts.length == 0
                          ? Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Text(
                                "للحصول على نتائج افضل قم بتعديل الحجم المختار",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            )
                          : Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 12, right: 10, left: 10),
                                child: AnimationLimiter(
                                  child: RefreshIndicator(
                                    onRefresh: _refreshData,
                                    child: GridView.builder(
                                        controller: _controller,
                                        cacheExtent: 5000,
                                        itemCount: AllProducts.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 6,
                                          mainAxisSpacing: 6,
                                          childAspectRatio: 0.5,
                                        ),
                                        itemBuilder: (context, int index) {
                                          String concatenatedNames =
                                              Sub_Category_Key.join('.')
                                                  .replaceAll('.', ',');
                                          final isLiked =
                                              Provider.of<FavouriteProvider>(
                                                      context)
                                                  .isProductFavorite(
                                                      AllProducts[index]["id"]);
                                          return AnimationConfiguration
                                              .staggeredList(
                                            position: index,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: SlideAnimation(
                                              horizontalOffset: 100.0,
                                              child: FadeInAnimation(
                                                curve: Curves.easeOut,
                                                child: ProductWidget(
                                                    inCart: cartProvider.isProductCart(
                                                        AllProducts[index]
                                                            ["id"]),
                                                    SIZES: widget.SIZES,
                                                    ALL: false,
                                                    SubCategories:
                                                        SubCategories,
                                                    sizes:
                                                        LocalStorage().sizeUser,
                                                    url:
                                                        "$URL_PRODUCT_BY_CATEGORY?main_category=${widget.category_id == "Women Shoes" || widget.category_id == "Men Shoes" || widget.category_id == "Kids Shoes" ? "Shoes" : widget.category_id}&sub_category=$concatenatedNames&size=${widget.size}&season=Summer&page=$_page&api_key=$key_bath",
                                                    isLiked: isLiked,
                                                    Images:
                                                        AllProducts[index]["vendor_images_links"] ??
                                                            [],
                                                    Products: AllProducts,
                                                    index: index,
                                                    name: AllProducts[index]
                                                        ["title"],
                                                    thumbnail: AllProducts[index]
                                                        ["thumbnail"],
                                                    id: AllProducts[index]
                                                        ["id"],
                                                    new_price: AllProducts[index]
                                                        ["price"],
                                                    old_price: AllProducts[index]
                                                            ["price"] ??
                                                        0.0,
                                                    image: AllProducts[index]
                                                        ["vendor_images_links"][0],
                                                    Sub_Category_Key: Sub_Category_Key,
                                                    page: _page,
                                                    home: false,
                                                    category_id: widget.category_id,
                                                    size: widget.size),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
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
          )
        : Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                          child: TextFormField(
                            onTap: () {
                              showSearchDialog(context, widget.category_id);
                            },
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
                              suffixIcon: Container(
                                width: 85,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    IconButton(
                                      icon: isListView
                                          ? Icon(
                                              Icons.grid_on,
                                              size: 20,
                                            )
                                          : Icon(Icons.list, size: 15),
                                      padding: EdgeInsets.all(5),
                                      onPressed: () {
                                        setState(() {
                                          // Toggle between list and grid view
                                          isListView = !isListView;
                                          if (isListView) {
                                            _page = 1;
                                            _firstLoad();
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2.7,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: 3,
                    ),
                    itemCount: SubCategories.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (selectedIndexes.contains(index)) {
                        // Return an empty container if the item is hidden
                        return Container();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(right: 5, left: 5),
                          child: InkWell(
                            onTap: () {
                              if (index == 0) {
                                setState(() {
                                  // Clear both lists
                                  selectedCategoryKeys.clear();
                                  selectedIndexes.clear();
                                  Sub_Category_Key.clear();
                                  Sub_Category_Key.add("");
                                  selectedIndexes.add(0);
                                  SubCategories.add({
                                    "name": "جميع الأقسام",
                                    "key": "",
                                  });
                                });
                              } else {
                                setState(() {
                                  if (selectedIndexes.contains(index)) {
                                    if (Sub_Category_Key.length == 1) {
                                    } else {
                                      int removeIndex =
                                          Sub_Category_Key.indexWhere((key) =>
                                              key ==
                                              SubCategories[index]["key"]
                                                  .toString());

                                      if (removeIndex != -1) {
                                        // Remove elements based on the found index
                                        selectedIndexes.remove(index);
                                        Sub_Category_Key.removeAt(removeIndex);
                                        String categoryName =
                                            SubCategories[index]["name"]
                                                .toString();
                                        selectedCategoryKeys.removeWhere(
                                            (name) =>
                                                name["name"] == categoryName);
                                      }
                                    }
                                  } else {
                                    if (Sub_Category_Key[0].toString() ==
                                            "Women Clothing" ||
                                        Sub_Category_Key[0].toString() == "" ||
                                        Sub_Category_Key[0].toString() ==
                                            "Weddings & Events" ||
                                        Sub_Category_Key[0].toString() ==
                                            "Kids Shoes" ||
                                        Sub_Category_Key[0].toString() ==
                                            "Men Shoes" ||
                                        Sub_Category_Key[0].toString() ==
                                            "Women Shoes" ||
                                        Sub_Category_Key[0].toString() ==
                                            "Maternity Clothing, Baby" ||
                                        Sub_Category_Key[0].toString() ==
                                            "Women's Fashion Jewelry" ||
                                        Sub_Category_Key[0].toString() ==
                                            "Kids Shoes, Men Shoes, Women Shoes" ||
                                        Sub_Category_Key[0].toString() ==
                                            "Young Boys Clothing,Tween Boys Clothing" ||
                                        Sub_Category_Key[0].toString() ==
                                            "Young Girls Clothing,Tween Girls Clothing") {
                                      selectedIndexes.removeAt(0);
                                      Sub_Category_Key.removeAt(0);
                                    }
                                    selectedIndexes.add(index);

                                    Sub_Category_Key.add(
                                        SubCategories[index]["key"].toString());

                                    selectedCategoryKeys.add({
                                      "name": SubCategories[index]["name"]
                                          .toString(),
                                      "key": SubCategories[index]["key"]
                                          .toString(),
                                      "index": index
                                    });
                                  }
                                });
                              }
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  width: 2,
                                  color: selectedIndexes.contains(index)
                                      ? Colors.red
                                      : Colors.black,
                                ),
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    SubCategories[index]["name"].toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 5,
                      child: CustomPaint(
                        size: Size(200, 70),
                        painter: DashLinePainter(),
                      ),
                    ),
                  ),
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2.7,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: 3,
                    ),
                    itemCount: selectedCategoryKeys.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5, left: 5),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (selectedCategoryKeys.length > 1) {
                                    int removeIndex =
                                        Sub_Category_Key.indexWhere((key) =>
                                            key ==
                                            selectedCategoryKeys[index]["key"]
                                                .toString());
                                    if (removeIndex != -1) {
                                      selectedIndexes.removeWhere(
                                          (selectedIndex) =>
                                              selectedIndex ==
                                              selectedCategoryKeys[index]
                                                  ["index"]);
                                      Sub_Category_Key.removeAt(removeIndex);
                                    }
                                    // Remove sub-category from the second list
                                    selectedCategoryKeys.removeAt(
                                        index); // Remove based on index in this list
                                  }
                                });
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                    color: Colors.white),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      selectedCategoryKeys[index]["name"]
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: MAIN_COLOR),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5, bottom: 5),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (selectedCategoryKeys.length > 1) {
                                    int removeIndex =
                                        Sub_Category_Key.indexWhere((key) =>
                                            key ==
                                            selectedCategoryKeys[index]["key"]
                                                .toString());
                                    if (removeIndex != -1) {
                                      selectedIndexes.removeWhere(
                                          (selectedIndex) =>
                                              selectedIndex ==
                                              selectedCategoryKeys[index]
                                                  ["index"]);
                                      Sub_Category_Key.removeAt(removeIndex);
                                    }
                                    // Remove sub-category from the second list
                                    selectedCategoryKeys.removeAt(
                                        index); // Remove based on index in this list
                                  }
                                });
                              },
                              child: Image.asset(
                                "assets/images/x-button.png",
                                height: 17,
                                width: 17,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }

  List<int> selectedIndexes = [0];
  int Sub_Category_Number = 0;
  List<String> Sub_Category_Key = [];

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
  bool no_internet = false;

  String getCategoryKey() {
    String key = widget.category_id == "Women Shoes" ||
            widget.category_id == "Men Shoes"
        ? "Shoes"
        : widget.category_id == "Underwear & Sleepwear"
            ? "Underwear %26 Sleepwear , Underwear  Sleepwear"
            : widget.category_id == "Home %26 Living,Tools %26 Home Improvement"
                ? "Home %26 Living,Tools  Home Improvement"
                : widget.category_id == "Sports & Outdoor"
                    ? "Sports %26 Outdoor , Sports  Outdoor"
                    : widget.category_id == "Women Apparel Baby"
                        ? "Women Apparel"
                        : widget.category_id == "Jewelry & Watches"
                            ? "Jewelry %26 Watches , Jewelry  Watches"
                            : widget.category_id == "Beauty & Health"
                                ? "Beauty %26 Health , Beauty  Health"
                                : widget.category_id == "Bags & Luggage"
                                    ? "Bags %26 Luggage , Bags  Luggage"
                                    : widget.category_id == "Weddings & Events"
                                        ? "Women Apparel"
                                        : widget.category_id == "Kids Boys"
                                            ? "Kids"
                                            : widget.category_id == "Kids Girls"
                                                ? "Kids"
                                                : widget.category_id ==
                                                        "Kids Shoes"
                                                    ? "Kids"
                                                    : widget.category_id ==
                                                            "Office School Supplies, Office & School Supplies"
                                                        ? "Office School Supplies, Office %26 School Supplies"
                                                        : widget.category_id;
    return key;
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
      isListView = true;
    });
    bool isConnected = await checkInternetConnectivity();
    if (!isConnected) {
      no_internet = true;
      _isFirstLoadRunning = false;
      setState(() {});
      return;
    } else {
      try {
        var _products;
        String concatenatedNames =
            Sub_Category_Key.join('.').replaceAll('.', ',');
        if (widget.search == true) {
          _products = await getSearchResults(getCategoryKey(),
              concatenatedNames, widget.title, widget.type, _page);
        } else {
          _products = await getProductByCategory(
              getCategoryKey(), concatenatedNames, widget.size, '', _page);
        }

        setState(() {
          AllProducts = _products["items"];
        });
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong . $err');
        }
      }
      setState(() {
        _isFirstLoadRunning = false;
      });
    }
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller!.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;
      try {
        var _products;
        String concatenatedNames =
            Sub_Category_Key.join('.').replaceAll('.', ',');
        if (widget.search == true) {
          _products = await getSearchResults(getCategoryKey(),
              concatenatedNames, widget.title, widget.type, _page);
        } else {
          _products = await getProductByCategory(
              getCategoryKey(), concatenatedNames, widget.size, '', _page);
        }
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
    if (widget.name == "ملابس نسائيه مقاس كبير") {
      SubCategories = sub_categories_women_plus_sizes;
      Sub_Category_Key.add("Women Plus Clothing");
    } else if (widget.category_id.toString() == "Women Apparel") {
      SubCategories = sub_categories_women_appearel;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() == "Men Apparel") {
      SubCategories = sub_categories_Men__sizes;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() == "Kids") {
      SubCategories = sub_categories_kids_sizes;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() ==
        "Home %26 Living,Tools %26 Home Improvement") {
      SubCategories = sub_categories_HomeLiving;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() == "Weddings & Events") {
      SubCategories = [];
      Sub_Category_Key.add("Weddings & Events");
    } else if (widget.category_id.toString() == "Sports & Outdoor") {
      SubCategories = sub_categories_SportsOutdoor;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() == "Underwear & Sleepwear") {
      SubCategories = sub_categories_Underware;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() == "Women Shoes") {
      SubCategories = sub_categories_WomenShoes;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() == "Men Shoes") {
      SubCategories = sub_categories_MenShoes;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() == "Kids Shoes") {
      SubCategories = sub_categories_KidsShoes;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() == "Women Apparel Baby") {
      SubCategories = sub_categories_MaternityBaby;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() == "Jewelry & Watches") {
      SubCategories = sub_categories_JewelryWatches;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() == "Apparel Accessories") {
      SubCategories = sub_categories_Accessories;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() == "Beauty & Health") {
      SubCategories = sub_categories_BeautyHealth;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() == "Electronics") {
      SubCategories = sub_categories_Electronics;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() == "Bags & Luggage") {
      SubCategories = sub_categories_BagsLuggage;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() == "Pet Supplies") {
      SubCategories = [];
    } else if (widget.category_id.toString() ==
        "Office School Supplies, Office & School Supplies") {
      SubCategories = [];
    } else if (widget.category_id.toString() == "Automotive") {
      SubCategories = [];
    } else if (widget.category_id.toString() == "Shoes,Kids") {
      SubCategories = sub_categories_ALLShoes;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() == "Kids Boys") {
      SubCategories = sub_categories_Boys;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    } else if (widget.category_id.toString() == "Kids Girls") {
      SubCategories = sub_categories_Girls;
      Sub_Category_Key.add(SubCategories[0]["key"].toString());
    }
    setState(() {});
  }

  // The controller for the ListView
  ScrollController? _controller;

  @override
  void initState() {
    setStaticSubCategories();
    super.initState();
    _firstLoad();
    startShowCase();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller?.removeListener(_loadMore);
    super.dispose();
  }
}
