import 'package:fawri_app_refactor/components/button_widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:vibration/vibration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../LocalDB/Database/local_storage.dart';
import '../../../constants/constants.dart';
import '../../../firebase/selected_sizes/selected_sizes_controller.dart';
import '../../../firebase/selected_sizes/selected_sizes_model.dart';
import '../../../pages/products-category/products-category.dart';
import '../../../server/functions/functions.dart';

class SizesPage extends StatefulWidget {
  var sizes, containerWidths, keys, main_category, name;
  SizesPage(
      {super.key,
      required this.sizes,
      required this.name,
      required this.main_category,
      required this.keys,
      required this.containerWidths});

  @override
  State<SizesPage> createState() => _SizesPageState();
}

class _SizesPageState extends State<SizesPage> {
  @override
  bool isAnyItemSelected = false;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            backgroundColor: MAIN_COLOR,
            centerTitle: true,
            title: Text(
              "فوري",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                )),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 25, left: 25, top: 25),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "الرجاء اختيار مقاسك , لتجربه افضل",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 25, left: 25, top: 20),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Set the number of columns you want
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 25.0,
                      childAspectRatio: 3.0),
                  itemCount: widget.keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Container(
                          width: widget.containerWidths[index],
                          child: InkWell(
                            onTap: () {
                              Vibration.vibrate(duration: 300);
                              setState(() {
                                widget.sizes[widget.keys[index]] =
                                    !widget.sizes[widget.keys[index]];
                                isAnyItemSelected =
                                    widget.sizes.containsValue(true);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                  ),
                                ],
                                color: widget.sizes[widget.keys[index]]
                                    ? Colors.white
                                    : Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: 45,
                              child: Center(
                                child: Text(
                                  widget.keys[index],
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: widget.sizes[widget.keys[index]]
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.sizes[widget.keys[index]],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/images/icons8-correct-100.png",
                              height: 20,
                              width: 20,
                              color: Colors.green, // Change color if needed
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 25, left: 25),
                  child: ButtonWidget(
                    name: "حفظ",
                    height: 60,
                    width: double.infinity,
                    BorderColor: widget.sizes.containsValue(true)
                        ? MAIN_COLOR
                        : Color(0xffEFEDEE),
                    OnClickFunction: () async {
                      if (widget.sizes.containsValue(true)) {
                        if (widget.name == "ملابس نسائيه") {
                          LocalStorage().editSize("womenSizes", widget.sizes);
                        } else if (widget.name == "ملابس رجاليه") {
                          LocalStorage().editSize("menSizes", widget.sizes);
                        } else if (widget.name == "ملابس أطفال") {
                          LocalStorage()
                              .editSize("kidsboysSizes", widget.sizes);
                        } else if (widget.name == "ملابس نسائيه مقاس كبير") {
                          LocalStorage()
                              .editSize("womenPlusSizes", widget.sizes);
                        } else if (widget.name == "مسلزمات اعراس") {
                          LocalStorage()
                              .editSize("Weddings & Events", widget.sizes);
                        }
                        String sizeApi = "";
                        List<String> sizeApp = [];

                        widget.sizes.keys.forEach((k) {
                          if (widget.sizes[k]) {
                            sizeApi = sizeApi + k;
                            sizeApp.add(k);
                          }
                        });
                        List<String> selectedSizes = [];
                        widget.sizes.forEach((key, value) {
                          if (value) {
                            selectedSizes.add(key);
                          }
                        });

                        NavigatorFunction(
                            context,
                            ShowCaseWidget(
                                builder: Builder(
                              builder: (context) => ProductsCategories(
                                SIZES: sizeApp,
                                category_id: widget.main_category,
                                search: false,
                                size: sizeApp.join(', '),
                                containerWidths: widget.containerWidths,
                                main_category: widget.main_category,
                                keys: widget.keys,
                                sizes: widget.sizes,
                                name: widget.name,
                              ),
                            )));
                        LocalStorage().setSizeUser(sizeApp);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool('is_selected_size', true);
                        String? userID = prefs.getString("user_id") ?? "";

                        // Firestore operations
                        SelectedSizeService selectedSizeService =
                            SelectedSizeService();
                        String categoryId =
                            widget.main_category; // Use the actual category ID

                        SelectedSizeModel? existingSelectedSize =
                            await selectedSizeService
                                .getSelectedSizeByUserIdAndCategoryId(
                                    userID.toString(), categoryId);

                        if (existingSelectedSize != null) {
                          // Update the existing record
                          existingSelectedSize.selectedSizes = selectedSizes;
                          await selectedSizeService
                              .updateSelectedSize(existingSelectedSize);
                        } else {
                          // Create a unique ID for the selected size document
                          String selectedSizeId = FirebaseFirestore.instance
                              .collection('selected_sizes')
                              .doc()
                              .id;

                          // Create an instance of SelectedSizeModel
                          SelectedSizeModel newSelectedSize = SelectedSizeModel(
                            id: selectedSizeId,
                            userId: userID.toString(),
                            categoryId: categoryId,
                            selectedSizes: selectedSizes,
                          );

                          // Add the new selected sizes to Firestore
                          await selectedSizeService
                              .addSelectedSize(newSelectedSize);
                        }
                      } else {
                        null;
                      }
                    },
                    BorderRaduis: 10,
                    ButtonColor: widget.sizes.containsValue(true)
                        ? MAIN_COLOR
                        : Color(0xffEFEDEE),
                    NameColor: widget.sizes.containsValue(true)
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    LocalStorage().setSizeUser([]);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('is_selected_size', false);
                    NavigatorFunction(
                        context,
                        ShowCaseWidget(
                            builder: Builder(
                          builder: (context) => ProductsCategories(
                            SIZES: [],
                            category_id: widget.main_category,
                            search: false,
                            size: "null",
                            containerWidths: widget.containerWidths,
                            main_category: widget.main_category,
                            keys: widget.keys,
                            sizes: widget.sizes,
                            name: widget.name,
                          ),
                        )));
                  },
                  child: Text(
                    "تخطي",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            )
          ],
        ));
  }

  Widget categoryMethodForShoes(
      {String image = "",
      String name = "",
      Function? onTaped,
      required bool isSelected}) {
    return InkWell(
      onTap: () {
        onTaped!();
      },
      child: Container(
        width: 200,
        height: 60,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 7,
              blurRadius: 5,
            ),
          ],
          borderRadius: BorderRadius.circular(40),
          color: isSelected ? Colors.black : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              isSelected ? "assets/images/icons8-correct-100.png" : image,
              height: 20,
              width: 20,
            ),
            Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: isSelected ? Colors.white : Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
