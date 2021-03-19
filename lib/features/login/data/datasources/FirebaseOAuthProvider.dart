import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum OAuthProviderEntities { GOOGLE, FACEBOOK }

abstract class FirebaseOAuthProvider {
  Future<AuthCredential> call(OAuthProviderEntities entity);
}

class FirebaseOAuthProviderImpl extends FirebaseOAuthProvider {
  @override
  Future<AuthCredential> call(OAuthProviderEntities entity) async {
    switch (entity) {
      case OAuthProviderEntities.GOOGLE:
        return authCredentialGoogle();
      case OAuthProviderEntities.FACEBOOK:
        return authCredentialFacebook();
      default:
        throw UnimplementedError();
    }
  }

  Future<AuthCredential> authCredentialGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return credential;
  }

  Future<AuthCredential> authCredentialFacebook() async {
    final AccessToken result = await FacebookAuth.instance.login();
    final FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.token);
    return facebookAuthCredential;
  }
}
