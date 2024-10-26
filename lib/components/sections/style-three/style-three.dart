import 'package:fawri_app_refactor/components/product-widgets-styles/product-widget-style-three/product-widget-style-three.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:fawri_app_refactor/server/domain/domain.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class SectionStyleThree extends StatefulWidget {
  var sectionName, sectionURL, backgroundColor;
  SectionStyleThree({
    Key? key,
    required this.sectionName,
    required this.sectionURL,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  State<SectionStyleThree> createState() => _SectionStyleThreeState();
}

class _SectionStyleThreeState extends State<SectionStyleThree> {
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
            _scrollController.position.maxScrollExtent - 200 &&
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
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          height: 420,
          width: double.infinity,
          decoration: BoxDecoration(color: widget.backgroundColor),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, right: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      child: Lottie.asset(
                        "assets/lottie_animations/Animation - 1729073541927.json",
                        height: 40,
                        reverse: true,
                        repeat: true,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      widget.sectionName ?? "",
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        color: MAIN_COLOR,
                      ),
                    ),
                    SizedBox(width: 15),
                    Container(
                      width: 50,
                      height: 50,
                      child: Lottie.asset(
                        "assets/lottie_animations/Animation - 1729073541927.json",
                        height: 40,
                        reverse: true,
                        repeat: true,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                _isLoading && _productsArray.isEmpty
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
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
                        height: 300,
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
                                      child: ProductWidgetStyleThree(
                                        hasAPI: false,
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
                                    : SizedBox(
                                        width: 20); // Adjust width as needed
                              }
                            },
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              NavigatorFunction(
                context,
                HomeScreen(
                  endDate: "",
                  type: "",
                  url: URL_FLASH_SALES,
                  title: "",
                  slider: false,
                  selectedIndex: 0,
                  productsKinds: true,
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "اعرض بشكل أوسع",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MAIN_COLOR,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_circle_left_outlined),
                  ],
                ),
                Container(
                  width: 145,
                  height: 2,
                  color: MAIN_COLOR,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
