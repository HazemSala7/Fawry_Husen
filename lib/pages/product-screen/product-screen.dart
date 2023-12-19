import 'dart:async';
import 'dart:convert';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:expandable/expandable.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';
import '../../LocalDB/Models/CartModel.dart';
import '../../LocalDB/Models/FavoriteItem.dart';
import '../../LocalDB/Provider/CartProvider.dart';
import '../../LocalDB/Provider/FavouriteProvider.dart';
import '../../constants/constants.dart';
import '../../firebase/cart/CartFirebaseModel.dart';
import '../../firebase/cart/CartController.dart';
import '../../server/functions/functions.dart';
import '../cart/cart.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProductScreen extends StatefulWidget {
  var favourite;
  int id;
  int index;
  var Product;
  var Sub_Category_Key;
  bool cart_fav;
  List Images;
  List SubCategories;
  List sizes;
  var IDs, SIZES;
  final url;
  int page;
  bool ALL;
  ProductScreen({
    Key? key,
    required this.url,
    required this.SIZES,
    required this.ALL,
    required this.SubCategories,
    required this.page,
    required this.index,
    required this.Sub_Category_Key,
    required this.sizes,
    required this.favourite,
    required this.cart_fav,
    required this.Images,
    required this.Product,
    required this.IDs,
    required this.id,
  }) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  bool loadingPage = true;
  String user_id = "";
  setUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String UserID = prefs.getString('user_id') ?? "";
    user_id = UserID;
    if (widget.SIZES!.length == 1) {
      SelectedSizes = widget.SIZES[0].toString();
    } else {
      SelectedSizes = "اختر مقاسك";
    }
  }

  List<int> _extractIds(String idsString) {
    List<int> ids = [];
    RegExp idRegExp = RegExp(r'\d+');
    Iterable<Match> matches = idRegExp.allMatches(idsString);
    for (Match match in matches) {
      String id = match.group(0)!;
      ids.add(int.parse(id));
    }
    return ids;
  }

  var orderedItems = [];

  int _currentPage = 0;
  @override
  void initState() {
    super.initState();

    setUserID();
    loadInitialData();
  }

  void reorderOrderedItems() {
    // Create a set to store unique 'id' values from 'widget.Products'
    final Set<int> uniqueIds = {};

    // Filter 'widget.Products' to remove duplicates based on 'id'
    final List<dynamic> uniqueProducts = widget.Product.where((product) {
      final int id = product['id'];
      if (uniqueIds.contains(id)) {
        return false; // Skip duplicates
      } else {
        uniqueIds.add(id);
        return true;
      }
    }).toList();

    // Create a map to store 'uniqueProducts' using their 'id' as the key
    final Map<int, dynamic> productMap = {};

    // Fill the product map
    for (var product in uniqueProducts) {
      final int id = product['id'];
      productMap[id] = product;
    }

    // Create a new list by ordering 'orderedItems' based on the 'id' field
    final List<dynamic> reorderedItems = [];

    for (var item in orderedItems) {
      final int id = item['id'];
      if (productMap.containsKey(id)) {
        reorderedItems.add(productMap[id]);
      }
    }

    // Update 'orderedItems' with the reordered list
    setState(() {
      orderedItems = reorderedItems;
    });
  }

  void moveItemToFront(List<dynamic> orderedItems, int targetId) {
    int index = orderedItems.indexWhere((item) => item['id'] == targetId);
    if (index != -1) {
      // If the item with the target ID is found, remove it and add it to the front.
      var itemToMove = orderedItems.removeAt(index);
      orderedItems.insert(0, itemToMove);
    }
  }

  var initSubKey = "";
  var initMAINKey = "";

  Future<void> loadInitialData() async {
    setState(() {
      loadingPage = true;
    });
    var InitialData = await getSpeceficProduct(widget.id);
    setState(() {
      orderedItems.add(InitialData["item"]);
      removeDuplicatesById(orderedItems);
      initSubKey = InitialData["item"]["categories"][2][0];
      initMAINKey = InitialData["item"]["categories"][0][0];
    });
    var main_category_key_final = initMAINKey.replaceAll('&', '%26');
    final uri = Uri.parse(widget.url);
    final updatedQueryParameters =
        Map<String, String>.from(uri.queryParameters);
    int incrementPage = page;
    updatedQueryParameters['page'] = "1";
    updatedQueryParameters['sub_category'] = initSubKey.toString();
    var _products =
        await getProductByCategory(main_category_key_final, initSubKey, "", 1);
    var additionalItems = [];
    if (_products != null) {
      if (_products["items"].length != 0) {
        additionalItems = _products["items"];
        removeDuplicatesById(additionalItems);
      } else {}
    }
    List<String> idsList =
        additionalItems.map((item) => item['id'].toString()).toList();

    String commaSeparatedIds = idsList.join(', ');

    var ProductsApiData = await getSpeceficProduct(commaSeparatedIds);
    print("commaSeparatedIds");
    print(commaSeparatedIds);

    if (additionalItems != null) {
      setState(() {
        orderedItems.addAll(ProductsApiData["item"]);
      });
    }
    moveItemToFront(orderedItems, widget.id);

    setState(() {
      loadingPage = false;
    });
  }

  removeDuplicatesById(items) {
    Set<int> seen = Set<int>();
    var uniqueItems = [];

    for (var item in items) {
      if (!seen.contains(item['id'])) {
        uniqueItems.add(item);
        seen.add(item['id']);
      }
    }

    return uniqueItems;
  }

  int page = 1;
  Future loadAdditionalData() async {
    String sizesString = widget.SIZES.join(',');
    page += 1;
    final uri = Uri.parse(widget.url);
    if (uri.host == null) {
      // Handle the case where the URL does not contain a host
      print("Invalid URL: No host specified");
      return;
    }
    var additionalItems = [];
    var main_category_key_final = initMAINKey.replaceAll('&', '%26');
    var _products = await getProductByCategory(
        main_category_key_final, initSubKey, sizesString, page);
    if (_products != null) {
      if (_products["items"].length != 0) {
        additionalItems = _products["items"];
      } else {}
    }

    if (_products != null) {
      if (_products["items"].length != 0) {
        additionalItems = _products["items"];
      } else {
        var main_category_key_final = initMAINKey.replaceAll('&', '%26');
        var _products = await getProductByCategory(
            main_category_key_final, initSubKey, "", 1);
        if (_products != null) {
          if (_products["items"].length != 0) {
            additionalItems = _products["items"];
          } else {}
        }
      }
    }

    List<String> idsList =
        additionalItems.map((item) => item['id'].toString()).toList();

    String commaSeparatedIds = idsList.join(', ');

    var ProductsApiData = await getSpeceficProduct(commaSeparatedIds);

    if (additionalItems != null) {
      setState(() {
        orderedItems.addAll(ProductsApiData["item"]);
      });
    }
  }

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  void listClick(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);
  }

  bool isLoadingMoreItems = false;
  final favouriteProvider = FavouriteProvider();
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    List newArray = [];
    for (int i = 0; i < widget.Product.length; i++) {
      newArray.add(i);
    }
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: AddToCartAnimation(
          cartKey: cartKey,
          height: 50,
          width: 30,
          opacity: 0.99,
          dragAnimation: const DragToCartAnimationOptions(
            rotation: true,
          ),
          jumpAnimation:
              const JumpAnimationOptions(duration: Duration(microseconds: 200)),
          createAddToCartAnimation: (runAddToCartAnimation) {
            this.runAddToCartAnimation = runAddToCartAnimation;
          },
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: AppBar(
                backgroundColor: MAIN_COLOR,
                centerTitle: true,
                title: Text(
                  "فوري",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                actions: [
                  Container(
                    key: cartKey,
                    child: Stack(
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
                    ),
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
            body: loadingPage
                ? widget.cart_fav
                    ? AnimationLimiter(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 2.5,
                            autoPlay: false,
                            enlargeCenterPage: true,
                            viewportFraction: 1,
                            height: MediaQuery.of(context).size.height,
                            onPageChanged: (index, reason) async {
                              if (index == orderedItems.length - 1 &&
                                  reason == CarouselPageChangedReason.manual) {
                                await loadAdditionalData();
                              }
                            },
                          ),
                          items: newArray.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return AnimationConfiguration.staggeredList(
                                  position: i,
                                  duration: const Duration(milliseconds: 700),
                                  child: SlideAnimation(
                                    verticalOffset: 100.0,
                                    child: FadeInAnimation(
                                      curve: Curves.easeIn,
                                      child: ProductMethod(
                                          inCart: cartProvider.isProductCart(
                                              widget.Product[i]["id"]),
                                          name: widget.Product[i]["title"]
                                              as String,
                                          id: widget.Product[i]["id"],
                                          images: [widget.Product[i]["image"]],
                                          description: [],
                                          new_price: widget.Product[i]["price"],
                                          old_price: double.parse(widget
                                                  .Product[i]["price"]
                                                  .toString()) *
                                              1.5,
                                          image: widget.Product[i]["image"]
                                              as String,
                                          sizesApi: [],
                                          TypeApi: false,
                                          placeInWarehouse: {}),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      )
                    : AnimationLimiter(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 2.5,
                            autoPlay: false,
                            enlargeCenterPage: true,
                            viewportFraction: 1,
                            height: MediaQuery.of(context).size.height,
                            onPageChanged: (index, reason) async {
                              if (index == orderedItems.length - 5 &&
                                  reason == CarouselPageChangedReason.manual) {
                                await loadAdditionalData();
                              }
                            },
                          ),
                          items: newArray.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return AnimationConfiguration.staggeredList(
                                  position: i,
                                  duration: const Duration(milliseconds: 700),
                                  child: SlideAnimation(
                                    verticalOffset: 100.0,
                                    child: FadeInAnimation(
                                      curve: Curves.easeIn,
                                      child: ProductMethod(
                                          inCart: cartProvider.isProductCart(
                                              widget.Product[i]["id"]),
                                          name: widget.Product[i]["title"]
                                              as String,
                                          id: widget.Product[i]["id"],
                                          images: widget.Product[i]
                                              ["vendor_images_links"],
                                          description: [],
                                          new_price: widget.Product[i]["price"],
                                          old_price: double.parse(widget
                                                  .Product[i]["price"]
                                                  .toString()) *
                                              1.5,
                                          image: widget.Product[i]
                                                  ["vendor_images_links"][0]
                                              as String,
                                          sizesApi: [],
                                          TypeApi: false,
                                          placeInWarehouse: {}),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      )
                : AnimationLimiter(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 2.5,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        reverse: false,
                        scrollDirection: Axis.horizontal,
                        height: MediaQuery.of(context).size.height,
                        initialPage: _currentPage,
                        onPageChanged: (index, reason) async {
                          if (index == orderedItems.length - 8 &&
                              reason == CarouselPageChangedReason.manual) {
                            await loadAdditionalData();
                          }
                        },
                      ),
                      items: orderedItems.map((item) {
                        List<String> images =
                            (item["vendor_images_links"] as List)
                                .cast<String>();
                        int itemIndex = orderedItems.indexOf(item);

                        return Builder(
                          builder: (BuildContext context) {
                            // if(Selected){
                            //   SelectedSizes = "إختر المقاس";
                            // }
                            List sizesAPI = widget.sizes;
                            sizesAPI = [];
                            Map placeInWarehouse = {};
                            bool typeApi = false;
                            for (int i = 0; i < item["variants"].length; i++) {
                              if (!sizesAPI
                                  .contains(item["variants"][i]["size"])) {
                                sizesAPI.add(item["variants"][i]["size"]);
                                placeInWarehouse[item["variants"][i]["size"]] =
                                    item["variants"][i]["place_in_warehouse"];
                                typeApi = true;
                              }
                            }

                            return AnimationConfiguration.staggeredList(
                              position: itemIndex,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                verticalOffset: 100.0,
                                child: FadeInAnimation(
                                  curve: Curves.easeIn,
                                  child: ProductMethod(
                                    isLikedProduct: favouriteProvider
                                        .isProductFavorite(item["id"]),
                                    inCart:
                                        cartProvider.isProductCart(item["id"]),
                                    name: item["title"] ?? "-",
                                    sizesApi: sizesAPI,
                                    // SelectedSizes: "اختر الحجم",
                                    id: item["id"],
                                    images: images,
                                    description: item["description"],
                                    variants: item["variants"],
                                    SKU: item["sku"] ?? "-",
                                    vendor_SKU: item["vendor_sku"] ?? "-",
                                    nickname: item["nickname"] ?? "-",
                                    new_price: item["variants"][0]["price"],
                                    old_price: double.parse(item["variants"][0]
                                                ["price"]
                                            .toString()) *
                                        1.5,
                                    image: item["vendor_images_links"][0]
                                        as String,
                                    TypeApi: typeApi,
                                    placeInWarehouse: placeInWarehouse,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  bool loadingcart = false;
  bool loadingfav = false;
  bool loading = false;
  int _currentIndex = 0;
  String SelectedSizes = "إختر المقاس";
  bool Selected = true;
  Widget ProductMethod(
      {String image = "",
      String name = "",
      String SKU = "",
      String vendor_SKU = "",
      String nickname = "",
      var variants,
      required Map placeInWarehouse,
      required List sizesApi,
      required bool TypeApi,
      List? images,
      int id = 0,
      var description,
      bool inCart = false,
      bool isLikedProduct = false,
      var old_price,
      var new_price}) {
    // String SelectedSizes = "";
    List Sizes = sizesApi.length == 0 ? LocalStorage().sizeUser : sizesApi;

    final cartProvider = Provider.of<CartProvider>(context);
    // final cartFirebaseProvider = Provider.of<CartProviderFirebase>(context);
    final favoriteProvider =
        Provider.of<FavouriteProvider>(context, listen: false);
    Future<bool> onLikeButtonTapped(bool liked) async {
      bool isFavorite = favoriteProvider.isProductFavorite(widget.id);

      if (isFavorite) {
        await favoriteProvider.removeFromFavorite(widget.id);
        Fluttertoast.showToast(
          msg: "تم حذف هذا المنتج من المفضلة بنجاح",
        );
        return false;
      }
      try {
        Vibration.vibrate(duration: 300);
        final newItem = FavoriteItem(
          productId: id,
          name: name,
          image: image,
          price: double.parse(new_price.toString()),
        );

        await favoriteProvider.addToFavorite(newItem);
        Fluttertoast.showToast(
          msg: "تم اضافة هذا المنتج الى المفضلة بنجاح",
        );
        isLikedProduct = true;
        return true;
      } catch (e) {
        return !isLikedProduct;
      }
    }

    final GlobalKey widgetKey = GlobalKey();

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      key: widgetKey,
                      height: MediaQuery.of(context).size.height * 0.60,
                      width: double.infinity,
                      child: clicked
                          ? Container()
                          : StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    images!.length == 1
                                        ? Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.60,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: FancyShimmerImage(
                                              imageUrl: images[0],
                                            ),
                                          )
                                        : CarouselSlider(
                                            options: CarouselOptions(
                                              onPageChanged: (index, reason) {
                                                _currentIndex = index;
                                                setState(() {});
                                              },
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.60,
                                              scrollDirection: Axis.vertical,
                                              viewportFraction: 1,
                                              autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                              aspectRatio: 2.0,
                                              autoPlay: true,
                                            ),
                                            items: images.map((i) {
                                              return Builder(
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.60,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: InteractiveViewer(
                                                      panEnabled:
                                                          false, // Set it to false
                                                      boundaryMargin:
                                                          EdgeInsets.all(100),
                                                      minScale: 0.5,
                                                      maxScale: 2,
                                                      child: FancyShimmerImage(
                                                        imageUrl: i,
                                                        errorWidget:
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }).toList(),
                                          ),
                                    Visibility(
                                      visible:
                                          images.length == 1 ? false : true,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            right: 10.0, top: 150),
                                        width: 20.0,
                                        child: DotsIndicator(
                                          dotsCount: images.length == 0
                                              ? 1
                                              : images.length,
                                          position:
                                              _currentIndex >= images.length
                                                  ? images.length - 1
                                                  : _currentIndex,
                                          axis: Axis.vertical,
                                          decorator: DotsDecorator(
                                            size: const Size.square(9.0),
                                            activeSize: const Size(38.0, 15.0),
                                            activeShape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Tooltip(
                                        onTriggered: () {
                                          Clipboard.setData(
                                              ClipboardData(text: SKU));
                                          Fluttertoast.showToast(
                                              msg: "copied successfully!");
                                        },
                                        triggerMode: TooltipTriggerMode.tap,
                                        message: SKU,
                                        child: Icon(Icons.info,
                                            size: 30, color: MAIN_COLOR),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Share.share(
                                      "http://54.91.80.40/product-details-one/${id}?offset=1");
                                },
                                icon: Icon(Icons.share)),
                            Consumer<FavouriteProvider>(
                              builder: (context, favoriteProvider, _) {
                                return InkWell(
                                    onTap: () {
                                      Vibration.vibrate(duration: 300);
                                      if (LocalStorage()
                                          .isFavorite(id.toString())) {
                                        LocalStorage()
                                            .deleteFavorite(id.toString());
                                        favoriteProvider.notifyListeners();
                                      } else {
                                        LocalStorage().setFavorite(FavoriteItem(
                                          productId: id,
                                          id: id,
                                          name: name,
                                          image: image,
                                          price: double.parse(
                                              new_price.toString()),
                                        ));
                                        favoriteProvider.notifyListeners();
                                      }
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Icon(
                                          Icons.favorite,
                                          size: 30,
                                          color: LocalStorage()
                                                  .isFavorite(id.toString())
                                              ? Colors.red
                                              : Colors.black26,
                                        ),
                                      ),
                                    ));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  "₪${old_price.toString().length > 5 ? old_price.toString().substring(0, 5) : old_price.toString()}",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  width: 50,
                                  color: Colors.black,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 0.0, 190, 0.0),
                                  child: Tooltip(
                                    triggerMode: TooltipTriggerMode.tap,
                                    message: "توصيل فوري",
                                    child: FaIcon(
                                      FontAwesomeIcons.truck,
                                      color: Color(0xD9000000),
                                      size: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 0.0, 10, 0.0),
                                  child: Tooltip(
                                    triggerMode: TooltipTriggerMode.tap,
                                    message: "الدفع عند الاستلام",
                                    child: FaIcon(
                                      FontAwesomeIcons.moneyBillWaveAlt,
                                      color: Color(0xD9000000),
                                      size: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                  child: Tooltip(
                                    triggerMode: TooltipTriggerMode.tap,
                                    message: "سياسه الخصوصيه",
                                    child: FaIcon(
                                      Icons.handshake,
                                      color: Color(0xD9000000),
                                      size: 19,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Row(
                          children: [
                            Text(
                              "₪${new_price}",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "(15%)",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8, top: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: description is List
                            ? description.isNotEmpty
                            : description != null && description != '',
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      1, 0, 1, 0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: ExpandableNotifier(
                                          initialExpanded: false,
                                          child: description is List
                                              ? ExpandablePanel(
                                                  header: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 0,
                                                                    12, 0),
                                                        child: Icon(
                                                          Icons
                                                              .sticky_note_2_outlined,
                                                          color: Colors.black,
                                                          size: 24,
                                                        ),
                                                      ),
                                                      Text(
                                                        "تفاصيل المنتج",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  collapsed: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  expanded:
                                                      SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    -1, 0),
                                                            child: ListView
                                                                .builder(
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemCount:
                                                                  description
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        description[index].toString().startsWith("{") &&
                                                                                description[index].toString().endsWith("}")
                                                                            ? description[index].toString().substring(1, description[index].toString().length - 1)
                                                                            : description[index].toString(),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  theme: ExpandableThemeData(
                                                    tapHeaderToExpand: true,
                                                    tapBodyToExpand: false,
                                                    tapBodyToCollapse: false,
                                                    headerAlignment:
                                                        ExpandablePanelHeaderAlignment
                                                            .center,
                                                    hasIcon: true,
                                                    expandIcon: Icons
                                                        .keyboard_arrow_down_sharp,
                                                    collapseIcon: Icons
                                                        .keyboard_arrow_down_rounded,
                                                    iconSize: 38,
                                                    iconColor: Colors.black,
                                                  ),
                                                )
                                              : description is String
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        description.isNotEmpty
                                                            ? description
                                                            : 'No description available',
                                                        // You might format the text differently or provide a default message
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    )
                                                  : Container()),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ], color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                transform: _hasError
                    ? Matrix4.translationValues(5, 0, 0)
                    : Matrix4.identity(),
                child: Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: _hasError ? Colors.red : Colors.transparent,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton(
                    hint: Text(SelectedSizes),
                    isExpanded: true,
                    icon: loadingPage
                        ? SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              color: MAIN_COLOR,
                            ),
                          )
                        : Icon(Icons.arrow_drop_down),
                    iconSize: 30.0,
                    underline: Container(),
                    style: TextStyle(
                        color: MAIN_COLOR, fontWeight: FontWeight.bold),
                    items: Sizes.map(
                      (val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(
                            val,
                            style: TextStyle(color: MAIN_COLOR),
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (val) {
                      setState(() {
                        SelectedSizes = val.toString();
                      });
                    },
                  ),
                ),
              ),
              loading
                  ? Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.black)),
                      child: Center(
                          child: Container(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )),
                    )
                  : ButtonWidget(
                      name: inCart ? "ازاله من السله" : "أضف الى السله",
                      height: 50,
                      width: 150,
                      BorderColor: Colors.black,
                      OnClickFunction: () async {
                        if (inCart) {
                          final newItem = CartItem(
                              sku: SKU,
                              vendor_sku: vendor_SKU,
                              nickname: nickname,
                              productId: id,
                              id: id,
                              name: name,
                              image: image.toString(),
                              price: double.parse(new_price.toString()),
                              quantity: 1,
                              user_id: 0,
                              type: SelectedSizes.toString() == ""
                                  ? LocalStorage().sizeUser[0]
                                  : SelectedSizes,
                              placeInWarehouse:
                                  placeInWarehouse[SelectedSizes] ?? "0000");

                          cartProvider.removeFromCart(id);
                          setState(() {});
                        } else {
                          if (SelectedSizes != "اختر مقاسك") {
                            setState(() {
                              loading = true;
                              clicked = true;
                            });
                            listClick(widgetKey);
                            Vibration.vibrate(duration: 300);
                            final newItem = CartItem(
                                sku: SKU,
                                vendor_sku: vendor_SKU,
                                nickname: nickname,
                                productId: id,
                                id: id,
                                name: name,
                                image: image.toString(),
                                price: double.parse(new_price.toString()),
                                quantity: 1,
                                user_id: 0,
                                type: SelectedSizes.toString() == ""
                                    ? LocalStorage().sizeUser[0]
                                    : SelectedSizes,
                                placeInWarehouse:
                                    placeInWarehouse[SelectedSizes] ?? "0000");
                            cartProvider.addToCart(newItem);
                            const snackBar = SnackBar(
                              content: Text('تم اضافه المنتج الى السله بنجاح!'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Timer(Duration(milliseconds: 500), () {
                              Fluttertoast.cancel();
                            });
                            Timer(Duration(seconds: 1), () async {
                              Navigator.pop(context);
                            });
                            final CartService cartFirebaseProvider =
                                CartService();
                            String idCart = Uuid().v4();
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? USER_ID =
                                await prefs.getString('user_id') ?? "-";
                            String? TOKEN =
                                await prefs.getString('device_token') ?? "-";

                            CartFirebaseModel cartFirebaseItem =
                                CartFirebaseModel(
                              id: idCart,
                              user_id: USER_ID.toString(),
                              product_id: id.toString(),
                              user_token: TOKEN,
                            );
                            cartFirebaseProvider.addToCart(cartFirebaseItem);
                            final selectedSizeItem = variants.firstWhere(
                              (variant) => variant['size'] == SelectedSizes,
                              orElse: () => null,
                            );
                            List<String> userIds = await cartFirebaseProvider
                                .getUserIdsByProductId(id.toString());
                            userIds.removeWhere((token) => token == TOKEN);

                            if (int.parse(
                                    selectedSizeItem["quantity"].toString()) <
                                2) {
                              sendNotification(
                                  context: context, USER_TOKENS: userIds);
                            }
                          } else {
                            setState(() {
                              Vibration.vibrate(duration: 100);
                              _hasError = true;
                              Future.delayed(Duration(milliseconds: 1000), () {
                                setState(() {
                                  _hasError = false;
                                });
                              });
                            });
                          }
                        }
                      },
                      BorderRaduis: 10,
                      ButtonColor: Colors.black,
                      NameColor: Colors.white)
            ],
          ),
        ),
      ],
    );
  }

  bool _hasError = false;
  bool clicked = false;

  Widget desceiptionMethod({String key = "", String value = ""}) {
    return Container(
      height: 40,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(right: 15, left: 15),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xffD6D3D3))),
                child: Center(
                  child: Text(
                    key,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 245, 244, 244),
                    border: Border.all(color: Color(0xffD6D3D3))),
                child: Center(
                  child: Text(
                    value,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CartIcon(int itemCount) {
    return Container(
      height: 17,
      width: 17,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            itemCount.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
