import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:grocery_brasil_app/features/scanQrCode/data/QRCodeRepositoryImpl.dart';
import 'package:grocery_brasil_app/features/scanQrCode/data/QRCodeScannerImpl.dart';
import 'features/scanQrCode/data/QRCodeScanner.dart';
import 'features/scanQrCode/domain/ScanQrCodeUseCase.dart';

import 'features/login/data/datasources/AuthenticationDataSource.dart';
import 'features/login/data/datasources/FirebaseAuthenticationDataSourceImpl.dart';
import 'features/login/data/datasources/FirebaseOAuthProvider.dart';
import 'features/login/data/repositories/AuthenticationRepositoryImpl.dart';
import 'features/login/domain/repositories/AuthenticationRepository.dart';
import 'features/login/domain/usecases/AsyncLogin.dart';
import 'features/login/domain/usecases/AuthenticateWithEmailAndPassword.dart';
import 'features/login/domain/usecases/AuthenticateWithFacebook.dart';
import 'features/login/domain/usecases/AuthenticateWithGoogle.dart';
import 'features/login/domain/usecases/Logout.dart';
import 'features/login/presentation/bloc/login_bloc.dart';
import 'features/register/data/datasource/FirebaseRegistrationDataSourceImpl.dart';
import 'features/register/data/datasource/RegistrationDataSource.dart';
import 'features/register/data/repository/RegistrationRepositoryImpl.dart';
import 'features/register/domain/repository/RegistrationRepository.dart';
import 'features/register/domain/usecases/register.dart';
import 'features/register/presentation/bloc/registration_bloc_bloc.dart';
import 'features/scanQrCode/domain/QRCodeRepository.dart';
import 'features/scanQrCode/presentation/bloc/qrcode_bloc.dart';

final sl = GetIt.instance;

void init() {
  //Features
  //Bloc
  sl.registerFactory(() => LoginBloc(
      authenticateWithEmailAndPassword: sl(),
      authenticateWithFacebook: sl(),
      authenticateWithGoogle: sl(),
      logout: sl(),
      asyncLogin: sl()));

  sl.registerFactory(() => RegistrationBloc(registrationUseCase: sl()));
  sl.registerFactory(() => QrcodeBloc(scanQRCode: sl()));

  //UseCases
  sl.registerLazySingleton(() => AuthenticateWithEmailAndPassword(sl()));
  sl.registerLazySingleton(() => AuthenticateWithFacebook(sl()));
  sl.registerLazySingleton(() => AuthenticateWithGoogle(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => AsyncLogin(sl()));
  sl.registerLazySingleton(() => RegistrationUseCase(sl()));
  sl.registerLazySingleton(() => ScanQRCode(sl()));

  //Repository
  sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(authenticationDataSource: sl()));
  sl.registerLazySingleton<RegistrationRepository>(
      () => RegistrationRepositoryImpl(registrationDataSource: sl()));
//Datasources
  sl.registerLazySingleton<AuthenticationDataSource>(() =>
      FirebaseAuthenticationDataSourceImpl(
          firebaseAuth: sl(), oAuthProvider: sl()));
  sl.registerLazySingleton<RegistrationDataSource>(
      () => FirebaseRegistrationDataSourceImpl(firebaseAuth: sl()));

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseOAuthProvider>(
      () => FirebaseOAuthProviderImpl());

  sl.registerLazySingleton<QRCodeRepository>(
      () => QRCodeRepositoryImpl(qrCodeScanner: sl()));
  sl.registerLazySingleton<QRCodeScanner>(
      () => QRCodeScannerImpl(barcodeScannerStub: sl()));
  sl.registerLazySingleton<BarcodeScannerStub>(() => BarcodeScannerStub());

  //External
}

void initFeatures() {}
