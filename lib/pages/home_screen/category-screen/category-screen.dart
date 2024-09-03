import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/components/category_widget/kids_category_dialog/kids_category_dialog.dart';
import 'package:fawri_app_refactor/components/category_widget/shoes_category_dialog/shoes_category_dialog.dart';
import 'package:fawri_app_refactor/components/category_widget/sizes_page/sizes_page.dart';
import 'package:fawri_app_refactor/components/grid_view_categories/grid_view_categories.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/pages/products-category/products-category.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../components/category_widget/category-widget.dart';
import '../../../components/flash_sales_list/flash_sales_list.dart';
import '../../../components/slider-widget/slider-widget.dart';
import '../../../model/slider/slider.dart';
import '../../../server/functions/functions.dart';
import '../../../services/remote_config_firebase/remote_config_firebase.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool showGoToTopIcon = false;
  String titleName = "";

  setControllers() async {
    var _titleName = await FirebaseRemoteConfigClass().fetchtitleHomePage();
    setState(() {
      titleName = _titleName.toString();
    });
  }

  @override
  void initState() {
    setControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          children: [GridViewCategories()],
        ),
      ),
    );
  }
}
