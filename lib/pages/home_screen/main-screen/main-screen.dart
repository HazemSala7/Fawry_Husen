import 'package:fawri_app_refactor/components/product_widget/product-widget.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../constants/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getProducts(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: SpinKitPulse(
                color: MAIN_COLOR,
                size: 60,
              ),
            ),
          );
        } else {
          if (snapshot.data != null) {
            var Products = snapshot.data["items"];
            return Products.length == 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text(
                      "لا يوجد أي منتج",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 30, right: 10, left: 10),
                    child: AnimationLimiter(
                      child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: Products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                            childAspectRatio: 0.63,
                          ),
                          itemBuilder: (context, int index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                horizontalOffset: 100.0,
                                // verticalOffset: 100.0,
                                child: FadeInAnimation(
                                  curve: Curves.easeOut,
                                  child: ProductWidget(
                                      index: index,
                                      name: Products[index]["title"],
                                      new_price: 69.99,
                                      old_price: 30.99,
                                      image: Products[index]
                                          ["vendor_images_links"][0]),
                                ),
                              ),
                            );
                          }),
                    ),
                  );
          } else {
            return Center(
                child: SizedBox(
                    height: 40, width: 40, child: CircularProgressIndicator()));
          }
        }
      },
    );
  }
}
