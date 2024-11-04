import 'package:fawri_app_refactor/components/product-widgets-styles/product-widget-style-four/product-widget-style-four.dart';
import 'package:fawri_app_refactor/components/product-widgets-styles/product-widget-style-two/product-widget-style-two.dart';
import 'package:fawri_app_refactor/services/remote_config_firebase/remote_config_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../server/functions/functions.dart';

class RecommendedProducts extends StatefulWidget {
  int productCardStyle;
  final List shortlisted;
  bool hasAPI = false;
  bool check11 = false;

  RecommendedProducts({
    Key? key,
    required this.check11,
    required this.hasAPI,
    required this.productCardStyle,
    required this.shortlisted,
  }) : super(key: key);

  @override
  _RecommendedProductsState createState() => _RecommendedProductsState();
}

class _RecommendedProductsState extends State<RecommendedProducts> {
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
    var newItems = await fetchRecommendedItems(_currentPage + 1);
    setState(() {
      if (newItems.isEmpty) {
        _isEndReached = true;
      } else {
        widget.shortlisted.addAll(newItems["items"]);
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
              height: widget.productCardStyle == 2 ? 224 : 300,
              width: MediaQuery.of(context).size.width,
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
                              child: widget.productCardStyle == 2
                                  ? ProductWidgetStyleTwo(
                                      check11: widget.check11,
                                      hasAPI: widget.hasAPI,
                                      fire: false,
                                      index: index,
                                      shortlisted: widget.shortlisted,
                                    )
                                  : ProductWidgetStyleFour(
                                      hasAPI: widget.hasAPI,
                                      fire: false,
                                      index: index,
                                      shortlisted: widget.shortlisted,
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
