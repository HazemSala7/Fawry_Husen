import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fawri_app_refactor/pages/slider_products/slider_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import '../../constants/constants.dart';
import '../../model/slider/slider.dart';
import '../../server/domain/domain.dart';
import '../../server/functions/functions.dart';

class SlideImage extends StatefulWidget {
  List<Silder> slideimage;
  bool showShadow = false;
  bool click = false;
  SlideImage({
    Key? key,
    required this.slideimage,
    required this.showShadow,
    required this.click,
  }) : super(key: key);

  @override
  State<SlideImage> createState() => _SlideImageState();
}

class _SlideImageState extends State<SlideImage> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return ImageSlideshow(
        width: double.infinity,
        indicatorColor: MAIN_COLOR,
        isLoop: true,
        height: MediaQuery.of(context).size.height * 0.4,
        children: widget.slideimage
            .map((e) => InkWell(
                  onTap: () {
                    NavigatorFunction(context, SliderProducts(url: e.action));
                  },
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Stack(
                        children: [
                          FancyShimmerImage(
                            imageUrl: e.image,
                            boxFit: BoxFit.cover,
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.4,
                          ),
                          Visibility(
                            visible: widget.showShadow,
                            child: Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromARGB(183, 0, 0, 0),
                                      Color.fromARGB(45, 0, 0, 0)
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  e.title == null || e.title.toString() == ""
                                      ? "سلايدر 1 سلايدر 1"
                                      : e.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 30),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                Text(
                                  e.description == null ||
                                          e.description.toString() == ""
                                      ? "وصف عن منتج"
                                      : e.description,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
        autoPlayInterval: 6000,
        // isLoop: true,
      );
    });
  }
}
