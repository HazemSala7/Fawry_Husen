// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

// // Check for initial dynamic link on app load
// Future<void> retrieveDynamicLink() async {
//   final PendingDynamicLinkData? data =
//       await FirebaseDynamicLinks.instance.getInitialLink();
//   handleLink(data?.link);
// }

// // Listen for dynamic links
// void setupDynamicLinks() async {
//   FirebaseDynamicLinks.instance.onLink(
//       onSuccess: (PendingDynamicLinkData? dynamicLink) async {
//     handleLink(dynamicLink?.link);
//   }, onError: (OnLinkErrorException e) async {
//     print('Dynamic Link Failed: ${e.message}');
//   });
// }

// // Handle the received dynamic link
// void handleLink(Uri? link) {
//   if (link != null) {
//     // Navigate to the specified route based on the dynamic link
//     print('Received dynamic link: $link');
//     // Implement your logic here to navigate or process the link
//   }
// }
