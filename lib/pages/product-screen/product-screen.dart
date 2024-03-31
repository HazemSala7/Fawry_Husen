import 'dart:async';
import 'dart:convert';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:fawri_app_refactor/pages/product-screen/product-screen-item/product-screen-item.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
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
import '../../components/product_widget/product-widget.dart';
import '../../constants/constants.dart';
import '../../firebase/cart/CartFirebaseModel.dart';
import '../../firebase/cart/CartController.dart';
import '../../server/domain/domain.dart';
import '../../server/functions/functions.dart';
import '../cart/cart.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProductScreen extends StatefulWidget {
  var favourite;
  int id;
  int index;
  var Sub_Category_Key;
  bool cart_fav;
  List Images, Product;
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
      removeDuplicatesById(orderedItems);
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
      initSubKey = InitialData["item"]["categories"].length > 2
          ? InitialData["item"]["categories"][2][0]
          : InitialData["item"]["categories"][1][0] ?? "";
      initMAINKey = InitialData["item"]["categories"][0][0] ?? "";
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

    if (additionalItems != null) {
      setState(() {
        // orderedItems = [];
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
                            // reverse: true,
                            initialPage: 0,
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
                                      child: ProductItem(
                                          Sizes: [],
                                          runAddToCartAnimation:
                                              runAddToCartAnimation,
                                          loadingPage: true,
                                          SKU: "",
                                          isLikedProduct: false,
                                          SelectedSizes: "اختر مقاسك",
                                          nickname: "",
                                          variants: [],
                                          vendor_SKU: "",
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
                            initialPage: 0,
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
                                      child: ProductItem(
                                          Sizes: [],
                                          runAddToCartAnimation:
                                              runAddToCartAnimation,
                                          loadingPage: true,
                                          SKU: "",
                                          isLikedProduct: false,
                                          SelectedSizes: "اختر مقاسك",
                                          nickname: "",
                                          variants: [],
                                          vendor_SKU: "",
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
                        // enableInfiniteScroll: false,
                        padEnds: false,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        reverse: false,
                        scrollDirection: Axis.horizontal,
                        height: MediaQuery.of(context).size.height,
                        initialPage: 0,
                        onPageChanged: (index, reason) async {
                          if (index == orderedItems.length - 8 &&
                              reason == CarouselPageChangedReason.manual) {
                            await loadAdditionalData();
                          }
                        },
                      ),
                      items: orderedItems.map((item) {
                        return Builder(
                          builder: (BuildContext context) {
                            // print("1");
                            List<String> images =
                                (item["vendor_images_links"] as List)
                                    .cast<String>();
                            // print("2");
                            int itemIndex = orderedItems.indexOf(item);
                            // print("3");
                            List sizesAPI = widget.sizes;
                            // print("4");
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
                            print("sizesAPI");
                            print(sizesAPI);

                            return AnimationConfiguration.staggeredList(
                              position: itemIndex,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                verticalOffset: 100.0,
                                child: FadeInAnimation(
                                  curve: Curves.easeIn,
                                  child: ProductItem(
                                    Sizes: sizesAPI.length == 0
                                        ? LocalStorage().sizeUser
                                        : sizesAPI,
                                    runAddToCartAnimation:
                                        runAddToCartAnimation,
                                    loadingPage: false,
                                    SelectedSizes: sizesAPI.length == 1
                                        ? sizesAPI[0]
                                        : "اختر مقاسك",
                                    isLikedProduct: favouriteProvider
                                        .isProductFavorite(item["id"]),
                                    inCart:
                                        cartProvider.isProductCart(item["id"]),
                                    name: item["title"] ?? "-",
                                    sizesApi: sizesAPI,
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
