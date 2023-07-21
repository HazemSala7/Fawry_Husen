import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class FawriFirebaseUser {
  FawriFirebaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;
}

FawriFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<FawriFirebaseUser> fawriFirebaseUserStream() => FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<FawriFirebaseUser>(
      (user) {
        currentUser = FawriFirebaseUser(user);
        return currentUser!;
      },
    );
