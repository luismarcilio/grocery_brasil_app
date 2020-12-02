import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/addressing/data/AddressingDataSource.dart';
import 'features/addressing/data/AddressingDataSourceImpl.dart';
import 'features/addressing/data/AddressingServiceAdapter.dart';
import 'features/addressing/data/GPSServiceAdapter.dart';
import 'features/addressing/data/GeolocatorGPSServiceAdapter.dart';
import 'features/addressing/data/GoogleAddressingServiceAdapter.dart';
import 'features/apisDetails/data/FunctionsDetailsDataSource.dart';
import 'features/common/data/PurchaseDataSource.dart';
import 'features/common/data/PurchaseRepositoryImpl.dart';
import 'features/common/domain/PurchaseRepository.dart';
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
import 'features/product/data/ProductRepositoryImpl.dart';
import 'features/product/data/TextSearchDataSource.dart';
import 'features/product/data/TextSearchDataSourceImpl.dart';
import 'features/product/data/TextSearchRepositoryImpl.dart';
import 'features/product/domain/ListProductsByTextUseCase.dart';
import 'features/product/domain/ProductRepository.dart';
import 'features/product/domain/ProductService.dart';
import 'features/product/domain/ProductServiceImpl.dart';
import 'features/product/domain/TextSearchRepository.dart';
import 'features/product/presentation/bloc/products_bloc.dart';
import 'features/purchase/domain/GetFullPurchaseUseCase.dart';
import 'features/purchase/domain/ListPurchasesUseCase.dart';
import 'features/purchase/presentation/bloc/purchase_bloc.dart';
import 'features/readNfFromSite/data/DetailsFromUrlDataSource.dart';
import 'features/readNfFromSite/data/DetailsFromUrlRepositoryImpl.dart';
import 'features/readNfFromSite/data/NFDataSource.dart';
import 'features/readNfFromSite/domain/DetailsFromUrlRepository.dart';
import 'features/readNfFromSite/domain/GetDetailsfromUrlUseCase.dart';
import 'features/readNfFromSite/domain/SaveNfUseCase.dart';
import 'features/readNfFromSite/presentation/bloc/readnf_bloc.dart';
import 'features/register/data/datasource/FirebaseRegistrationDataSourceImpl.dart';
import 'features/register/data/datasource/RegistrationDataSource.dart';
import 'features/register/data/repository/RegistrationRepositoryImpl.dart';
import 'features/register/domain/repository/RegistrationRepository.dart';
import 'features/register/domain/usecases/register.dart';
import 'features/register/presentation/bloc/registration_bloc_bloc.dart';
import 'features/scanQrCode/data/QRCodeRepositoryImpl.dart';
import 'features/scanQrCode/data/QRCodeScanner.dart';
import 'features/scanQrCode/data/QRCodeScannerImpl.dart';
import 'features/scanQrCode/domain/QRCodeRepository.dart';
import 'features/scanQrCode/domain/ScanQrCodeUseCase.dart';
import 'features/scanQrCode/presentation/bloc/qrcode_bloc.dart';
import 'features/secrets/data/SecretDataSource.dart';
import 'features/secrets/data/SecretDataSourceImpl.dart';
import 'features/secrets/data/SecretsServiceImpl.dart';
import 'features/secrets/domain/SecretsService.dart';
import 'features/user/data/FirbaseUserDataSource.dart';
import 'features/user/data/UserDataSource.dart';
import 'features/user/data/UserRepositoryImpl.dart';
import 'features/user/domain/CreateUserUseCase.dart';
import 'features/user/domain/GetUserUseCase.dart';
import 'features/user/domain/UpdateUserUseCase.dart';
import 'features/user/domain/UserRepository.dart';
import 'features/user/domain/UserService.dart';
import 'features/user/domain/UserServiceImpl.dart';
import 'features/user/presentation/bloc/user_bloc.dart';

final sl = GetIt.instance;

