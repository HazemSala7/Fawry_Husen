// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'favourite.dart';

// class FavouriteService {
//   final CollectionReference favouriteCollection =
//       FirebaseFirestore.instance.collection('wishlists');

//   Future<void> addToWish(FavouriteItem favouriteItem) {
//     return favouriteCollection.doc(favouriteItem.id).set(favouriteItem.toMap());
//   }

//   Future<void> updateWishItem(FavouriteItem favouriteItem) {
//     return favouriteCollection
//         .doc(favouriteItem.id)
//         .update(favouriteItem.toMap());
//   }

//   Future<void> deleteWishItem(String userId, String productId) async {
//     // Perform a query to find the document with matching user_id and product_id
//     QuerySnapshot snapshot = await favouriteCollection
//         .where('user_id', isEqualTo: userId)
//         .where('product_id', isEqualTo: productId)
//         .get();

//     // Check if there's a matching document and delete it
//     if (snapshot.size > 0) {
//       // We assume there's only one document that matches the query, but you can handle multiple results if needed
//       String documentId = snapshot.docs[0].id;
//       await favouriteCollection.doc(documentId).delete();
//     }
//   }

//   Stream<List<FavouriteItem>> getWishItems(String userId) {
//     return favouriteCollection
//         .where('user_id', isEqualTo: userId)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs
//           .map((doc) =>
//               FavouriteItem.fromMap(doc.data() as Map<String, dynamic>?))
//           .toList();
//     });
//   }
// }
