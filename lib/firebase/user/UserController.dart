import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserModel.dart';

class UserService {
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserItem cartItem) {
    return cartCollection.doc(cartItem.id).set(cartItem.toMap());
  }

  Future<void> updateUser(UserItem cartItem) {
    return cartCollection.doc(cartItem.id).update(cartItem.toMap());
  }

  Future<void> deleteUser(String cartItemId) {
    return cartCollection.doc(cartItemId).delete();
  }

  Stream<List<UserItem>> getUsers() {
    return cartCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserItem.fromMap(doc.data() as Map<String, dynamic>?))
          .toList();
    });
  }
}
