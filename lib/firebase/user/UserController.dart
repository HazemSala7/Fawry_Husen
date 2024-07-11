import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserModel.dart';

class UserService {
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserItem cartItem) {
    return cartCollection.doc(cartItem.id).set(cartItem.toMap());
  }

  Future<void> deleteUserById(String userId) {
    return cartCollection.doc(userId).delete();
  }

  Future<void> updateUser(UserItem userItem,
      {bool updateBirthdate = true, bool updateGender = true}) async {
    try {
      Map<String, dynamic> updateData = {};
      if (updateBirthdate) {
        updateData['gender'] = userItem.gender;
      }
      if (updateGender) {
        updateData['birthdate'] = userItem.birthdate;
      }
      updateData['name'] = userItem.name;
      updateData['address'] = userItem.address;
      updateData['area'] = userItem.area;
      updateData['city'] = userItem.city;
      updateData['email'] = userItem.email;
      updateData['phone'] = userItem.phone;
      updateData['token'] = userItem.token;
      updateData['password'] = userItem.password;
      print("userItem.id");
      print(userItem.id);
      await cartCollection.doc(userItem.id).update(updateData);
    } catch (e) {
      print('Error updating user: $e');
    }
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
