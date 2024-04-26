import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../components/category_widget/category-widget.dart';
import '../../../components/slider-widget/slider-widget.dart';
import '../../../constants/constants.dart';
import '../../../model/slider/slider.dart';
import '../../../server/functions/functions.dart';
import '../../../services/custom_icons/custom_icons.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool showGoToTopIcon = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 30),
        child: Column(
          children: [
            FutureBuilder(
                future: getSliders(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Shimmer.fromColors(
                        baseColor: const Color.fromARGB(255, 196, 196, 196),
                        highlightColor:
                            const Color.fromARGB(255, 129, 129, 129),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.3,
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    List<Silder>? album = [];
                    if (snapshot.data != null) {
                      List mysslide = snapshot.data;
                      List<Silder> album1 = mysslide.map((s) {
                        Silder c = Silder.fromJson(s);
                        return c;
                      }).toList();
                      album = album1;
                      return Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: SlideImage(
                            click: true,
                            showShadow: true,
                            slideimage: album,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: double.infinity,
                        color: Colors.white,
                      );
                    }
                  }
                }),
            GridView.builder(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, int index) {
                  return CategoryWidget(
                      main_category: categories[index]["main_category"],
                      name: categories[index]["name"],
                      CateImage: categories[index]["icon"],
                      CateIcon: categories[index]["icon"],
                      // id: categories[index]["id"],
                      image: categories[index]["image"]);
                }),
          ],
        ),
      ),
    );
  }
}
