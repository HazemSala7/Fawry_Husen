// import 'dart:async';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:dots_indicator/dots_indicator.dart';
// import 'package:expandable/expandable.dart';
// import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:like_button/like_button.dart';
// import 'package:provider/provider.dart';
// import 'package:vibration/vibration.dart';

// import '../../../LocalDB/Models/CartModel.dart';
// import '../../../LocalDB/Models/FavoriteItem.dart';
// import '../../../LocalDB/Provider/CartProvider.dart';
// import '../../../LocalDB/Provider/FavouriteProvider.dart';
// import '../../../components/button_widget/button_widget.dart';
// import '../../../constants/constants.dart';

// class ProductScreenItem extends StatefulWidget {
//   String image = "";
//   String name = "";
//   String SKU = "";
//   List<String> Sizes;
//   String SelectedSizes = "اختر الحجم";
//   List? images;
//   int id = 0;
//   var description;
//   bool inCart = false;
//   bool isLikedProduct = false;
//   var old_price;
//   var new_pric;
//   Function listClick;
//   ProductScreenItem({
//     Key? key,
//     required this.listClick,
//     required this.image,
//     required this.name,
//     required this.SKU,
//     required this.Sizes,
//     required this.SelectedSizes,
//     this.images,
//     required this.id,
//     required this.description,
//     required this.inCart,
//     required this.isLikedProduct,
//     required this.old_price,
//     required this.new_pric,
//   }) : super(key: key);

//   @override
//   State<ProductScreenItem> createState() => _ProductScreenItemState();
// }

// class _ProductScreenItemState extends State<ProductScreenItem> {
//   @override
//   final GlobalKey widgetKey = GlobalKey();
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context);
//     final favoriteProvider =
//         Provider.of<FavouriteProvider>(context, listen: false);
//     Future<bool> onLikeButtonTapped(bool liked) async {
//       bool isFavorite = favoriteProvider.isProductFavorite(widget.id);

//       if (isFavorite) {
//         await favoriteProvider.removeFromFavorite(widget.id);
//         Fluttertoast.showToast(
//           msg: "تم حذف هذا المنتج من المفضلة بنجاح",
//         );
//         return false;
//       }
//       try {
//         Vibration.vibrate(duration: 300);
//         final newItem = FavoriteItem(
//           productId: widget.id,
//           name: widget.name,
//           image: widget.image,
//           price: double.parse(widget.new_pric.toString()),
//         );

//         await favoriteProvider.addToFavorite(newItem);
//         Fluttertoast.showToast(
//           msg: "تم اضافة هذا المنتج الى المفضلة بنجاح",
//         );
//         widget.isLikedProduct = true;
//         return true;
//       } catch (e) {
//         return !widget.isLikedProduct;
//       }
//     }

//     int _currentIndex = 0;
//     bool clicked = false;

