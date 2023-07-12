import 'package:flutter/material.dart';

class ProductWidget extends StatefulWidget {
  final image, name, old_price, new_price;
  const ProductWidget(
      {super.key, this.image, this.name, this.old_price, this.new_price});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image.network(
            widget.image,
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "₪${widget.old_price}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "₪${widget.new_price}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.name,
              style: TextStyle(fontSize: 17),
            ),
          )
        ],
      ),
    );
  }
}
