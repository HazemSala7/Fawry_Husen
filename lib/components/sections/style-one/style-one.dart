import 'package:fawri_app_refactor/components/product-widgets-styles/product-widget-style-two/product-widget-style-two.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';

class SectionStyleOne extends StatefulWidget {
  var sectionName, sectionURL, backgroundColor;
  SectionStyleOne({
    Key? key,
    required this.sectionName,
    required this.sectionURL,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  State<SectionStyleOne> createState() => _SectionStyleOneState();
}

class _SectionStyleOneState extends State<SectionStyleOne> {
  ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isEndReached = false;
  List<dynamic> _productsArray = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent -
                200 && // Trigger before reaching the end
        !_isLoading &&
        !_isEndReached) {
      _loadMoreData();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    final initialProducts =
        await getDynamicSectionProducts(widget.sectionURL, _currentPage);
    if (initialProducts != null && initialProducts["items"].isNotEmpty) {
      setState(() {
        _productsArray = initialProducts["items"];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isEndReached = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreData() async {
    setState(() {
      _isLoading = true;
    });

    final newProducts =
        await getDynamicSectionProducts(widget.sectionURL, _currentPage + 1);
    if (newProducts != null && newProducts["items"].isNotEmpty) {
      setState(() {
        _productsArray.addAll(newProducts["items"]);
        _currentPage++;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isEndReached = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
            child: Row(
              children: [
                Text(
                  widget.sectionName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 0),
            child: _isLoading && _productsArray.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ListView.builder(
                        itemCount: 4,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Shimmer.fromColors(
                              baseColor:
                                  const Color.fromARGB(255, 196, 196, 196),
                              highlightColor:
                                  const Color.fromARGB(255, 129, 129, 129),
                              child: Container(
                                width: 160,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: AnimationLimiter(
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            _productsArray.length + (_isEndReached ? 0 : 1),
                        itemBuilder: (context, int index) {
                          if (index < _productsArray.length) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                horizontalOffset: 100.0,
                                child: FadeInAnimation(
                                  child: ProductWidgetStyleTwo(
                                    hasAPI: true,
                                    fire: true,
                                    index: index,
                                    shortlisted: _productsArray,
                                  ),
                                ),
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
