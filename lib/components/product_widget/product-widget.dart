import 'package:cached_network_image/cached_network_image.dart';
import 'package:fawri_app_refactor/pages/product-screen/product-screen.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class ProductWidget extends StatefulWidget {
  final image, name, old_price, new_price;
  int index;
  ProductWidget({
    super.key,
    this.image,
    this.name,
    this.old_price,
    this.new_price,
    required this.index,
  });

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductScreen(favourite: false, id: 5384)));
      },
      child: Container(
        child: Column(
          children: [
            Container(
              height: 190,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: widget.image,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Container(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "₪${widget.old_price}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "₪${widget.new_price}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.red),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.favorite_border,
                    color: Colors.black,
                    size: 25,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Text(
                    widget.name.length > 17
                        ? widget.name.substring(0, 17) + '...'
                        : widget.name,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
