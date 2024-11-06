import 'package:fawri_app_refactor/components/product_widget/product-widget.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../../../../LocalDB/Provider/CartProvider.dart';
import '../../../../LocalDB/Provider/FavouriteProvider.dart';
import '../../../../constants/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../server/domain/domain.dart';

class SliderProducts extends StatefulWidget {
  final url, title;
  const SliderProducts({super.key, required this.url, required this.title});

  @override
  State<SliderProducts> createState() => _SliderProductsState();
}

class _SliderProductsState extends State<SliderProducts> {
  @override
  TextEditingController? textController;
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
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
                                  child: GridView.builder(
                                      cacheExtent: 1000,
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
                                        final isLiked =
                                            Provider.of<FavouriteProvider>(
                                                    context)
                                                .isProductFavorite(
                                                    AllProducts[index]["id"]);
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
                                                  bannerTitle: "",
                                                  hasAPI: false,
                                                  cardHeight: 0,
                                                  cardWidth: 0,
                                                  priceMul: 1,
                                                  inCart: cartProvider.isProductCart(
                                                      AllProducts[index]["id"]),
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
                                                  Images: AllProducts[index][
                                                          "vendor_images_links"] ??
                                                      [],
                                                  Products: AllProducts,
                                                  index: index,
                                                  name: AllProducts[index]
                                                      ["title"],
                                                  thumbnail: AllProducts[index]
                                                      ["thumbnail"],
                                                  id: AllProducts[index]["id"],
                                                  new_price: AllProducts[index]
                                                      ["price"],
                                                  old_price: AllProducts[index]
                                                          ["price"] ??
                                                      0.0,
                                                  image: AllProducts[index]
                                                          ["vendor_images_links"]
                                                      [0]),
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
                  child: Text('لا يوجد المزيد من المنتجات'),
                ),
              ),
          ],
        ),
        Opacity(
          opacity: 0.7,
          child: Container(
            width: double.infinity,
            height: 40,
            color: MAIN_COLOR,
            child: Center(
              child: Text(
                widget.title,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _refreshData() async {
    // Add your refresh logic here, for example, fetching new data
    await Future.delayed(Duration(seconds: 2)); // Simulate a delay
    _page += 1; // Increase _page by 1
    try {
      var _products = await getSliderProducts(widget.url, _page);
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
        var _products = await getSliderProducts(widget.url, _page);
        setState(() {
          AllProducts = _products["items"];
          // Store the fetched data in the cache
          cache["all_products"] = AllProducts;
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
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      try {
        // Fetch data from the API
        var _products = await getSliderProducts(widget.url, _page);
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

  Map<String, List<dynamic>> cache = {};
  ScrollController _controller = ScrollController();
  @override
  void initState() {
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
