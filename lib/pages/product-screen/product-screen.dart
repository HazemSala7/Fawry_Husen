import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/constants.dart';
import '../../server/functions/functions.dart';
import '../../services/json/json-services.dart';
import '../authentication/login_screen/login_screen.dart';

class ProductScreen extends StatefulWidget {
  var favourite;
  int id;
  ProductScreen({
    Key? key,
    required this.favourite,
    required this.id,
  }) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          body: FutureBuilder(
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
                  var newMap = [];
                  for (int i = 0; i < Products.length; i++) {
                    newMap.add(i);
                  }
                  return AnimationLimiter(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 2.5,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        height: MediaQuery.of(context).size.height,
                      ),
                      items: [1, 2, 3, 4, 5, 6].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return SingleChildScrollView(
                                child: ProductMethod(
                                    name: Products[i]["title"] as String,
                                    images: Products[i]["vendor_images_links"],
                                    description: Products[i]["description"],
                                    image: Products[i]["vendor_images_links"][0]
                                        as String));
                          },
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return Center(
                      child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator()));
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget ProductMethod(
      {String image = "", String name = "", var images, var description}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 400.0,
                  scrollDirection: Axis.vertical,
                  viewportFraction: 1,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  aspectRatio: 2.0,
                  autoPlay: true,
                ),
                items: [1, 2, 3].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_circle_right,
                        size: 35,
                        color: MAIN_COLOR,
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 20, left: 20),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            bool? login = prefs.getBool('login');
                            if (login == true) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Center(
                                            child: CircularProgressIndicator(
                                          color: MAIN_COLOR,
                                        ))),
                                  );
                                },
                              );
                              // widget.favourite == false
                              //     ? addFavourite(widget.id, context)
                              //     : removeFavourite(widget.id, context);
                              setState(() {
                                widget.favourite = !widget.favourite;
                              });
                            } else {
                              return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text(
                                        AppLocalizations.of(context)!.dialogl1),
                                    actions: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()),
                                          );
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: MAIN_COLOR,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .login,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: ImageIcon(
                            AssetImage(widget.favourite == false
                                ? "assets/images/like.jpeg"
                                : "assets/images/heart.png"),
                            color: MAIN_COLOR,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        InkWell(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            bool? login = prefs.getBool('login');
                            if (login == true) {
                              return;
                            } else {
                              return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text(
                                        AppLocalizations.of(context)!.dialogl1),
                                    actions: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()),
                                          );
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: MAIN_COLOR,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .login,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: ImageIcon(
                            AssetImage("assets/images/add_cart.png"),
                            color: MAIN_COLOR,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          "₪23.99",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Container(
                          height: 1,
                          width: 50,
                          color: Colors.black,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 190, 0.0),
                          child: Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message: "توصيل فوري",
                            child: FaIcon(
                              FontAwesomeIcons.truck,
                              color: Color(0xD9000000),
                              size: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10, 0.0),
                          child: Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message: "الدفع عند الاستلام",
                            child: FaIcon(
                              FontAwesomeIcons.moneyBillWaveAlt,
                              color: Color(0xD9000000),
                              size: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                          child: Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message: "سياسه الخصوصيه",
                            child: FaIcon(
                              Icons.handshake,
                              color: Color(0xD9000000),
                              size: 19,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    Text(
                      "₪19.99",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "(15%)",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 8),
                child: Row(
                  children: [
                    Text(
                      name.length > 40 ? name.substring(0, 40) + '...' : name,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(1, 0, 1, 0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: ExpandableNotifier(
                              initialExpanded: false,
                              child: ExpandablePanel(
                                header: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 12, 0),
                                      child: Icon(
                                        Icons.sticky_note_2_outlined,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    ),
                                    Text(
                                      "تفاصيل المنتج",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                collapsed: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                  ),
                                ),
                                expanded: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional(-1, 0),
                                        child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: description.length,
                                          itemBuilder: (context, index) {
                                            final key =
                                                description[index].keys.first;
                                            final value = description[index]
                                                    [key]
                                                .toString();
                                            return Row(
                                              children: [
                                                Text("$key : "),
                                                Expanded(
                                                    child: Text("$value : ")),
                                              ],
                                            );
                                            // Card(
                                            //   child: Padding(
                                            //     padding: EdgeInsets.all(8.0),
                                            //     child: DataTable(
                                            //       columns: [
                                            //         DataColumn(
                                            //             label: Text('Key')),
                                            //         DataColumn(
                                            //             label: Text('Value')),
                                            //       ],
                                            //       rows: [
                                            //         DataRow(cells: [
                                            //           DataCell(Text(key)),
                                            //           DataCell(Text(value)),
                                            //         ]),
                                            //       ],
                                            //     ),
                                            //   ),
                                            // );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                theme: ExpandableThemeData(
                                  tapHeaderToExpand: true,
                                  tapBodyToExpand: false,
                                  tapBodyToCollapse: false,
                                  headerAlignment:
                                      ExpandablePanelHeaderAlignment.center,
                                  hasIcon: true,
                                  expandIcon: Icons.keyboard_arrow_down_sharp,
                                  collapseIcon:
                                      Icons.keyboard_arrow_down_rounded,
                                  iconSize: 38,
                                  iconColor: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30, top: 20),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "ONE-SIZE",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ButtonWidget(
                          name: "أضف الى السله",
                          height: 50,
                          width: 150,
                          BorderColor: Colors.black,
                          OnClickFunction: () {},
                          BorderRaduis: 10,
                          ButtonColor: Colors.black,
                          NameColor: Colors.white)
                    ],
                  ),
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ], color: Colors.white),
                ),
              )
            ],
          )
          // Column(
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(right: 60, left: 60, top: 10),
          //       child: Container(
          //         height: 70,
          //         width: double.infinity,
          //         decoration: BoxDecoration(
          //             boxShadow: [
          //               BoxShadow(
          //                 color: Colors.grey.withOpacity(0.2),
          //                 spreadRadius: 7,
          //                 blurRadius: 5,
          //               ),
          //             ],
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(10)),
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.spaceAround,
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.only(
          //                 right: 10.0,
          //                 left: 10,
          //               ),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Text(
          //                     name.length > 14
          //                         ? name.substring(0, 14) + '...'
          //                         : name,
          //                     style: TextStyle(
          //                         fontSize: 16, fontWeight: FontWeight.bold),
          //                   ),
          //                   Row(
          //                     children: [
          //                       SizedBox(
          //                         width: 20,
          //                       ),
          //                       Text(
          //                         '₪99.99',
          //                         style: TextStyle(
          //                             fontSize: 18,
          //                             fontWeight: FontWeight.bold,
          //                             color: MAIN_COLOR),
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             Row(
          //               children: [
          //                 Expanded(
          //                   flex: 1,
          //                   child: InkWell(
          //                     onTap: () async {
          //                       SharedPreferences prefs =
          //                           await SharedPreferences.getInstance();
          //                       bool? login = prefs.getBool('login');
          //                       if (login == true) {
          //                         return;
          //                       } else {
          //                         return showDialog(
          //                           context: context,
          //                           builder: (BuildContext context) {
          //                             return AlertDialog(
          //                               content: Text(
          //                                   AppLocalizations.of(context)!
          //                                       .dialogl1),
          //                               actions: <Widget>[
          //                                 InkWell(
          //                                   onTap: () {
          //                                     Navigator.push(
          //                                       context,
          //                                       MaterialPageRoute(
          //                                           builder: (context) =>
          //                                               LoginScreen()),
          //                                     );
          //                                   },
          //                                   child: Container(
          //                                     width: 100,
          //                                     height: 40,
          //                                     decoration: BoxDecoration(
          //                                         color: MAIN_COLOR,
          //                                         borderRadius:
          //                                             BorderRadius.circular(
          //                                                 10)),
          //                                     child: Center(
          //                                       child: Text(
          //                                         AppLocalizations.of(context)!
          //                                             .login,
          //                                         style: TextStyle(
          //                                             color: Colors.white,
          //                                             fontWeight:
          //                                                 FontWeight.bold),
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ],
          //                             );
          //                           },
          //                         );
          //                       }
          //                     },
          //                     child: Container(
          //                       decoration: BoxDecoration(
          //                         borderRadius: BorderRadius.circular(4),
          //                         border: Border.all(color: Colors.white),
          //                         color: MAIN_COLOR,
          //                       ),
          //                       height: 35,
          //                       child: Center(
          //                         child: Text(
          //                           "اضافه الى السله",
          //                           textAlign: TextAlign.center,
          //                           style: TextStyle(
          //                               fontSize: 15,
          //                               fontWeight: FontWeight.bold,
          //                               color: Colors.white),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 Expanded(
          //                   flex: 1,
          //                   child: InkWell(
          //                     onTap: () async {
          //                       SharedPreferences prefs =
          //                           await SharedPreferences.getInstance();
          //                       bool? login = prefs.getBool('login');
          //                       if (login == true) {
          //                         showDialog(
          //                           context: context,
          //                           builder: (BuildContext context) {
          //                             return AlertDialog(
          //                               content: SizedBox(
          //                                   height: 100,
          //                                   width: 100,
          //                                   child: Center(
          //                                       child:
          //                                           CircularProgressIndicator(
          //                                     color: MAIN_COLOR,
          //                                   ))),
          //                             );
          //                           },
          //                         );
          //                         // widget.favourite == false
          //                         //     ? addFavourite(widget.id, context)
          //                         //     : removeFavourite(widget.id, context);
          //                         setState(() {
          //                           widget.favourite = !widget.favourite;
          //                         });
          //                       } else {
          //                         return showDialog(
          //                           context: context,
          //                           builder: (BuildContext context) {
          //                             return AlertDialog(
          //                               content: Text(
          //                                   AppLocalizations.of(context)!
          //                                       .dialogl1),
          //                               actions: <Widget>[
          //                                 InkWell(
          //                                   onTap: () {
          //                                     Navigator.push(
          //                                       context,
          //                                       MaterialPageRoute(
          //                                           builder: (context) =>
          //                                               LoginScreen()),
          //                                     );
          //                                   },
          //                                   child: Container(
          //                                     width: 100,
          //                                     height: 40,
          //                                     decoration: BoxDecoration(
          //                                         color: MAIN_COLOR,
          //                                         borderRadius:
          //                                             BorderRadius.circular(
          //                                                 10)),
          //                                     child: Center(
          //                                       child: Text(
          //                                         AppLocalizations.of(context)!
          //                                             .login,
          //                                         style: TextStyle(
          //                                             color: Colors.white,
          //                                             fontWeight:
          //                                                 FontWeight.bold),
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ],
          //                             );
          //                           },
          //                         );
          //                       }
          //                     },
          //                     child: Container(
          //                       decoration: BoxDecoration(
          //                         borderRadius: BorderRadius.circular(4),
          //                         border: Border.all(color: Colors.white),
          //                         color: MAIN_COLOR,
          //                       ),
          //                       height: 35,
          //                       child: Center(
          //                         child: Text(
          //                           widget.favourite == false
          //                               ? "اضافه الى المفضله"
          //                               : "ازاله من المفضله",
          //                           textAlign: TextAlign.center,
          //                           style: TextStyle(
          //                               fontSize: 15,
          //                               fontWeight: FontWeight.bold,
          //                               color: Colors.white),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             )
          //           ],
          //         ),
          //       ),
          //     ),
          //     Padding(
          //         padding: const EdgeInsets.only(
          //             right: 15, left: 15, top: 15, bottom: 30),
          //         child: Column(
          //           children: [
          //             desceiptionMethod(key: "لون", value: desc[0].toString()),
          //             desceiptionMethod(
          //                 key: "تصاميم", value: desc[1].toString()),
          //             desceiptionMethod(
          //                 key: "أصناف التصميم", value: desc[2].toString()),
          //             desceiptionMethod(
          //                 key: "تفاصيل", value: desc[3].toString()),
          //             desceiptionMethod(
          //                 key: "تفاصيل", value: desc[4].toString()),
          //             desceiptionMethod(
          //                 key: "تفاصيل", value: desc[5].toString()),
          //             desceiptionMethod(
          //                 key: "خط العنق", value: desc[6].toString()),
          //             desceiptionMethod(
          //                 key: "تفاصيل", value: desc[7].toString()),
          //             desceiptionMethod(key: "نوع", value: desc[8].toString()),
          //             desceiptionMethod(
          //                 key: "طول الأكمام", value: desc[9].toString()),
          //           ],
          //         )
          //         //  desceiptionMethod(),
          //         ),
          //     // Padding(
          //     //   padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
          //     //   child: Directionality(
          //     //     textDirection: TextDirection.rtl,
          //     //     child: Container(
          //     //       decoration: BoxDecoration(
          //     //           color: Color(0xffEBEBEB),
          //     //           border: Border.all(color: Color(0xffD6D3D3))),
          //     //       width: double.infinity,
          //     //       child: Padding(
          //     //         padding: const EdgeInsets.all(8.0),
          //     //         child: Text(
          //     //           "League of Legends (LoL), commonly referred to as League, is a 2009 multiplayer online battle arena video game developed and published by Riot Games. Inspired by Defense of the Ancients, a custom map for Warcraft III, Riot's founders sought to develop a stand-alone game in the same genre. Since its release in October 2009, League has been free-to-play and is monetized through purchasable character customization. The game is available for Microsoft Windows and macOS.",
          //     //           style: TextStyle(
          //     //             fontSize: 15,
          //     //             fontWeight: FontWeight.w500,
          //     //           ),
          //     //         ),
          //     //       ),
          //     //     ),
          //     //   ),
          //     // ),
          //   ],
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         "منتجات أخرى",
          //         style: TextStyle(
          //             fontWeight: FontWeight.bold, fontSize: 18),
          //       ),
          //       InkWell(
          //         onTap: () {
          //           Navigator.pop(context);
          //         },
          //         child: Text(
          //           "المزيد",
          //           style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               fontSize: 18,
          //               color: MAIN_COLOR),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // products.length == 0
          //     ? Container()
          //     : Padding(
          //         padding: const EdgeInsets.only(left: 10, top: 10),
          //         child: GridView.builder(
          //             scrollDirection: Axis.vertical,
          //             physics: NeverScrollableScrollPhysics(),
          //             shrinkWrap: true,
          //             itemCount: products.length,
          //             gridDelegate:
          //                 const SliverGridDelegateWithFixedCrossAxisCount(
          //                     crossAxisCount: 2, childAspectRatio: 0.7),
          //             itemBuilder: (context, int index) {
          //               return ProductWidget(
          //                   image: products[index]["image"],
          //                   favourite: products[index]["favourite"],
          //                   category_id: products[index]["category_id"],
          //                   name: products[index]["name"] ?? "",
          //                   desc: products[index]["description"] ?? "",
          //                   price: products[index]["price"] ?? "",
          //                   id: products[index]["id"] ?? 1);
          //             }),
          //       ),
        ],
      ),
    );
  }

  var desc = [
    {"لون": "عنابي اللون"},
    {"تصاميم": "حفلة"},
    {"أصناف التصميم": "الصاف"},
    {"تفاصيل": "طوق كشكش"},
    {"تفاصيل": "غير متساوي او غير متماثل"},
    {"تفاصيل": "حزام"},
    {"خط العنق": "ياقة القاع"},
    {"تفاصيل": "سستة"},
    {"نوع": "مناسب"},
    {"طول الأكمام": "نصف الأكمام"},
    {"أنواع الأكمام": "كم ضيق"},
    {"محيط الخصر": "ارتفاع الخصر"},
    {"شكل الكُفة": "غير متساوي او غير متماثل"},
    {"الطول": "طويل"},
    {"نوع الشكل": "النمط العادي"},
    {"قماش": "غير متمدد"},
    {"المواد": "الستان"},
    {"تكوين": "95% بوليستر"},
    {"تكوين": "5% إيلاستين"},
    {"ارشادات العناية": "يغسل بالغسالة، لا يستخدم التنظيف الجاف"},
    {"حزام": "نعم"},
    {"شفاف": "لا"}
  ];

  Widget desceiptionMethod({String key = "", String value = ""}) {
    return Container(
      height: 40,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(right: 15, left: 15),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xffD6D3D3))),
                child: Center(
                  child: Text(
                    key,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 245, 244, 244),
                    border: Border.all(color: Color(0xffD6D3D3))),
                child: Center(
                  child: Text(
                    value,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
