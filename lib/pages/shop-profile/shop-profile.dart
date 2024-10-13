// import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
// import 'package:fawri_app_refactor/components/product_widget/product-widget.dart';
// import 'package:fawri_app_refactor/pages/cart/cart.dart';
// import 'package:fawri_app_refactor/server/functions/functions.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import '../../../LocalDB/Provider/CartProvider.dart';
// import '../../../LocalDB/Provider/FavouriteProvider.dart';
// import '../../../constants/constants.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import '../../../server/domain/domain.dart';
// import '../../components/cart_icon/cart_icon.dart';

// class ShopProfile extends StatefulWidget {
//   final image, name;
//   int rank;
//   ShopProfile(
//       {super.key, required this.image, required this.name, required this.rank});

//   @override
//   State<ShopProfile> createState() => _ShopProfileState();
// }

// class _ShopProfileState extends State<ShopProfile> {
//   @override
//   TextEditingController? textController;
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context);
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(40),
//         child: AppBar(
//           backgroundColor: MAIN_COLOR,
//           centerTitle: true,
//           title: Text(
//             "فوري",
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           actions: [
//             Stack(
//               alignment: Alignment.topRight,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     NavigatorFunction(context, Cart());
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(6.0),
//                     child: Image.asset(
//                       "assets/images/shopping-cart.png",
//                       height: 35,
//                       width: 35,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 Consumer<CartProvider>(
//                   builder: (context, cartProvider, _) {
//                     int itemCount = cartProvider.cartItemsCount;
//                     return CartIcon(itemCount);
//                   },
//                 )
//               ],
//             )
//           ],
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(
//                 Icons.arrow_back_rounded,
//                 color: Colors.white,
//               )),
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 15,
//           ),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Stack(
//               alignment: Alignment.bottomCenter,
//               children: [
//                 Container(
//                   width: 150,
//                   height: 150,
//                   child: FancyShimmerImage(
//                     shimmerDuration: Duration(milliseconds: 0),
//                     imageUrl: widget.image,
//                     width: 150,
//                     height: 150,
//                     boxFit: BoxFit.cover,
//                     errorWidget: Image.asset(
//                       "assets/images/playstore.png",
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: Text(
//               widget.name,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 22,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: Text(
//               widget.rank.toString(),
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//           ),
//           _isFirstLoadRunning
//               ? Container(
//                   width: double.infinity,
//                   height: 400,
//                   child: Center(
//                     child: SpinKitPulse(
//                       color: MAIN_COLOR,
//                       size: 60,
//                     ),
//                   ),
//                 )
//               : no_internet
//                   ? Container(
//                       height: MediaQuery.of(context).size.height - 100,
//                       width: double.infinity,
//                       child: Center(
//                         child: Text(
//                           "لا يوجد اتصال بالانترنت , الرجاء التحقق منه",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 18),
//                         ),
//                       ),
//                     )
//                   : AllProducts.length == 0
//                       ? Padding(
//                           padding: const EdgeInsets.only(top: 50),
//                           child: Text(
//                             "لا يوجد أي منتج",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 18),
//                           ),
//                         )
//                       : Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 15, right: 10, left: 10),
//                             child: AnimationLimiter(
//                               child: RefreshIndicator(
//                                 onRefresh: _refreshData,
//                                 child: LayoutBuilder(
//                                     builder: (context, constraints) {
//                                   double width = constraints.maxWidth;
//                                   double height = constraints.maxHeight;

//                                   double cardWidth = 420;
//                                   double cardHeight = 420;
//                                   return GridView.builder(
//                                       cacheExtent: 5000,
//                                       controller: _controller,
//                                       itemCount: AllProducts.length,
//                                       gridDelegate:
//                                           const SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisCount: 2,
//                                         crossAxisSpacing: 6,
//                                         mainAxisSpacing: 10,
//                                         childAspectRatio: 0.48,
//                                       ),
//                                       itemBuilder: (context, int index) {
//                                         final isLiked =
//                                             Provider.of<FavouriteProvider>(
//                                                     context)
//                                                 .isProductFavorite(
//                                                     AllProducts[index]["id"]);
//                                         return AnimationConfiguration
//                                             .staggeredList(
//                                           position: index,
//                                           duration:
//                                               const Duration(milliseconds: 500),
//                                           child: SlideAnimation(
//                                             horizontalOffset: 100.0,
//                                             // verticalOffset: 100.0,
//                                             child: FadeInAnimation(
//                                               curve: Curves.easeOut,
//                                               child: ProductWidget(
//                                                   cardHeight:
//                                                       cardHeight.toInt(),
//                                                   cardWidth: cardWidth.toInt(),
//                                                   priceMul: 1,
//                                                   inCart: cartProvider.isProductCart(
//                                                       AllProducts[index]["id"]),
//                                                   SIZES: [],
//                                                   ALL: true,
//                                                   url:
//                                                       "${URL}getAllItems?api_key=$key_bath&page=$_page",
//                                                   isLiked: isLiked,
//                                                   Sub_Category_Key:
//                                                       Sub_Category_Key,
//                                                   SubCategories: [],
//                                                   page: _page,
//                                                   sizes: [],
//                                                   home: true,
//                                                   category_id: "",
//                                                   size: "",
//                                                   Images: AllProducts[index]["vendor_images_links"].length == 0
//                                                       ? [
//                                                           "https://www.fawri.co/assets/about_us/fawri_logo.jpg"
//                                                         ]
//                                                       : AllProducts[index]["vendor_images_links"] ??
//                                                           [
//                                                             "https://www.fawri.co/assets/about_us/fawri_logo.jpg"
//                                                           ],
//                                                   Products: AllProducts,
//                                                   index: index,
//                                                   name: AllProducts[index]
//                                                       ["title"],
//                                                   thumbnail: AllProducts[index]
//                                                       ["thumbnail"],
//                                                   id: AllProducts[index]["id"],
//                                                   new_price: AllProducts[index]
//                                                       ["price"],
//                                                   old_price: AllProducts[index]
//                                                           ["price"] ??
//                                                       0.0,
//                                                   image: AllProducts[index]["vendor_images_links"].length ==
//                                                           0
//                                                       ? "https://www.fawri.co/assets/about_us/fawri_logo.jpg"
//                                                       : AllProducts[index]
//                                                           ["vendor_images_links"][0]),
//                                             ),
//                                           ),
//                                         );
//                                       });
//                                 }),
//                               ),
//                             ),
//                           ),
//                         ),
//           // when the _loadMore function is running
//           if (_isLoadMoreRunning == true)
//             Padding(
//               padding: EdgeInsets.only(top: 10, bottom: 40),
//               child: Center(
//                 child: CircularProgressIndicator(
//                   color: MAIN_COLOR,
//                 ),
//               ),
//             ),

//           // When nothing else to load
//           if (_hasNextPage == false)
//             Container(
//               padding: const EdgeInsets.only(top: 30, bottom: 40),
//               color: MAIN_COLOR,
//               child: const Center(
//                 child: Text('You have fetched all of the products'),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Future<void> _refreshData() async {
//     // Add your refresh logic here, for example, fetching new data
//     await Future.delayed(Duration(seconds: 2)); // Simulate a delay
//     _page += 1; // Increase _page by 1
//     try {
//       var _products = await getProducts(_page);
//       if (_products.isNotEmpty) {
//         setState(() {
//           AllProducts = [];

//           AllProducts = _products["items"];
//         });
//       } else {
//         print("_hasNextPage = false");
//       }
//     } catch (err) {
//       if (kDebugMode) {
//         print('Something went wrong!');
//       }
//     }
//   }

// List<int> selectedIndexes = [];
// int Sub_Category_Number = 0;
// String Sub_Category_Key = sub_categories_women_appearel[0]["key"].toString();
// var AllProducts;
// // At the beginning, we fetch the first 20 posts
// int _page = 1;
// // you can change this value to fetch more or less posts per page (10, 15, 5, etc)
// final int _limit = 20;
// // There is next page or not
// bool _hasNextPage = true;
// // Used to display loading indicators when _firstLoad function is running
// bool _isFirstLoadRunning = false;
// // Used to display loading indicators when _loadMore function is running
// bool _isLoadMoreRunning = false;

// bool no_internet = false;

//   void _firstLoad() async {
//     setState(() {
//       _isFirstLoadRunning = true;
//     });

//     bool isConnected = await checkInternetConnectivity();
//     if (!isConnected) {
//       no_internet = true;
//       _isFirstLoadRunning = false;
//       setState(() {});
//       return;
//     } else {
//       try {
//         // Check if data for the current sub-category key exists in the cache
//         if (cache.containsKey("all_products")) {
//           // Use the cached data
//           setState(() {
//             AllProducts = cache["all_products"];
//           });
//         } else {
//           // Fetch data from the API
//           var _products = await getProducts(_page);
//           setState(() {
//             AllProducts = _products["items"];
//             // Store the fetched data in the cache
//             cache["all_products"] = AllProducts;
//           });
//         }
//       } catch (err) {
//         if (kDebugMode) {
//           print('Something went wrong');
//         }
//       }
//       setState(() {
//         _isFirstLoadRunning = false;
//       });
//     }
//   }

//   // This function will be triggered whenver the user scroll
//   // to near the bottom of the list view
//   void _loadMore() async {
//     if (_hasNextPage == true &&
//         _isFirstLoadRunning == false &&
//         _isLoadMoreRunning == false &&
//         _controller.position.extentAfter < 300) {
//       setState(() {
//         _isLoadMoreRunning = true; // Display a progress indicator at the bottom
//       });
//       _page += 1; // Increase _page by 1
//       try {
//         // Fetch data from the API
//         var _products = await getProducts(_page);
//         if (_products["items"].isNotEmpty) {
//           setState(() {
//             AllProducts.addAll(_products["items"]);
//           });
//         } else {
//           Fluttertoast.showToast(
//               msg: "لا يوجد المزيد من المنتجات ، قم بتصفح الاقسام الأُخرى");
//         }
//       } catch (err) {
//         if (kDebugMode) {
//           print('Something went wrong!');
//         }
//       }

//       setState(() {
//         _isLoadMoreRunning = false;
//       });
//     }
//   }

//   Map<String, List<dynamic>> cache = {};
//   ScrollController _controller = ScrollController();
//   @override
//   void initState() {
//     super.initState();
//     _firstLoad();
//     _controller = ScrollController()..addListener(_loadMore);
//   }

//   @override
//   void dispose() {
//     _controller.removeListener(_loadMore);
//     super.dispose();
//   }
// }

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fawri_app_refactor/components/product_widget/product-widget.dart';
import 'package:fawri_app_refactor/pages/cart/cart.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../LocalDB/Provider/CartProvider.dart';
import '../../../LocalDB/Provider/FavouriteProvider.dart';
import '../../../constants/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../server/domain/domain.dart';
import '../../components/cart_icon/cart_icon.dart';

class ShopProfile extends StatefulWidget {
  final String image;
  final String name;
  int rank;

  ShopProfile(
      {super.key, required this.image, required this.name, required this.rank});

  @override
  State<ShopProfile> createState() => _ShopProfileState();
}

class _ShopProfileState extends State<ShopProfile> {
  TextEditingController? textController;
  List<int> selectedIndexes = [];
  int Sub_Category_Number = 0;
  String Sub_Category_Key = sub_categories_women_appearel[0]["key"].toString();
  var AllProducts;
  int _page = 1;
  final int _limit = 20;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  bool no_internet = false;
  final int limit = 20;
  Map<String, List<dynamic>> cache = {};
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller.addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          backgroundColor: MAIN_COLOR,
          centerTitle: true,
          title: Text(
            "فوري",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                InkWell(
                  onTap: () {
                    NavigatorFunction(context, Cart());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.asset(
                      "assets/images/shopping-cart.png",
                      height: 35,
                      width: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
                Consumer<CartProvider>(
                  builder: (context, cartProvider, _) {
                    int itemCount = cartProvider.cartItemsCount;
                    return CartIcon(itemCount);
                  },
                )
              ],
            )
          ],
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              )),
        ),
      ),
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 150.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.all(0),
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.image),
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Rank: ${widget.rank}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                background: Container()),
            leading: Container(),
          ),
          SliverToBoxAdapter(
            child: _isFirstLoadRunning
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
                    ? Center(
                        child: Text(
                          "لا يوجد اتصال بالانترنت , الرجاء التحقق منه",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : AllProducts.isEmpty
                        ? Center(
                            child: Text(
                              "لا يوجد أي منتج",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10),
                            child: AnimationLimiter(
                              child: RefreshIndicator(
                                onRefresh: _refreshData,
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
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
                                        Provider.of<FavouriteProvider>(context)
                                            .isProductFavorite(
                                                AllProducts[index]["id"]);
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: SlideAnimation(
                                        horizontalOffset: 100.0,
                                        child: FadeInAnimation(
                                          curve: Curves.easeOut,
                                          child: ProductWidget(
                                            cardHeight: 420,
                                            cardWidth: 420,
                                            priceMul: 1,
                                            inCart: cartProvider.isProductCart(
                                                AllProducts[index]["id"]),
                                            SIZES: [],
                                            ALL: true,
                                            url:
                                                "${URL}getAllItems?api_key=$key_bath&page=$_page",
                                            isLiked: isLiked,
                                            Sub_Category_Key: Sub_Category_Key,
                                            SubCategories: [],
                                            page: _page,
                                            sizes: [],
                                            home: true,
                                            category_id: "",
                                            size: "",
                                            Images: AllProducts[index]
                                                        ["vendor_images_links"]
                                                    .isEmpty
                                                ? [
                                                    "https://www.fawri.co/assets/about_us/fawri_logo.jpg"
                                                  ]
                                                : AllProducts[index]
                                                    ["vendor_images_links"],
                                            Products: AllProducts,
                                            index: index,
                                            name: AllProducts[index]["title"],
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
                                                    .isEmpty
                                                ? "https://www.fawri.co/assets/about_us/fawri_logo.jpg"
                                                : AllProducts[index]
                                                    ["vendor_images_links"][0],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
          ),
          if (_isLoadMoreRunning)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 40),
                child: Center(
                  child: CircularProgressIndicator(
                    color: MAIN_COLOR,
                  ),
                ),
              ),
            ),
          if (!_hasNextPage)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(top: 30, bottom: 40),
                color: MAIN_COLOR,
                child: const Center(
                  child: Text('You have fetched all of the products'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    _page += 1;
    try {
      var _products = await getProducts(_page);
      if (_products.isNotEmpty) {
        setState(() {
          AllProducts = _products["items"];
        });
      }
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong!');
      }
    }
  }

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
        // Check if data for the current sub-category key exists in the cache
        if (cache.containsKey("all_products")) {
          // Use the cached data
          setState(() {
            AllProducts = cache["all_products"];
          });
        } else {
          // Fetch data from the API
          var _products = await getProducts(_page);
          setState(() {
            AllProducts = _products["items"];
            // Store the fetched data in the cache
            cache["all_products"] = AllProducts;
          });
        }
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
        var _products = await getProducts(_page);
        if (_products["items"].isNotEmpty) {
          setState(() {
            AllProducts.addAll(_products["items"]);
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
}
