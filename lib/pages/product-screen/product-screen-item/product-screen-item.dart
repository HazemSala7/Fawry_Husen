import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:expandable/expandable.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';

import '../../../LocalDB/Database/local_storage.dart';
import '../../../LocalDB/Models/CartModel.dart';
import '../../../LocalDB/Models/FavoriteItem.dart';
import '../../../LocalDB/Provider/CartProvider.dart';
import '../../../LocalDB/Provider/FavouriteProvider.dart';
import '../../../components/button_widget/button_widget.dart';
import '../../../constants/constants.dart';
import '../../../firebase/cart/CartController.dart';
import '../../../firebase/cart/CartFirebaseModel.dart';
import '../../../server/domain/domain.dart';
import '../../../server/functions/functions.dart';

class ProductItem extends StatefulWidget {
  String image, name, nickname, SKU, vendor_SKU, SelectedSizes;
  var variants, old_price, new_price, description, runAddToCartAnimation;
  Map placeInWarehouse;
  List sizesApi, images, Sizes;
  int id = 0;
  bool featureProduct = false;
  bool inCart, isLikedProduct, loadingPage, TypeApi;
  ProductItem({
    super.key,
    required this.name,
    required this.Sizes,
    required this.loadingPage,
    required this.featureProduct,
    required this.runAddToCartAnimation,
    required this.SelectedSizes,
    required this.image,
    required this.images,
    required this.vendor_SKU,
    required this.nickname,
    required this.variants,
    required this.description,
    required this.old_price,
    required this.new_price,
    required this.inCart,
    required this.isLikedProduct,
    required this.placeInWarehouse,
    required this.sizesApi,
    required this.id,
    required this.TypeApi,
    required this.SKU,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  final FlareControls flareControls = FlareControls();
  int _currentIndex = 0;
  bool clicked = false;
  bool loadingcart = false;
  bool loadingfav = false;
  bool loading = false;
  bool showLoading = false;
  bool Selected = true;
  bool _hasError = false;

  listClick(GlobalKey widgetKey) async {
    await widget.runAddToCartAnimation(widgetKey);
  }

  Widget build(BuildContext context) {
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
          productId: widget.id,
          name: widget.name,
          image: widget.image,
          price: double.parse(widget.new_price.toString()),
        );

        await favoriteProvider.addToFavorite(newItem);
        Fluttertoast.showToast(
          msg: "تم اضافة هذا المنتج الى المفضلة بنجاح",
        );
        widget.isLikedProduct = true;
        return true;
      } catch (e) {
        return !widget.isLikedProduct;
      }
    }

