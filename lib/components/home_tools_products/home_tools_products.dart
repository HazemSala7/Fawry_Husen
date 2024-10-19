import 'package:fawri_app_refactor/components/product-widgets-styles/product-widget-style-two/product-widget-style-two.dart';
import 'package:fawri_app_refactor/services/remote_config_firebase/remote_config_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../server/functions/functions.dart';

class HomeToolsProducts extends StatefulWidget {
  final List shortlisted;

  HomeToolsProducts({
    Key? key,
    required this.shortlisted,
  }) : super(key: key);

  @override
  _HomeToolsProductsState createState() => _HomeToolsProductsState();
}

class _HomeToolsProductsState extends State<HomeToolsProducts> {
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
    var newItems = await getHomeData(_currentPage + 1);

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
            padding:
                const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 0),
            child: Container(
              height: 224,
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
                              child: ProductWidgetStyleTwo(
                            hasAPI: false,
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
