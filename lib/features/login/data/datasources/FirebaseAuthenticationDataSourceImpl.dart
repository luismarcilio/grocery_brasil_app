import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, OAuthProvider, User, UserCredential;
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/features/login/data/datasources/FirebaseOAuthProvider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../domain/User.dart' as domain;
import 'AuthenticationDataSource.dart';

class FirebaseAuthenticationDataSourceImpl implements AuthenticationDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseOAuthProvider oAuthProvider;

  FirebaseAuthenticationDataSourceImpl({
    this.firebaseAuth,
    this.oAuthProvider,
  }) : assert(firebaseAuth != null);

  @override
  Future<domain.User> authenticateWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential;
    try {
      userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      throw AuthenticationException(
          messageId: MessageIds.UNEXPECTED,
          message:
              'Autenticação falhou. (Mensagem original: [${e.toString()}])');
    }

    final domain.User user = _getUserFromUserCredential(userCredential.user);
    if (!user.emailVerified) {
      throw AuthenticationException(messageId: MessageIds.EMAIL_NOT_VERIFIED);
    }
    return user;
  }

  @override
  Future<domain.User> authenticateWithFacebook() async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(
              await oAuthProvider(OAuthProviderEntities.FACEBOOK));
      final domain.User user = _getUserFromUserCredential(userCredential.user);
      return user;
    } catch (e) {
      throw AuthenticationException(
          messageId: MessageIds.UNEXPECTED,
          message:
              'Autenticação falhou. (Mensagem original: [${e.toString()}])');
    }
  }

  @override
  Future<domain.User> authenticateWithGoogle() async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(
              await oAuthProvider(OAuthProviderEntities.GOOGLE));
      final domain.User user = _getUserFromUserCredential(userCredential.user);
      return user;
    } catch (e) {
      throw AuthenticationException(
          messageId: MessageIds.UNEXPECTED,
          message:
              'Autenticação falhou. (Mensagem original: [${e.toString()}])');
    }
  }

  @override
  Future<String> getJWT() async {
    try {
      final jwt = await firebaseAuth.currentUser.getIdToken(true);
      log(jwt);
      return jwt;
    } catch (e) {
      throw AuthenticationException(
          messageId: MessageIds.UNEXPECTED,
          message: 'Operação falhou. (Mensagem original: [${e.toString()}])');
    }
  }

  domain.User _getUserFromUserCredential(User firebaseUser) {
    if (firebaseUser == null) {
      return null;
    }
    if (firebaseUser.providerData[0]?.providerId != 'password') {
      return domain.User(
          email: firebaseUser.email,
          userId: firebaseUser.uid,
          emailVerified: true);
    }
    //else
    return domain.User(
        email: firebaseUser.email,
        userId: firebaseUser.uid,
        emailVerified: firebaseUser.emailVerified);
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw AuthenticationException(
          messageId: MessageIds.UNEXPECTED,
          message: 'Operação falhou. (Mensagem original: [${e.toString()}])');
    }
  }

  @override
  Stream<domain.User> asyncAuthentication() async* {
    yield* firebaseAuth
        .authStateChanges()
        .asyncMap((firebaseUser) => _getUserFromUserCredential(firebaseUser));
  }

  @override
  String getUserId() {
    return firebaseAuth.currentUser.uid;
  }

  @override
  Future<void> resetPasswrod(String email) {
    return firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<domain.User> authenticateWithApple() async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(
              await oAuthProvider(OAuthProviderEntities.APPLE));
      final domain.User user = _getUserFromUserCredential(userCredential.user);
      return user;
    } catch (e) {
      throw AuthenticationException(
          messageId: MessageIds.UNEXPECTED,
          message:
              'Autenticação falhou. (Mensagem original: [${e.toString()}])');
    }
  }
}
