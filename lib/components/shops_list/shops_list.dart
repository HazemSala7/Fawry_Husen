import 'package:fawri_app_refactor/components/product-widgets-styles/product-widget-style-four/product-widget-style-four.dart';
import 'package:fawri_app_refactor/components/product-widgets-styles/product-widget-style-two/product-widget-style-two.dart';
import 'package:fawri_app_refactor/pages/shop-profile/shop-profile.dart';
import 'package:fawri_app_refactor/services/remote_config_firebase/remote_config_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/constants.dart';
import '../../pages/product-screen/product-screen.dart';
import '../../server/domain/domain.dart';
import '../../server/functions/functions.dart';

class ShopsList extends StatefulWidget {
  var shortlisted;

  ShopsList({
    Key? key,
    required this.shortlisted,
  }) : super(key: key);

  @override
  _ShopsListState createState() => _ShopsListState();
}

class _ShopsListState extends State<ShopsList> {
  ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isEndReached = false;

  String titleName = "";
  Future<void> _initialize() async {
    var _titleName = await FirebaseRemoteConfigClass().fetchtitleHomePage();
    setState(() {
      titleName = _titleName.toString();
    });
  }

  @override
  void initState() {
    _initialize();
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels == 0) {
        // Reached the top
      } else {
        // Reached the bottom
        if (!_isLoading && !_isEndReached) {
          _loadMore();
        }
      }
    }
  }

  void _loadMore() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    var newItems = await getShops(_currentPage + 1);
    setState(() {
      if (newItems == false) {
        _isEndReached = true;
      } else {
        widget.shortlisted.addAll(newItems["data"]);
        _currentPage++;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10, bottom: 0),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.32,
              child: AnimationLimiter(
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      widget.shortlisted.length + (_isEndReached ? 0 : 1),
                  itemBuilder: (context, int index) {
                    if (index < widget.shortlisted.length) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          horizontalOffset: 100.0,
                          child: FadeInAnimation(
                              child: Padding(
                            padding: const EdgeInsets.only(
                                right: 5, left: 5, top: 10),
                            child: InkWell(
                              onTap: () {
                                NavigatorFunction(
                                    context,
                                    ShopProfile(
                                        image: widget.shortlisted[index]
                                                ["shopImage"] ??
                                            "https://www.fawri.co/assets/about_us/fawri_logo.jpg",
                                        name: widget.shortlisted[index]
                                            ["shopName"],
                                        rank: 2));
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                          width: 150,
                                          height: 150,
                                          child: FancyShimmerImage(
                                            shimmerDuration:
                                                Duration(milliseconds: 0),
                                            imageUrl: widget.shortlisted[index]
                                                    ["shopImage"] ??
                                                "https://www.fawri.co/assets/about_us/fawri_logo.jpg",
                                            width: 150,
                                            height: 150,
                                            boxFit: BoxFit.cover,
                                            errorWidget: Image.asset(
                                              "assets/images/playstore.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      widget.shortlisted[index]["shopName"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                        ),
                      );
                    } else {
                      return _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox(width: 20); // Adjust width as needed
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
