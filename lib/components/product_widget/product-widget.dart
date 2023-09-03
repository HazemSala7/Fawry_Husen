import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fawri_app_refactor/pages/product-screen/product-screen.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../../LocalDB/Models/FavoriteItem.dart';
import '../../LocalDB/Provider/FavouriteProvider.dart';
import '../../constants/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ProductWidget extends StatefulWidget {
  final image, name, old_price, new_price, thumbnail;
  int index, id;
  List Products;
  List Images;
  ProductWidget({
    super.key,
    this.image,
    this.name,
    required this.id,
    required this.Images,
    this.old_price,
    required this.Products,
    required this.thumbnail,
    this.new_price,
    required this.index,
  });

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Future<String> _cacheImage(String imageUrl) async {
    final cacheManager = DefaultCacheManager();
    final cachedFile = await cacheManager.getSingleFile(imageUrl);
    return cachedFile.path;
  }

  String _currentImage = '';

  Future<void> _checkInternetSpeed() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        _currentImage = widget.image;
      });
    } else {
      setState(() {
        _currentImage = widget.thumbnail;
      });
    }
  }

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkInternetSpeed();
  }

  Widget _imageView(String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8),
        child: Image.network(image, fit: BoxFit.cover),
      ),
    );
  }

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        var result = [];
        int startIndex = widget.index - 20;
        int endIndex = widget.index + 20;
        if (startIndex < 0) {
          startIndex = 0;
        }
        if (endIndex > widget.Products.length) {
          endIndex = widget.Products.length;
        }
        result.addAll(widget.Products.sublist(startIndex, endIndex));
        result.insert(0, widget.Products[widget.index]);
        List<String> idsList =
            result.map((item) => item['id'].toString()).toList();
        String commaSeparatedIds = idsList.join(', ');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductScreen(
                      index: widget.index,
                      cart_fav: false,
                      Images: widget.Images,
                      favourite: false,
                      id: widget.id,
                      Product: result,
                      IDs: commaSeparatedIds,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 7,
            blurRadius: 5,
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: ImageSlideshow(
                width: double.infinity,
                initialPage: 0,
                indicatorColor:
                    widget.Images.length == 1 ? Colors.transparent : MAIN_COLOR,
                indicatorBackgroundColor: Colors.grey,
                children: widget.Images.map((e) => FancyShimmerImage(
                      imageUrl: e,
                    )).toList(),
                onPageChanged: (value) {},
                autoPlayInterval: 0,
                isLoop: false,
              ),
              // child: ClipRRect(
              //   borderRadius: BorderRadius.only(
              //     topRight: Radius.circular(10),
              //     topLeft: Radius.circular(10),
              //   ),
              //   child: Container(
              //     height: 240,
              //     child: CarouselSlider(
              //       items: widget.Images.map((url) {
              //         return Builder(
              //           builder: (BuildContext context) {
              //             return FancyShimmerImage(
              //               imageUrl: url,
              //             );
              //           },
              //         );
              //       }).toList(),
              //       options: CarouselOptions(
              //         height: 240,
              //         viewportFraction: 1.0,
              //         onPageChanged: (index, reason) {
              //           setState(() {
              //             _currentIndex = index;
              //           });
              //         },
              //         enableInfiniteScroll: true,
              //         autoPlay: true,
              //         autoPlayInterval: Duration(seconds: 3),
              //         autoPlayAnimationDuration: Duration(milliseconds: 2500),
              //         autoPlayCurve: Curves.fastOutSlowIn,
              //         aspectRatio: 2.0,
              //         enlargeCenterPage: false,
              //         scrollDirection: Axis.horizontal,
              //       ),
              //     ),
              //   ),
              // ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            "₪${double.parse(widget.old_price.toString()) * 1.5}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            height: 1,
                            width: 50,
                            color: Colors.black,
                          )
                        ],
                      ),
                      Text(
                        "₪${widget.new_price}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.red),
                      ),
                    ],
                  ),
                  LikeButton(
                    size: 25,
                    onTap: onLikeButtonTapped,
                    isLiked: isLikedButton,
                  )
                  // Icon(
                  //   Icons.favorite_border,
                  //   color: Colors.black,
                  //   size: 25,
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Container(
                    width: 177,
                    child: Text(
                      widget.name.length > 30
                          ? widget.name.substring(0, 30)
                          : widget.name,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isLikedButton = false;
  Future<bool> onLikeButtonTapped(bool isLiked) async {
    final favoriteProvider =
        Provider.of<FavouriteProvider>(context, listen: false);
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
        image: widget.image.toString(),
        price: double.parse(widget.new_price.toString()),
      );
      await favoriteProvider.addToFavorite(newItem);
      Fluttertoast.showToast(
        msg: "تم اضافة هذا المنتج الى المفضلة بنجاح",
      );
      isLikedButton = true;
      return true;
    } catch (e) {
      return !isLiked;
    }
    // return true;
  }
}
