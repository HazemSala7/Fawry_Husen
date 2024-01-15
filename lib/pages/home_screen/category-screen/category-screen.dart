import 'package:flutter/material.dart';

import '../../../components/category_widget/category-widget.dart';
import '../../../constants/constants.dart';
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
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification &&
            scrollNotification.metrics.pixels > 400) {
          // If the user scrolls down more than 400 pixels, show the icon
          setState(() {
            showGoToTopIcon = true;
          });
        } else {
          // Hide the icon if not scrolled down enough
          setState(() {
            showGoToTopIcon = false;
          });
        }
        return true;
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 30),
          child: Column(
            children: [
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
              if (showGoToTopIcon)
                FloatingActionButton(
                  onPressed: () {
                    // Implement the action when the button is pressed
                    // For example, scroll back to the top
                    // You can use ScrollController to achieve this
                  },
                  child: Icon(Icons.arrow_upward),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
