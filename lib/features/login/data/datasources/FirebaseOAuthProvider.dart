import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum OAuthProviderEntities { GOOGLE, FACEBOOK, APPLE }

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
      case OAuthProviderEntities.APPLE:
        return authCredentialApple();
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

  Future<AuthCredential> authCredentialApple() async {
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
      ],
      nonce: nonce,
    );
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    return oauthCredential;
  }

  String _generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
