import 'package:fawri_app_refactor/pages/products-category/products-category.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:fawri_app_refactor/services/dialogs/bottom-dialogs.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatefulWidget {
  final image, name, main_category;
  IconData CateIcon;
  CategoryWidget({
    Key? key,
    required this.name,
    required this.image,
    required this.main_category,
    required this.CateIcon,
  }) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        ChooseSizeDialogForShoes().showBottomDialog(context);
        // NavigatorFunction(
        //     context,
        //     ProductsCategories(
        //       category_id: widget.main_category.toString(),
        //     ));
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset(
                  widget.image,
                ).image,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0x80000000),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.CateIcon,
                      color: Colors.white,
                      size: 70,
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