    final GlobalKey widgetKey = GlobalKey();
    double calculateDiscountSimple(int id,
        {double minDiscount = 10.0, double maxDiscount = 35.0}) {
      // Extract the last two digits of the ID
      int lastTwoDigits = id % 100;

      // Scale the sum of the last two digits to fit within the discount range
      double discountRange = maxDiscount - minDiscount;
      double discount =
          ((lastTwoDigits % discountRange) + minDiscount) % (maxDiscount + 1);

      // Dart doesn't have a direct equivalent to Python's round function for rounding to 2 decimal places,
      // so we do the multiplication and division trick to achieve that.
      discount = (discount * 100).round() / 100.0;

      return discount;
    }

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
                  children: [
                    InkWell(
                      onDoubleTap: () {
                        flareControls.play("like");
                        Vibration.vibrate(duration: 300);
                        if (LocalStorage().isFavorite(widget.id.toString())) {
                        } else {
                          LocalStorage().setFavorite(FavoriteItem(
                            productId: widget.id,
                            id: widget.id,
                            name: widget.name,
                            image: widget.image,
                            price: double.parse(widget.new_price.toString()),
                          ));
                          favoriteProvider.notifyListeners();
                        }
                      },
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            key: widgetKey,
                            height: MediaQuery.of(context).size.height * 0.60,
                            width: double.infinity,
                            child: clicked
                                ? Container()
                                : StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          widget.images!.length == 1
                                              ? Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.60,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: FancyShimmerImage(
                                                    imageUrl: widget.images![0],
                                                  ),
                                                )
                                              : CarouselSlider(
                                                  options: CarouselOptions(
                                                    onPageChanged:
                                                        (index, reason) {
                                                      _currentIndex = index;
                                                      setState(() {});
                                                    },
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.60,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    viewportFraction: 1,
                                                    autoPlayCurve:
                                                        Curves.fastOutSlowIn,
                                                    aspectRatio: 2.0,
                                                    autoPlay: true,
                                                  ),
                                                  items: widget.images!
                                                      .sublist(
                                                          0,
                                                          widget.images!
                                                                  .length -
                                                              1)
                                                      .map((i) {
                                                    return Builder(
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.60,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child:
                                                              InteractiveViewer(
                                                            panEnabled:
                                                                false, // Set it to false
                                                            boundaryMargin:
                                                                EdgeInsets.all(
                                                                    100),
                                                            minScale: 0.5,
                                                            maxScale: 2,
                                                            child:
                                                                FancyShimmerImage(
                                                              imageUrl: i,
                                                              errorWidget: Icon(
                                                                  Icons.delete),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }).toList(),
                                                ),
                                          Visibility(
                                            visible: widget.images!.length == 1
                                                ? false
                                                : true,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  right: 10.0, top: 150),
                                              width: 20.0,
                                              child: DotsIndicator(
                                                dotsCount: widget
                                                            .images!.length ==
                                                        0
                                                    ? 1
                                                    : (widget.images!.length > 5
                                                        ? 5
                                                        : widget
                                                            .images!.length),
                                                position: _currentIndex >=
                                                        (widget.images!.length >
                                                                5
                                                            ? 5
                                                            : widget
                                                                .images!.length)
                                                    ? (widget.images!.length > 5
                                                        ? 4
                                                        : widget.images!
                                                                .length -
                                                            1)
                                                    : _currentIndex,
                                                axis: Axis.vertical,
                                                decorator: DotsDecorator(
                                                  size: const Size.square(9.0),
                                                  activeSize:
                                                      const Size(38.0, 15.0),
                                                  activeShape:
                                                      RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
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
                                                Clipboard.setData(ClipboardData(
                                                    text: widget.SKU));
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "copied successfully!");
                                              },
                                              triggerMode:
                                                  TooltipTriggerMode.tap,
                                              message: widget.SKU,
                                              child: Icon(Icons.info,
                                                  size: 30, color: MAIN_COLOR),
                                            ),
                                          ),
                                          Visibility(
                                            visible: widget.featureProduct,
                                            child: Positioned(
                                              top: 10,
                                              left: 10,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Opacity(
                                                  opacity: 0.9,
                                                  child: Container(
                                                    height: 30,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white),
                                                    child: Center(
                                                      child: Text(
                                                        "👑  منتج مميز  👑",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                            color: MAIN_COLOR),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                          ),
                          Container(
                            height: 70,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        Share.share(
                                            "https://www.fawri.co/product-details-one/${widget.id}?offset=1");
                                      },
                                      child: Opacity(
                                        opacity: 0.75,
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white),
                                          child: Center(
                                            child: Image.asset(
                                              "assets/images/share.png",
                                              height: 30,
                                              width: 30,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )),
                                  Consumer<FavouriteProvider>(
                                    builder: (context, favoriteProvider, _) {
                                      return InkWell(
                                          onTap: () {
                                            Vibration.vibrate(duration: 300);
                                            if (LocalStorage().isFavorite(
                                                widget.id.toString())) {
                                              LocalStorage().deleteFavorite(
                                                  widget.id.toString());
                                              favoriteProvider
                                                  .notifyListeners();
                                            } else {
                                              LocalStorage()
                                                  .setFavorite(FavoriteItem(
                                                productId: widget.id,
                                                id: widget.id,
                                                name: widget.name,
                                                image: widget.image,
                                                price: double.parse(widget
                                                    .new_price
                                                    .toString()),
                                              ));
                                              favoriteProvider
                                                  .notifyListeners();
                                            }
                                          },
                                          child: Opacity(
                                            opacity: 0.75,
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                child: Icon(
                                                  Icons.favorite,
                                                  size: 30,
                                                  color: LocalStorage()
                                                          .isFavorite(widget.id
                                                              .toString())
                                                      ? Colors.red
                                                      : Colors.black26,
                                                ),
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
                    ),
                    Container(
                      width: double.infinity,
                      height: 250,
                      child: Center(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: FlareActor(
                            'assets/images/instagram_like.flr',
                            controller: flareControls,
                            color: Colors.red,
                            animation: 'idle',
                          ),
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
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      "₪${widget.old_price.toString().length > 5 ? widget.old_price.toString().substring(0, 5) : widget.old_price.toString()}",
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
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 0.0, 190, 0.0),
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
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 0.0, 10, 0.0),
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
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 0.0, 10.0, 0.0),
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Row(
                          children: [
                            Text(
                              "₪${widget.new_price}",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${calculateDiscountSimple(widget.id)}%",
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
                                widget.name,
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
                        visible: widget.description is List
                            ? widget.description.isNotEmpty
                            : widget.description != null &&
                                widget.description != '',
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
                                          child: widget.description is List
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
                                                              itemCount: widget
                                                                  .description
                                                                  .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        widget.description[index].toString().startsWith("{") &&
                                                                                widget.description[index].toString().endsWith("}")
                                                                            ? widget.description[index].toString().substring(1, widget.description[index].toString().length - 1)
                                                                            : widget.description[index].toString(),
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
                                              : widget.description is String
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        widget.description
                                                                .isNotEmpty
                                                            ? widget.description
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
                  width: 115,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: _hasError ? Colors.red : Colors.transparent,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: widget.loadingPage
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              showLoading = true;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                widget.SelectedSizes,
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 25,
                              )
                            ],
                          ),
                        )
                      : DropdownButton(
                          hint: Text(
                            widget.Sizes.length == 1
                                ? widget.Sizes[0]
                                : widget.SelectedSizes,
                            style: TextStyle(fontSize: 14),
                          ),
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30.0,
                          underline: Container(),
                          style: TextStyle(
                              color: MAIN_COLOR, fontWeight: FontWeight.bold),
                          items: widget.Sizes.map(
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
                              widget.SelectedSizes = val.toString();
                            });
                          },
                        ),
                ),
              ),
              if (showLoading && widget.loadingPage)
                Container(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      color: MAIN_COLOR,
                    )),
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
                      name: widget.inCart ? "ازاله من السله" : "أضف الى السله",
                      height: 50,
                      width: 150,
                      BorderColor: Colors.black,
                      OnClickFunction: () async {
                        if (widget.SKU.toString() == "" || widget.SKU == null) {
                          setState(() {
                            Vibration.vibrate(duration: 100);
                            _hasError = true;
                            Future.delayed(Duration(milliseconds: 1000), () {
                              setState(() {
                                _hasError = false;
                              });
                            });
                          });
                        } else {
                          if (widget.inCart) {
                            final newItem = CartItem(
                                sku: widget.SKU,
                                availability: 1,
                                vendor_sku: widget.vendor_SKU,
                                nickname: widget.nickname,
                                productId: widget.id,
                                id: widget.id,
                                name: widget.name,
                                image: widget.image.toString(),
                                price:
                                    double.parse(widget.new_price.toString()),
                                quantity: 1,
                                user_id: 0,
                                type: widget.SelectedSizes.toString() == ""
                                    ? LocalStorage().sizeUser[0]
                                    : widget.SelectedSizes,
                                placeInWarehouse: widget.placeInWarehouse[
                                        widget.SelectedSizes] ??
                                    "0000");

                            cartProvider.removeFromCart(widget.id);
                            setState(() {});
                          } else {
                            if (widget.SelectedSizes != "اختر مقاسك" &&
                                widget.SelectedSizes != "") {
                              setState(() {
                                loading = true;
                                clicked = true;
                              });
                              listClick(widgetKey);
                              Vibration.vibrate(duration: 300);
                              final newItem = CartItem(
                                  sku: widget.SKU,
                                  availability: 1,
                                  vendor_sku: widget.vendor_SKU,
                                  nickname: widget.nickname,
                                  productId: widget.id,
                                  id: widget.id,
                                  name: widget.name,
                                  image: widget.image.toString(),
                                  price:
                                      double.parse(widget.new_price.toString()),
                                  quantity: 1,
                                  user_id: 0,
                                  type: widget.SelectedSizes.toString() == ""
                                      ? LocalStorage().sizeUser[0]
                                      : widget.SelectedSizes,
                                  placeInWarehouse: widget.placeInWarehouse[
                                          widget.SelectedSizes] ??
                                      "0000");
                              cartProvider.addToCart(newItem);
                              const snackBar = SnackBar(
                                content:
                                    Text('تم اضافه المنتج الى السله بنجاح!'),
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
                                product_id: widget.id.toString(),
                                user_token: TOKEN,
                              );
                              cartFirebaseProvider.addToCart(cartFirebaseItem);
                              favoriteProvider.removeFromFavorite(widget.id);
                              final selectedSizeItem =
                                  widget.variants.firstWhere(
                                (variant) =>
                                    variant['size'] == widget.SelectedSizes,
                                orElse: () => null,
                              );
                              List<String> userIds = await cartFirebaseProvider
                                  .getUserIdsByProductId(widget.id.toString());
                              userIds.removeWhere((token) => token == TOKEN);

                              if (int.parse(
                                      selectedSizeItem["quantity"].toString()) <
                                  2) {
                                sendNotification(
                                    context: context,
                                    USER_TOKENS: userIds,
                                    productImage: widget.image.toString());
                              }
                            } else {
                              setState(() {
                                Vibration.vibrate(duration: 100);
                                _hasError = true;
                                Future.delayed(Duration(milliseconds: 1000),
                                    () {
                                  setState(() {
                                    _hasError = false;
                                  });
                                });
                              });
                            }
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
}