void init() {
  //Features
  //Bloc
  sl.registerFactory(() => LoginBloc(
      authenticateWithEmailAndPassword: sl(),
      authenticateWithFacebook: sl(),
      authenticateWithGoogle: sl(),
      logout: sl(),
      asyncLogin: sl(),
      createUser: sl()));

  sl.registerFactory(() => RegistrationBloc(registrationUseCase: sl()));
  sl.registerFactory(() => QrcodeBloc(scanQRCode: sl()));
  sl.registerFactory(
      () => ReadnfBloc(getDetailsfromUrlUseCase: sl(), saveNfUseCase: sl()));
  sl.registerFactory(() =>
      PurchaseBloc(listPurchasesUseCase: sl(), getFullPurchaseUseCase: sl()));
  sl.registerFactory(
      () => UserBloc(updateUserUseCase: sl(), getUserUseCase: sl()));
  sl.registerFactory(() => ProductsBloc(listProductsByTextUseCase: sl()));
  //UseCases
  sl.registerLazySingleton(() => AuthenticateWithEmailAndPassword(sl()));
  sl.registerLazySingleton(() => AuthenticateWithFacebook(sl()));
  sl.registerLazySingleton(() => AuthenticateWithGoogle(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => AsyncLogin(sl()));
  sl.registerLazySingleton(() => RegistrationUseCase(sl()));
  sl.registerLazySingleton(() => ScanQRCode(sl()));
  sl.registerLazySingleton(() => GetDetailsfromUrlUseCase(repository: sl()));
  sl.registerLazySingleton(() => SaveNfUseCase(purchaseRepository: sl()));
  sl.registerLazySingleton(() => ListPurchasesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetFullPurchaseUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton(() => GetUserUseCase(userService: sl()));
  sl.registerLazySingleton(
      () => ListProductsByTextUseCase(productService: sl()));
//Services
  sl.registerLazySingleton<SecretsService>(
      () => SecretsServiceImpl(secretDataSource: sl()));
  sl.registerLazySingleton<ProductService>(() => ProductServiceImpl(
      textSearchRepository: sl(), productRepository: sl(), userService: sl()));
  sl.registerLazySingleton<UserService>(() =>
      UserServiceImpl(userRepository: sl(), authenticationRepository: sl()));
  //Repository
  sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(authenticationDataSource: sl()));
  sl.registerLazySingleton<RegistrationRepository>(
      () => RegistrationRepositoryImpl(registrationDataSource: sl()));
  sl.registerLazySingleton<DetailsFromUrlRepository>(
      () => DetailsFromUrlRepositoryImpl(detailsFromUrldataSource: sl()));
  sl.registerLazySingleton<PurchaseRepository>(() => PurchaseRepositoryImpl(
      purchaseDataSource: sl(),
      authenticationDataSource: sl(),
      nfDataSource: sl()));
  sl.registerLazySingleton<UserRepository>(() =>
      UserRepositoryImpl(userDataSource: sl(), addressingDataSource: sl()));
  sl.registerLazySingleton<TextSearchRepository>(
      () => TextSearchRepositoryImpl(textSearchDataSource: sl()));
  sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(productDataSource: sl()));
//Datasources
  sl.registerLazySingleton<UserDataSource>(
      () => FirbaseUserDataSource(firebaseFirestore: sl()));
  sl.registerLazySingleton<AddressingDataSource>(() => AddressingDataSourceImpl(
      gPSServiceAdapter: sl(), addressingServiceAdapter: sl()));

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

  sl.registerLazySingleton<FunctionsDetailsDataSource>(
      () => FunctionsDetailsDataSourceImpl(firebaseFirestore: sl()));

  sl.registerLazySingleton<DetailsFromUrlDataSource>(() =>
      DetailsFromUrlDataSourceImpl(
          authenticationDataSource: sl(),
          functionsDetailsDataSource: sl(),
          httpClient: sl()));

  sl.registerLazySingleton<NFDataSource>(() => NFDataSourceImpl(
      functionsDetailsDataSource: sl(),
      authenticationDataSource: sl(),
      httpClient: sl()));

  sl.registerLazySingleton<PurchaseDataSource>(
      () => PurchaseDataSourceImpl(firebaseFirestore: sl()));

  sl.registerLazySingleton<SecretDataSource>(() => SecretDataSourceImpl(
      functionsDetailsDataSource: sl(),
      authenticationDataSource: sl(),
      httpClient: sl()));
  sl.registerLazySingleton<TextSearchDataSource>(
      () => TextSearchDataSourceImpl(httpClient: sl(), secretsService: sl()));
  //Adapter

  sl.registerLazySingleton<GPSServiceAdapter>(
      () => GeolocatorGPSServiceAdapter(geolocatorPlatform: sl()));
  sl.registerLazySingleton<AddressingServiceAdapter>(() =>
      GoogleAddressingServiceAdapter(
          authenticationDataSource: sl(),
          gPSServiceAdapter: sl(),
          httpClient: sl(),
          secretsService: sl()));

  //External

  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => GeolocatorPlatform.instance);
}

void initFeatures() {}
