import 'dart:async';
import 'dart:convert';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:expandable/expandable.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';
import '../../LocalDB/Models/CartModel.dart';
import '../../LocalDB/Models/FavoriteItem.dart';
import '../../LocalDB/Provider/CartProvider.dart';
import '../../LocalDB/Provider/FavouriteProvider.dart';
import '../../constants/constants.dart';
import '../../firebase/cart/cart.dart';
import '../../firebase/cart/CartController.dart';
import '../../firebase/favourites/FavouriteControler.dart';
import '../../firebase/favourites/favourite.dart';
import '../../server/domain/domain.dart';
import '../../server/functions/functions.dart';
import '../../services/animation_info/animation_info.dart';
import '../../services/json/json-services.dart';
import '../authentication/login_screen/login_screen.dart';
import '../cart/cart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductScreen extends StatefulWidget {
  var favourite;
  int id;
  int index;
  var Product;
  List Images;
  var IDs;
  ProductScreen({
    Key? key,
    required this.index,
    required this.favourite,
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
  String user_id = "";
  setUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String UserID = prefs.getString('user_id') ?? "";
    user_id = UserID;
  }

  @override
  void initState() {
    super.initState();
    setUserID();
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

  //  Future<void> fetchMoreProducts() async {
  //   // Your API call logic to fetch more products
  //   final apiUrl = "your_api_url_here?page=$currentPage";
  //   final response = await http.get(Uri.parse(apiUrl));

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final newProducts = data["item"] as List<dynamic>;

  //     setState(() {
  //       loadedProducts.addAll(newProducts);
  //       currentPage++; // Increment the page for the next API call
  //       isLoading = false;
  //     });
  //   } else {
  //     // Handle API error
  //     print("Error fetching more products");
  //     isLoading = false;
  //   }
  // }
  int _currentPage = 0;
  fetchAdditionalData() async {
    final response = await http.get(Uri.parse(
        'http://34.227.78.214/api/getItemData?id=10365,10666,10367,10368,10369&api_key=$key_bath'));
    var res = json.decode(utf8.decode(response.bodyBytes));
    var additionalItems = res["item"];
    return additionalItems;
  }

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  void listClick(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);
  }

  final animationsMap = {
    'badgeOnActionTriggerAnimation': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        ShakeEffect(
          curve: Curves.easeInOut,
          delay: 700.ms,
          duration: 1000.ms,
          hz: 6,
          offset: Offset(6, 0),
          rotation: 0.105,
        ),
      ],
    ),
    'imageOnActionTriggerAnimation': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        // ScaleEffect(
        //   curve: Curves.easeInOut,
        //   delay: 0.ms,
        //   duration: 900.ms,
        //   begin: 1,
        //   end: 0.05,
        // ),
        RotateEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 900.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 200.ms,
          duration: 900.ms,
          begin: Offset(0, 0),
          end: Offset(-200, -350),
        ),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 400.ms,
          duration: 400.ms,
          begin: 1,
          end: 0,
        ),
      ],
    ),
    'columnOnActionTriggerAnimation': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        // ScaleEffect(
        //   curve: Curves.easeInOut,
        //   delay: 0.ms,
        //   duration: 600.ms,
        //   begin: 1,
        //   end: 0.05,
        // ),
        RotateEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 200.ms,
          duration: 600.ms,
          begin: Offset(0, 0),
          end: Offset(-125, -375),
        ),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 400.ms,
          duration: 400.ms,
          begin: 1,
          end: 0,
        ),
      ],
    ),
    'rowOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 40),
          end: Offset(0, 0),
        ),
      ],
    ),
    'rowOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 80),
          end: Offset(0, 0),
        ),
      ],
    ),
    'dropDownOnActionTriggerAnimation': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        ShakeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 1000.ms,
          hz: 6,
          offset: Offset(0, 0),
          rotation: 0.035,
        ),
      ],
    ),
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 140),
          end: Offset(0, 0),
        ),
      ],
    ),
  };
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
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
                  // AddToCartIcon(

                  //   icon: const Icon(Icons.shopping_cart),
                  //   badgeOptions: const BadgeOptions(
                  //     active: true,
                  //     backgroundColor: Colors.red,
                  //   ),
                  // ),
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
            body: FutureBuilder(
              future: getSpeceficProduct(widget.IDs),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  if (widget.Product.length == 0) {
                    return Container(
                      width: double.infinity,
                      height: 400,
                      child: Center(
                        child: SpinKitPulse(
                          color: MAIN_COLOR,
                          size: 60,
                        ),
                      ),
                    );
                  } else {
                    List newArray = [];
                    for (int i = 0; i < widget.Product.length; i++) {
                      newArray.add(i);
                    }
                    return AnimationLimiter(
                      child: CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 2.5,
                          autoPlay: false,
                          enlargeCenterPage: true,
                          viewportFraction: 1,
                          height: MediaQuery.of(context).size.height,
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
                                            as String),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }
                } else {
                  if (snapshot.data != null) {
                    List<dynamic> ProductsAPI = snapshot.data["item"];

                    List<int> widgetIds = _extractIds(widget.IDs);
                    var orderedItems = [];

                    for (int id in widgetIds) {
                      var item = ProductsAPI.firstWhere(
                        (product) => product["id"] == id,
                        orElse: () => null,
                      );
                      if (item != null) {
                        orderedItems.add(item);
                      }
                    }

                    return AnimationLimiter(
                      child: CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 2.5,
                          autoPlay: false,
                          enlargeCenterPage: true,
                          viewportFraction: 1,
                          height: MediaQuery.of(context).size.height,
                          initialPage: _currentPage,
                          onPageChanged: (index, reason) async {
                            setState(() {
                              _currentPage = index;
                            });

                            if (orderedItems.length - 3 < _currentPage) {
                              var additionalItems = await fetchAdditionalData();

                              orderedItems.add(additionalItems);
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
                              return AnimationConfiguration.staggeredList(
                                position: itemIndex,
                                duration: const Duration(milliseconds: 500),
                                child: SlideAnimation(
                                  verticalOffset: 100.0,
                                  child: FadeInAnimation(
                                    curve: Curves.easeIn,
                                    child: ProductMethod(
                                      name: item["title"] ?? "-",
                                      id: item["id"],
                                      images: images,
                                      description: item["description"],
                                      new_price: item["variants"][0]["price"],
                                      old_price: double.parse(item["variants"]
                                                  [0]["price"]
                                              .toString()) *
                                          1.5,
                                      image: item["vendor_images_links"][0]
                                          as String,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  bool isLikedButton = false;
  Future<bool> onLikeButtonTapped(FavouriteProvider favoriteProvider,
      String title, String image, String Price, int ID) async {
    bool isFavorite = favoriteProvider.isProductFavorite(widget.id);
    if (isFavorite) {
      await favoriteProvider.removeFromFavorite(widget.id);
      Fluttertoast.showToast(
        msg: "تم حذف هذا المنتج من المفضلة بنجاح",
      );
      return false;
    }
    try {
      // await addToWish(widget.id);
      final newItem = FavoriteItem(
        productId: ID,
        name: title,
        image: image,
        price: double.parse(Price.toString()),
      );

      await favoriteProvider.addToFavorite(newItem);
      Fluttertoast.showToast(
        msg: "تم اضافة هذا المنتج الى المفضلة بنجاح",
      );
      isLikedButton = true;
      return true;
    } catch (e) {
      return !isLikedButton;
    }
  }

  bool loadingcart = false;
  bool loadingfav = false;
  int _currentIndex = 0;
  Widget ProductMethod(
      {String image = "",
      String name = "",
      List? images,
      int id = 0,
      var description,
      var old_price,
      var new_price}) {
    final cartProvider = Provider.of<CartProvider>(context);
    final favoriteProvider =
        Provider.of<FavouriteProvider>(context, listen: false);
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
                Container(
                  key: widgetKey,
                  height: 450.0,
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
                                        height: 450,
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                          height: 450.0,
                                          scrollDirection: Axis.vertical,
                                          viewportFraction: 1,
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          aspectRatio: 2.0,
                                          autoPlay: true,
                                        ),
                                        items: images.map((i) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: 450,
                                                width: MediaQuery.of(context)
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
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }).toList(),
                                      ),
                                Visibility(
                                  visible: images.length == 1 ? false : true,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(right: 10.0, top: 150),
                                    width: 20.0,
                                    child: DotsIndicator(
                                      dotsCount: images.length == 0
                                          ? 1
                                          : images.length,
                                      position: _currentIndex >= images.length
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
                                  child: Icon(Icons.info,
                                      size: 30, color: MAIN_COLOR),
                                ),
                              ],
                            );
                          },
                        ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          LikeButton(
                            circleColor:
                                CircleColor(start: Colors.red, end: Colors.red),
                            size: 35,
                            onTap: (isLiked) async {
                              bool updatedLikedState = await onLikeButtonTapped(
                                favoriteProvider,
                                name,
                                image,
                                new_price
                                    .toString(), // Make sure new_price is numeric
                                id,
                              );
                              return updatedLikedState; // Return the updated state based on the operation's success
                            },
                            isLiked: isLikedButton,
                          )
                        ],
                      ),
                    ),
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
                                padding: EdgeInsets.fromLTRB(0.0, 0.0, 10, 0.0),
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
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(1, 0, 1, 0),
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
                                      child: ExpandablePanel(
                                        header: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 12, 0),
                                              child: Icon(
                                                Icons.sticky_note_2_outlined,
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
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                          ),
                                        ),
                                        expanded: description is List
                                            ? SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1, 0),
                                                        child: ListView.builder(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount: description
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final item =
                                                                description[
                                                                    index];
                                                            final key =
                                                                item.keys.first;
                                                            final value = item
                                                                .values.first;
                                                            return Row(
                                                              children: [
                                                                Text("$key: "),
                                                                Expanded(
                                                                    child: Text(
                                                                        "$value")),
                                                              ],
                                                            );
                                                          },
                                                        )),
                                                  ],
                                                ),
                                              )
                                            : description is String
                                                ? Text(
                                                    description) // Show the simple string description
                                                : Container(),
                                        theme: ExpandableThemeData(
                                          tapHeaderToExpand: true,
                                          tapBodyToExpand: false,
                                          tapBodyToCollapse: false,
                                          headerAlignment:
                                              ExpandablePanelHeaderAlignment
                                                  .center,
                                          hasIcon: true,
                                          expandIcon:
                                              Icons.keyboard_arrow_down_sharp,
                                          collapseIcon:
                                              Icons.keyboard_arrow_down_rounded,
                                          iconSize: 38,
                                          iconColor: Colors.black,
                                        ),
                                      ),
                                    ),
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
              Text(
                "ONE-SIZE",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ButtonWidget(
                  name: "أضف الى السله",
                  height: 50,
                  width: 150,
                  BorderColor: Colors.black,
                  OnClickFunction: () async {
                    setState(() {
                      clicked = true;
                    });
                    listClick(widgetKey);
                    Vibration.vibrate(duration: 300);

                    final newItem = CartItem(
                      productId: id,
                      name: name,
                      image: image.toString(),
                      price: double.parse(new_price.toString()),
                      quantity: 1,
                      user_id: 0,
                    );
                    cartProvider.addToCart(newItem);

                    const snackBar = SnackBar(
                      content: Text('تم اضافه المنتج الى السله بنجاح!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Timer(Duration(milliseconds: 500), () {
                      Fluttertoast.cancel();
                      // Dismiss the toast after the specified duration
                    });
                    Timer(Duration(seconds: 1), () async {
                      Navigator.pop(context);
                    });
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

  bool clicked = false;

  var desc = [
    {"لون": "عنابي اللون"},
    {"تصاميم": "حفلة"},
    {"أصناف التصميم": "الصاف"},
    {"تفاصيل": "طوق كشكش"},
    {"تفاصيل": "غير متساوي او غير متماثل"},
    {"تفاصيل": "حزام"},
    {"خط العنق": "ياقة القاع"},
    {"تفاصيل": "سستة"},
    {"نوع": "مناسب"},
    {"طول الأكمام": "نصف الأكمام"},
    {"أنواع الأكمام": "كم ضيق"},
    {"محيط الخصر": "ارتفاع الخصر"},
    {"شكل الكُفة": "غير متساوي او غير متماثل"},
    {"الطول": "طويل"},
    {"نوع الشكل": "النمط العادي"},
    {"قماش": "غير متمدد"},
    {"المواد": "الستان"},
    {"تكوين": "95% بوليستر"},
    {"تكوين": "5% إيلاستين"},
    {"ارشادات العناية": "يغسل بالغسالة، لا يستخدم التنظيف الجاف"},
    {"حزام": "نعم"},
    {"شفاف": "لا"}
  ];

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