//     Widget desceiptionMethod({String key = "", String value = ""}) {
//       return Container(
//         height: 40,
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.only(right: 15, left: 15),
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Color(0xffD6D3D3))),
//                   child: Center(
//                     child: Text(
//                       key,
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: Color.fromARGB(255, 245, 244, 244),
//                       border: Border.all(color: Color(0xffD6D3D3))),
//                   child: Center(
//                     child: Text(
//                       value,
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Stack(
//       alignment: Alignment.bottomCenter,
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   key: widgetKey,
//                   height: MediaQuery.of(context).size.height * 0.6,
//                   width: double.infinity,
//                   child: clicked
//                       ? Container()
//                       : StatefulBuilder(
//                           builder:
//                               (BuildContext context, StateSetter setState) {
//                             return Stack(
//                               alignment: Alignment.topRight,
//                               children: [
//                                 widget.images!.length == 1
//                                     ? Container(
//                                         height: 450,
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         child: FancyShimmerImage(
//                                           imageUrl: widget.images![0],
//                                         ),
//                                       )
//                                     : CarouselSlider(
//                                         options: CarouselOptions(
//                                           onPageChanged: (index, reason) {
//                                             _currentIndex = index;
//                                             setState(() {});
//                                           },
//                                           height: 450.0,
//                                           scrollDirection: Axis.vertical,
//                                           viewportFraction: 1,
//                                           autoPlayCurve: Curves.fastOutSlowIn,
//                                           aspectRatio: 2.0,
//                                           autoPlay: true,
//                                         ),
//                                         items: widget.images!.map((i) {
//                                           return Builder(
//                                             builder: (BuildContext context) {
//                                               return Container(
//                                                 height: 450,
//                                                 width: MediaQuery.of(context)
//                                                     .size
//                                                     .width,
//                                                 child: InteractiveViewer(
//                                                   panEnabled:
//                                                       false, // Set it to false
//                                                   boundaryMargin:
//                                                       EdgeInsets.all(100),
//                                                   minScale: 0.5,
//                                                   maxScale: 2,
//                                                   child: FancyShimmerImage(
//                                                     imageUrl: i,
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           );
//                                         }).toList(),
//                                       ),
//                                 Visibility(
//                                   visible:
//                                       widget.images!.length == 1 ? false : true,
//                                   child: Container(
//                                     margin:
//                                         EdgeInsets.only(right: 10.0, top: 150),
//                                     width: 20.0,
//                                     child: DotsIndicator(
//                                       dotsCount: widget.images!.length == 0
//                                           ? 1
//                                           : widget.images!.length,
//                                       position:
//                                           _currentIndex >= widget.images!.length
//                                               ? widget.images!.length - 1
//                                               : _currentIndex,
//                                       axis: Axis.vertical,
//                                       decorator: DotsDecorator(
//                                         size: const Size.square(9.0),
//                                         activeSize: const Size(38.0, 15.0),
//                                         activeShape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(5.0),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 10,
//                                   right: 10,
//                                   child: Tooltip(
//                                     onTriggered: () {
//                                       Clipboard.setData(
//                                           ClipboardData(text: widget.SKU));
//                                       Fluttertoast.showToast(
//                                           msg: "copied successfully!");
//                                     },
//                                     triggerMode: TooltipTriggerMode.tap,
//                                     message: widget.SKU,
//                                     child: Icon(Icons.info,
//                                         size: 30, color: MAIN_COLOR),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                 ),
//                 Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10, left: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           LikeButton(
//                             circleColor:
//                                 CircleColor(start: Colors.red, end: Colors.red),
//                             size: 35,
//                             onTap: onLikeButtonTapped,
//                             isLiked: widget.isLikedProduct,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               Text(
//                                 "₪${widget.old_price.toString().length > 5 ? widget.old_price.toString().substring(0, 5) : widget.old_price.toString()}",
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                 ),
//                               ),
//                               Container(
//                                 height: 1,
//                                 width: 50,
//                                 color: Colors.black,
//                               )
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Padding(
//                                 padding:
//                                     EdgeInsets.fromLTRB(0.0, 0.0, 190, 0.0),
//                                 child: Tooltip(
//                                   triggerMode: TooltipTriggerMode.tap,
//                                   message: "توصيل فوري",
//                                   child: FaIcon(
//                                     FontAwesomeIcons.truck,
//                                     color: Color(0xD9000000),
//                                     size: 16,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.fromLTRB(0.0, 0.0, 10, 0.0),
//                                 child: Tooltip(
//                                   triggerMode: TooltipTriggerMode.tap,
//                                   message: "الدفع عند الاستلام",
//                                   child: FaIcon(
//                                     FontAwesomeIcons.moneyBillWaveAlt,
//                                     color: Color(0xD9000000),
//                                     size: 16,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding:
//                                     EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
//                                 child: Tooltip(
//                                   triggerMode: TooltipTriggerMode.tap,
//                                   message: "سياسه الخصوصيه",
//                                   child: FaIcon(
//                                     Icons.handshake,
//                                     color: Color(0xD9000000),
//                                     size: 19,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 8),
//                       child: Row(
//                         children: [
//                           Text(
//                             "₪${widget.new_pric}",
//                             style: TextStyle(
//                                 fontSize: 20,
//                                 color: Colors.red,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             "(15%)",
//                             style: TextStyle(
//                                 fontSize: 20,
//                                 color: Colors.red,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 8, top: 8),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               widget.name,
//                               style: TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Visibility(
//                       visible: widget.description is List
//                           ? widget.description.isNotEmpty
//                           : widget.description != null &&
//                               widget.description != '',
//                       child: Padding(
//                         padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Expanded(
//                               child: Padding(
//                                 padding:
//                                     EdgeInsetsDirectional.fromSTEB(1, 0, 1, 0),
//                                 child: Container(
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                   ),
//                                   child: Container(
//                                     width: double.infinity,
//                                     color: Colors.white,
//                                     child: ExpandableNotifier(
//                                       initialExpanded: false,
//                                       child: ExpandablePanel(
//                                         header: Row(
//                                           mainAxisSize: MainAxisSize.max,
//                                           children: [
//                                             Padding(
//                                               padding: EdgeInsetsDirectional
//                                                   .fromSTEB(0, 0, 12, 0),
//                                               child: Icon(
//                                                 Icons.sticky_note_2_outlined,
//                                                 color: Colors.black,
//                                                 size: 24,
//                                               ),
//                                             ),
//                                             Text(
//                                               "تفاصيل المنتج",
//                                               style: TextStyle(
//                                                 fontSize: 15,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         collapsed: Container(
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           decoration: BoxDecoration(
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                         expanded: widget.description is List
//                                             ? SingleChildScrollView(
//                                                 child: Column(
//                                                   mainAxisSize:
//                                                       MainAxisSize.max,
//                                                   children: [
//                                                     Align(
//                                                         alignment:
//                                                             AlignmentDirectional(
//                                                                 -1, 0),
//                                                         child: ListView.builder(
//                                                           physics:
//                                                               NeverScrollableScrollPhysics(),
//                                                           shrinkWrap: true,
//                                                           itemCount: widget
//                                                               .description
//                                                               .length,
//                                                           itemBuilder:
//                                                               (context, index) {
//                                                             final item = widget
//                                                                     .description[
//                                                                 index];
//                                                             final key =
//                                                                 item.keys.first;
//                                                             final value = item
//                                                                 .values.first;
//                                                             return Row(
//                                                               children: [
//                                                                 Text("$key: "),
//                                                                 Expanded(
//                                                                     child: Text(
//                                                                         "$value")),
//                                                               ],
//                                                             );
//                                                           },
//                                                         )),
//                                                   ],
//                                                 ),
//                                               )
//                                             : widget.description is String
//                                                 ? Text(widget
//                                                     .description) // Show the simple string description
//                                                 : Container(),
//                                         theme: ExpandableThemeData(
//                                           tapHeaderToExpand: true,
//                                           tapBodyToExpand: false,
//                                           tapBodyToCollapse: false,
//                                           headerAlignment:
//                                               ExpandablePanelHeaderAlignment
//                                                   .center,
//                                           hasIcon: true,
//                                           expandIcon:
//                                               Icons.keyboard_arrow_down_sharp,
//                                           collapseIcon:
//                                               Icons.keyboard_arrow_down_rounded,
//                                           iconSize: 38,
//                                           iconColor: Colors.black,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 100,
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//         Container(
//           width: double.infinity,
//           height: 70,
//           decoration: BoxDecoration(boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 5,
//               blurRadius: 7,
//               offset: Offset(0, 3), // changes position of shadow
//             ),
//           ], color: Colors.white),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Container(
//                 width: 120,
//                 child: DropdownButton<String>(
//                   isExpanded: true,
//                   value: widget.SelectedSizes,
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       widget.SelectedSizes = newValue!;
//                     });
//                   },
//                   items: widget.Sizes.map((String size) {
//                     return DropdownMenuItem<String>(
//                       value: size,
//                       child: Text(
//                         size,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               loading
//                   ? Container(
//                       height: 50,
//                       width: 150,
//                       decoration: BoxDecoration(
//                           color: Colors.black,
//                           borderRadius: BorderRadius.circular(40),
//                           border: Border.all(color: Colors.black)),
//                       child: Center(
//                           child: Container(
//                         height: 15,
//                         width: 15,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                         ),
//                       )),
//                     )
//                   : ButtonWidget(
//                       name: widget.inCart ? "ازاله من السله" : "أضف الى السله",
//                       height: 50,
//                       width: 150,
//                       BorderColor: Colors.black,
//                       OnClickFunction: () async {
//                         setState(() {
//                           loading = true;
//                           clicked = true;
//                         });
//                         widget.listClick(widgetKey);
//                         Vibration.vibrate(duration: 300);

//                         final newItem = CartItem(
//                           productId: widget.id,
//                           name: widget.name,
//                           image: widget.image.toString(),
//                           price: double.parse(widget.new_pric.toString()),
//                           quantity: 1,
//                           user_id: 0,
//                         );
//                         cartProvider.addToCart(newItem);

//                         const snackBar = SnackBar(
//                           content: Text('تم اضافه المنتج الى السله بنجاح!'),
//                         );
//                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                         Timer(Duration(milliseconds: 500), () {
//                           Fluttertoast.cancel();
//                           // Dismiss the toast after the specified duration
//                         });
//                         Timer(Duration(seconds: 1), () async {
//                           Navigator.pop(context);
//                         });
//                       },
//                       BorderRaduis: 10,
//                       ButtonColor: Colors.black,
//                       NameColor: Colors.white)
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   bool loading = false;
// }
