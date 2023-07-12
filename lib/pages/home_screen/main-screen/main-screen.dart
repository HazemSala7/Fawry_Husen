import 'package:fawri_app_refactor/components/product_widget/product-widget.dart';
import 'package:flutter/material.dart';

import '../../../components/category_widget/category-widget.dart';
import '../../../constants/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 30),
      child: GridView.builder(
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
            return ProductWidget(
                name: categories[index]["name"],
                new_price: 69.99,
                old_price: 30.99,
                image: categories[index]["image"]);
          }),
    );
  }
}
