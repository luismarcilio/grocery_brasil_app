import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Unverified
}

class UserRepository extends ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;

  User get user => _user;
  Status get status => _status;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanges);
  }

  Future<void> _onAuthStateChanges(User _user) async {
    _status = _user == null
        ? Status.Unauthenticated
        : !_user.emailVerified && _user.providerData[0].providerId == 'password'
            ? Status.Unverified
            : Status.Authenticated;
    this._user = _user;
    notifyListeners();
  }

  Future logout() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future initialize() async {
    await Firebase.initializeApp();
    return Future.delayed(Duration.zero);
  }

  Future<UserCredential> signInWithEmailAndPassword(
      {String email, String password}) async {
    print('signInWithEmailAndPassword');
    try {
      _status = Status.Authenticating;
      print('before notifyListeners');

      notifyListeners();
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("userCredential: $userCredential");
      return userCredential;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      throw e;
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final LoginResult result = await FacebookAuth.instance.login();
      print("result: $result");
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken.token);
      print("facebookAuthCredential: $facebookAuthCredential");

      final UserCredential userCredential =
          await _auth.signInWithCredential(facebookAuthCredential);
      print("userCredential: $userCredential");
      return userCredential;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      throw e;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      print('googleUser: $googleUser');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('googleAuth: $googleAuth');
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('credential: $credential');
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      print('userCredential: $userCredential');
      return userCredential;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      throw e;
    }
  }

  Future<UserCredential> register({String email, String password}) async {
    print('Register: $email, $password');
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      print('userCredential: $userCredential');
      userCredential.user.sendEmailVerification();
      return userCredential;
    } catch (e) {
      throw e;
    }
  }

  @override
  void dispose() {
    super.dispose();
    print("Called dispose on UserRepository");
  }
}
