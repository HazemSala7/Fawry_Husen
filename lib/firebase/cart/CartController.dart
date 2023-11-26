import 'package:cloud_firestore/cloud_firestore.dart';
import '../../server/functions/functions.dart';
import 'CartFirebaseModel.dart';

class CartService {
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('carts');

  Future<void> addToCart(CartFirebaseModel cartItem) {
    return cartCollection.doc(cartItem.id).set(cartItem.toMap());
  }

  Future<void> updateCartItem(CartFirebaseModel cartItem) {
    return cartCollection.doc(cartItem.id).update(cartItem.toMap());
  }

  Future<List<String>> getUserIdsByProductId(String productId) async {
    QuerySnapshot snapshot =
        await cartCollection.where('product_id', isEqualTo: productId).get();

    List<String> userIds =
        snapshot.docs.map((doc) => doc['user_token'] as String).toList();
    return userIds;
  }

  Future<void> deleteCartItemFunction(String cartItemId) {
    return cartCollection.doc(cartItemId).delete();
  }

  Future<void> deleteCartItem(String userId, String productId) async {
    // Perform a query to find the document with matching user_id and product_id
    QuerySnapshot snapshot = await cartCollection
        .where('user_id', isEqualTo: userId)
        .where('product_id', isEqualTo: productId)
        .get();

    // Check if there's a matching document and delete it
    if (snapshot.size > 0) {
      // We assume there's only one document that matches the query, but you can handle multiple results if needed
      String documentId = snapshot.docs[0].id;
      await cartCollection.doc(documentId).delete();
    }
  }

  Future<void> deleteAllCartItemsForUser(String userId) async {
    // Query the cart collection to find documents with matching user_id
    QuerySnapshot querySnapshot =
        await cartCollection.where('user_id', isEqualTo: userId).get();

    // Iterate through the query snapshot and delete each document
    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      await deleteCartItemFunction(docSnapshot.id);
    }
  }

  Stream<List<CartFirebaseModel>> getCartItems() {
    return cartCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              CartFirebaseModel.fromMap(doc.data() as Map<String, dynamic>?))
          .toList();
    });
  }

  Stream<List<CartFirebaseModel>> getCartItemsForUser(String userId) {
    return cartCollection
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              CartFirebaseModel.fromMap(doc.data() as Map<String, dynamic>?))
          .toList();
    });
  }

  Future<List<CartFirebaseModel>> getCartItemsWithDetails(String userId) async {
    // Fetch cart items from Firestore
    List<CartFirebaseModel> cartItems = await cartCollection
        .where('user_id', isEqualTo: userId)
        .get()
        .then((querySnapshot) async {
      List<CartFirebaseModel> items = [];
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String productId = docSnapshot['product_id'];
        // Fetch additional details for each cart item using the API
        Map<String, dynamic> productDetails =
            await getSpeceficProduct(productId);
        if (productDetails.isNotEmpty) {
          items.add(
            CartFirebaseModel(
                id: docSnapshot.id, product_id: '', user_id: '', user_token: ""

                // Store other details from the productDetails map
                // ...
                ),
          );
        }
      }
      return items;
    });

    return cartItems;
  }
}
