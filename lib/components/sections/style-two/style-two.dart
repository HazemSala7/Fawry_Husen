// import 'package:fawri_app_refactor/components/category_widget/category-widget.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class SectionStyleTwo extends StatelessWidget {
//   const SectionStyleTwo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       child: GridView.builder(
//         scrollDirection: Axis.horizontal,
//         physics: BouncingScrollPhysics(),
//         shrinkWrap: true,
//         itemCount: categories.length,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 6,
//           mainAxisSpacing: 6,
//           childAspectRatio: 1.0,
//         ),
//         itemBuilder: (context, index) {
//           bool isDiscounted = discountCategories
//               .contains(int.parse(categories[index]["id"].toString()));
//           return Stack(
//             children: [
//               CategoryWidget(
//                 setBorder: isDiscounted,
//                 main_category: categories[index]["main_category"],
//                 name: categories[index]["name"],
//                 CateImage: categories[index]["icon"],
//                 CateIcon: categories[index]["icon"],
//                 image: categories[index]["image"],
//               ),
//               if (isDiscounted)
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: Lottie.asset(
//                     "assets/lottie_animations/Animation - 1726302974575.json",
//                     height: 40,
//                     reverse: true,
//                     repeat: true,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
