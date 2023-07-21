import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../constants/constants.dart';

class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            child: Row(
              children: [
                Text(
                  "المفضله",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          FutureBuilder(
              future: getProducts(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: SpinKitPulse(
                      color: MAIN_COLOR,
                      size: 60,
                    ),
                  );
                } else if (snapshot.data != null) {
                  var album1 = snapshot.data["items"];
                  if (album1.length == 0) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'المفضله فارغه',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: album1.length,
                          shrinkWrap: true,
                          itemBuilder: ((context, index) {
                            return cartCard(
                              image: album1[index]["vendor_images_links"][0],
                              fav_id: 12,
                              id: 12,
                              name: album1[index]["title"],
                              price: "88.99",
                              categry: "1",
                            );
                          })),
                    );
                  }
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'الرجاء تسجيل الدخول',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }

  Widget cartCard(
      {String image = "",
      String price = "",
      String name = "",
      int fav_id = 0,
      int id = 0,
      String categry = ""}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 7,
                blurRadius: 5,
              ),
            ],
            color: Color(0xffF6F6F6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Container(
                  child: Image.network(
                    image,
                    height: 180,
                    width: 110,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(name.length > 18 ? name.substring(0, 18) : name),
                      Text(categry),
                      Text("${price} NIS"),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60, bottom: 15, right: 10),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SizedBox(
                                height: 100,
                                width: 100,
                                child:
                                    Center(child: CircularProgressIndicator())),
                          );
                        },
                      );
                      // await removeFavourite(fav_id, context);
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black)),
                      width: 110,
                      height: 30,
                      child: Center(
                        child: Text("ازاله من المفضله"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SizedBox(
                                height: 100,
                                width: 100,
                                child:
                                    Center(child: CircularProgressIndicator())),
                          );
                        },
                      );
                      // await addCart(id, 1, price, context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black)),
                      width: 110,
                      height: 30,
                      child: Center(
                        child: Text("اضافه الى السله"),
                      ),
                    ),
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
