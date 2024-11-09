import 'package:fawri_app_refactor/components/product_widget/product-widget.dart';
import 'package:fawri_app_refactor/pages/home_screen/main-screen/count-down-time-widget/count-down-time-widget.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../LocalDB/Provider/CartProvider.dart';
import '../../../LocalDB/Provider/FavouriteProvider.dart';
import '../../../constants/constants.dart';
import '../../../server/domain/domain.dart';

class MainScreen extends StatefulWidget {
  bool hasAPI = false;
  String API = "";
  String type = "";
  String bannerTitle = "";
  MainScreen({
    Key? key,
    required this.type,
    required this.bannerTitle,
    required this.hasAPI,
    required this.API,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  bool showTutorial = false;
  bool isFirstOpen = false;
  int currentIndex = 0;
  bool tutorialActive = true;

  Future<void> _checkFirstOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _isFirstOpen = prefs.getBool('isFirstOpen') ?? true;
    setState(() {
      isFirstOpen = _isFirstOpen;
    });

    if (isFirstOpen) {
      setState(() {
        showTutorial = true;
      });
      await prefs.setBool('isFirstOpen', false);
    }
  }

  void stopTutorial() {
    setState(() {
      tutorialActive = false;
      showTutorial = false;
    });
  }

  TextEditingController? textController;
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Stack(
      children: [
        Container(
          color: widget.type == "11.11" ? MAIN_COLOR : Colors.transparent,
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
                          showSearchDialog(context, "Women Apparel");
                        },
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

              widget.type == "11.11"
                  ? Container(
                      width: double.infinity,
                      height: 40,
                      color: MAIN_COLOR,
                      child: Image.asset('assets/images/11shekkkel.gif'))
                  : CountdownTimerWidget(
                      hasAPI:
                          widget.type == "11.11" || widget.type == "discount"
                              ? true
                              : widget.hasAPI,
                      type: widget.bannerTitle,
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
                      ? Container(
                          height: MediaQuery.of(context).size.height - 100,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "لا يوجد اتصال بالانترنت , الرجاء التحقق منه",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        )
                      : AllProducts.length == 0
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
                                    top: 15, right: 10, left: 10),
                                child: AnimationLimiter(
                                  child: RefreshIndicator(
                                    onRefresh: _refreshData,
                                    child: LayoutBuilder(
                                        builder: (context, constraints) {
                                      double width = constraints.maxWidth;
                                      double height = constraints.maxHeight;

                                      double cardWidth = 420;
                                      double cardHeight = 420;
                                      return GridView.builder(
                                          cacheExtent: 5000,
                                          controller: _controller,
                                          itemCount: AllProducts.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 6,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: 0.48,
                                          ),
                                          itemBuilder: (context, int index) {
                                            final isLiked = Provider.of<
                                                    FavouriteProvider>(context)
                                                .isProductFavorite(widget.hasAPI
                                                    ? AllProducts[index]
                                                        ["item_id"]
                                                    : AllProducts[index]["id"]);
                                            return AnimationConfiguration
                                                .staggeredList(
                                              position: index,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              child: SlideAnimation(
                                                horizontalOffset: 100.0,
                                                // verticalOffset: 100.0,
                                                child: FadeInAnimation(
                                                  curve: Curves.easeOut,
                                                  child: ProductWidget(
                                                      bannerTitle:
                                                          widget.bannerTitle,
                                                      hasAPI: widget.hasAPI,
                                                      cardHeight:
                                                          cardHeight.toInt(),
                                                      cardWidth:
                                                          cardWidth.toInt(),
                                                      priceMul: 1,
                                                      inCart: cartProvider.isProductCart(
                                                          widget.hasAPI
                                                              ? AllProducts[index]
                                                                  ["item_id"]
                                                              : AllProducts[index]
                                                                  ["id"]),
                                                      SIZES: [],
                                                      ALL: true,
                                                      url:
                                                          "${URL}getAllItems?api_key=$key_bath&page=$_page",
                                                      isLiked: isLiked,
                                                      Sub_Category_Key:
                                                          Sub_Category_Key,
                                                      SubCategories: [],
                                                      page: _page,
                                                      sizes: [],
                                                      home: true,
                                                      category_id: "",
                                                      size: "",
                                                      Images: widget.hasAPI
                                                          ? AllProducts[index]["images"].length ==
                                                                  0
                                                              ? [
                                                                  "https://www.fawri.co/assets/about_us/fawri_logo.jpg"
                                                                ]
                                                              : AllProducts[index]["images"] ??
                                                                  [
                                                                    "https://www.fawri.co/assets/about_us/fawri_logo.jpg"
                                                                  ]
                                                          : AllProducts[index]["vendor_images_links"].length ==
                                                                  0
                                                              ? [
                                                                  "https://www.fawri.co/assets/about_us/fawri_logo.jpg"
                                                                ]
                                                              : AllProducts[index]["vendor_images_links"] ??
                                                                  [
                                                                    "https://www.fawri.co/assets/about_us/fawri_logo.jpg"
                                                                  ],
                                                      Products: AllProducts,
                                                      index: index,
                                                      name: widget.hasAPI
                                                          ? AllProducts[index]
                                                              ["item_name"]
                                                          : AllProducts[index]
                                                              ["title"],
                                                      thumbnail: AllProducts[index]
                                                              ["thumbnail"] ??
                                                          "https://www.fawri.co/assets/about_us/fawri_logo.jpg",
                                                      id: widget.hasAPI
                                                          ? AllProducts[index]
                                                              ["item_id"]
                                                          : AllProducts[index]["id"],
                                                      new_price: widget.hasAPI
                                                          ? widget.type == "best_seller"
                                                              ? AllProducts[index]["price"]
                                                              : AllProducts[index]["new_price"]
                                                          : AllProducts[index]["price"] ?? 0.0,
                                                      old_price: widget.hasAPI ? AllProducts[index]["old_price"] ?? 0.0 : AllProducts[index]["old_price"] ?? 0.0,
                                                      image: widget.hasAPI
                                                          ? AllProducts[index]["images"].length == 0
                                                              ? "https://www.fawri.co/assets/about_us/fawri_logo.jpg"
                                                              : AllProducts[index]["images"][0]
                                                          : AllProducts[index]["vendor_images_links"].length == 0
                                                              ? "https://www.fawri.co/assets/about_us/fawri_logo.jpg"
                                                              : AllProducts[index]["vendor_images_links"][0]),
                                                ),
                                              ),
                                            );
                                          });
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
                      color: widget.bannerTitle == "11.11"
                          ? Colors.white
                          : MAIN_COLOR,
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
        if (showTutorial && isFirstOpen)
          GestureDetector(
            onTap: stopTutorial,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              color: Colors.transparent,
              child: Lottie.asset(
                  "assets/lottie_animations/Animation - 1730914195220.json",
                  height: MediaQuery.of(context).size.height - 150,
                  reverse: true,
                  repeat: true,
                  fit: BoxFit.cover),
            ),
          ),
      ],
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    _page += 1;
    try {
      var _products = await getProducts(_page);
      if (_products.isNotEmpty) {
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

  List<int> selectedIndexes = [];
  int Sub_Category_Number = 0;
  String Sub_Category_Key = sub_categories_women_appearel[0]["key"].toString();
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

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    bool isConnected = await checkInternetConnectivity();
    if (!isConnected) {
      no_internet = true;
      _isFirstLoadRunning = false;
      setState(() {});
      return;
    } else {
      try {
        if (cache.containsKey("all_products")) {
          setState(() {
            AllProducts = cache["all_products"];
          });
        } else {
          var _products = widget.type == "flash_sales"
              ? await getFlashSales(_page)
              : widget.type == "11.11"
                  ? await get11Products(_page)
                  : widget.type == "discount"
                      ? await getDiscountProducts(_page)
                      : widget.hasAPI
                          ? await getBestSellersProducts(_page)
                          : await getProducts(_page);

          setState(() {
            AllProducts = widget.hasAPI
                ? widget.type == "flash_sales" ||
                        widget.type == "11.11" ||
                        widget.type == "discount"
                    ? _products["items"]
                    : _products["data"]
                : _products["items"];
            cache["all_products"] = AllProducts;
          });
        }
      } catch (err) {}
      setState(() {
        _isFirstLoadRunning = false;
      });
    }
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;
      try {
        var _products = widget.type == "11.11"
            ? await get11Products(_page)
            : widget.hasAPI
                ? widget.type == "flash_sales"
                    ? await getFlashSales(_page)
                    : widget.type == "11.11"
                        ? await get11Products(_page)
                        : widget.type == "discount"
                            ? await getDiscountProducts(_page)
                            : await getBestSellersProducts(_page)
                : await getProducts(_page);

        if (widget.type == "best_seller"
            ? _products["data"].isNotEmpty
            : widget.hasAPI
                ? widget.type == "flash_sales" ||
                        widget.type == "11.11" ||
                        widget.type == "discount"
                    ? _products["items"].isNotEmpty
                    : _products["data"].isNotEmpty
                : _products["items"].isNotEmpty) {
          setState(() {
            AllProducts.addAll(widget.hasAPI
                ? widget.type == "best_seller"
                    ? _products["data"]
                    : widget.type == "flash_sales" ||
                            widget.type == "11.11" ||
                            widget.type == "discount"
                        ? _products["items"]
                        : _products["data"]
                : _products["items"]);
          });
        } else {
          Fluttertoast.showToast(
              msg: "لا يوجد المزيد من المنتجات ، قم بتصفح الاقسام الأُخرى");
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

  Map<String, List<dynamic>> cache = {};
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    if (widget.bannerTitle == "11.11") {
      _checkFirstOpen();
    }
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }
}
