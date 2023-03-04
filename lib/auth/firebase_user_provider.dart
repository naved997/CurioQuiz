import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class CurioQuizFirebaseUser {
  CurioQuizFirebaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;
}

CurioQuizFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<CurioQuizFirebaseUser> curioQuizFirebaseUserStream() =>
    FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<CurioQuizFirebaseUser>(
      (user) {
        currentUser = CurioQuizFirebaseUser(user);
        return currentUser!;
      },
    );
