import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/addressing/data/AddressingDataSource.dart';
import 'features/addressing/data/AddressingDataSourceImpl.dart';
import 'features/addressing/data/AddressingServiceAdapter.dart';
import 'features/addressing/data/GPSServiceAdapter.dart';
import 'features/addressing/data/GeohashServiceAdapter.dart';
import 'features/addressing/data/GeohashServiceAdapterImpl.dart';
import 'features/addressing/data/GeolocatorGPSServiceAdapter.dart';
import 'features/addressing/data/GoogleAddressingServiceAdapter.dart';
import 'features/admob/domain/AddFactory.dart';
import 'features/admob/domain/DecorateListWithAds.dart';
import 'features/admob/domain/DecorateListWithBanner.dart';
import 'features/admob/widgets/BannerInline.dart';
import 'features/apisDetails/data/FunctionsDetailsDataSource.dart';
import 'features/logging/data/CrashlyticsLogAdapter.dart';
import 'features/logging/data/LogAdatper.dart';
import 'features/logging/domain/InitializeLog.dart';
import 'features/logging/domain/Log.dart';
import 'features/logging/domain/LogService.dart';
import 'features/login/data/datasources/AuthenticationDataSource.dart';
import 'features/login/data/datasources/FirebaseAuthenticationDataSourceImpl.dart';
import 'features/login/data/datasources/FirebaseOAuthProvider.dart';
import 'features/login/data/repositories/AuthenticationRepositoryImpl.dart';
import 'features/login/domain/repositories/AuthenticationRepository.dart';
import 'features/login/domain/service/AuthenticationService.dart';
import 'features/login/domain/service/AuthenticationServiceImpl.dart';
import 'features/login/domain/usecases/AsyncLogin.dart';
import 'features/login/domain/usecases/AuthenticateWithApple.dart';
import 'features/login/domain/usecases/AuthenticateWithEmailAndPassword.dart';
import 'features/login/domain/usecases/AuthenticateWithFacebook.dart';
import 'features/login/domain/usecases/AuthenticateWithGoogle.dart';
import 'features/login/domain/usecases/Logout.dart';
import 'features/login/domain/usecases/ResetPassword.dart';
import 'features/login/presentation/bloc/login_bloc.dart';
import 'features/product/data/ProductDataSource.dart';
import 'features/product/data/ProductDataSourceImpl.dart';
import 'features/product/data/ProductRepositoryImpl.dart';
import 'features/product/data/TextSearchDataSource.dart';
import 'features/product/data/TextSearchDataSourceImpl.dart';
import 'features/product/data/TextSearchRepositoryImpl.dart';
import 'features/product/domain/GetMinPriceProductByUserByProductIdUseCase.dart';
import 'features/product/domain/GetPricesProductByUserByProductIdUseCase.dart';
import 'features/product/domain/ListProductsByTextUseCase.dart';
import 'features/product/domain/ProductRepository.dart';
import 'features/product/domain/ProductService.dart';
import 'features/product/domain/ProductServiceImpl.dart';
import 'features/product/domain/TextSearchRepository.dart';
import 'features/product/presentation/bloc/product_prices_bloc.dart';
import 'features/product/presentation/bloc/products_bloc.dart';
import 'features/purchase/data/PurchaseDataSource.dart';
import 'features/purchase/data/PurchaseRepositoryImpl.dart';
import 'features/purchase/domain/DeletePurchaseUseCase.dart';
import 'features/purchase/domain/GetFullPurchaseUseCase.dart';
import 'features/purchase/domain/ListPurchasesUseCase.dart';
import 'features/purchase/domain/PurchaseRepository.dart';
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
import 'features/scanQrCode/presentation/bloc/qrcode_bloc.dart';
import 'features/secrets/data/SecretDataSource.dart';
import 'features/secrets/data/SecretDataSourceImpl.dart';
import 'features/secrets/data/SecretsServiceImpl.dart';
import 'features/secrets/domain/SecretsService.dart';
import 'features/share/domain/ShareAdapter.dart';
import 'features/share/domain/ShareAdapterImpl.dart';
import 'features/share/domain/ShareService.dart';
import 'features/share/domain/ShareServiceImpl.dart';
import 'features/share/domain/ShareUseCase.dart';
import 'features/share/presentation/bloc/share_bloc.dart';
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
      authenticateWithApple: sl(),
      logout: sl(),
      asyncLogin: sl(),
      createUser: sl(),
      initializeLog: sl(),
      resetPassword: sl()));

  sl.registerFactory(() => RegistrationBloc(registrationUseCase: sl()));
  sl.registerFactory(() => QrcodeBloc());
  sl.registerFactory(
      () => ReadnfBloc(getDetailsfromUrlUseCase: sl(), saveNfUseCase: sl()));
  sl.registerFactory(() => PurchaseBloc(
      listPurchasesUseCase: sl(),
      getFullPurchaseUseCase: sl(),
      deletePurchaseUseCase: sl()));
  sl.registerFactory(
      () => UserBloc(updateUserUseCase: sl(), getUserUseCase: sl()));
  sl.registerFactory(() => ProductsBloc(listProductsByTextUseCase: sl()));
  sl.registerFactory(() => ProductPricesBloc(
      getMinPriceProductByUserByProductIdUseCase: sl(),
      getPricesProductByUserByProductIdUseCase: sl()));
  sl.registerFactory(() => ShareBloc(shareUseCase: sl()));
  //UseCases
  sl.registerLazySingleton(
      () => AuthenticateWithEmailAndPassword(authenticationService: sl()));
  sl.registerLazySingleton(
      () => AuthenticateWithFacebook(authenticationService: sl()));
  sl.registerLazySingleton(
      () => AuthenticateWithGoogle(authenticationService: sl()));
  sl.registerLazySingleton(
      () => AuthenticateWithApple(authenticationService: sl()));
  sl.registerLazySingleton(() => Logout(authenticationService: sl()));
  sl.registerLazySingleton(() => AsyncLogin(authenticationService: sl()));
  sl.registerLazySingleton(() => RegistrationUseCase(sl()));
  sl.registerLazySingleton(() => GetDetailsfromUrlUseCase(repository: sl()));
  sl.registerLazySingleton(() => SaveNfUseCase(purchaseRepository: sl()));
  sl.registerLazySingleton(() => ListPurchasesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetFullPurchaseUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeletePurchaseUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton(() => GetUserUseCase(userService: sl()));
  sl.registerLazySingleton(
      () => ListProductsByTextUseCase(productService: sl()));
  sl.registerLazySingleton(
      () => GetMinPriceProductByUserByProductIdUseCase(productService: sl()));
  sl.registerLazySingleton(
      () => GetPricesProductByUserByProductIdUseCase(productService: sl()));
  sl.registerLazySingleton(() => InitializeLog(logService: sl()));
  sl.registerSingleton(() => Log(logService: sl()));
  sl.registerLazySingleton(() => ShareUseCase(shareService: sl()));
  sl.registerLazySingleton(() => ResetPassword(authenticationRepository: sl()));
//Services
  sl.registerLazySingleton<SecretsService>(
      () => SecretsServiceImpl(secretDataSource: sl()));
  sl.registerLazySingleton<ProductService>(() => ProductServiceImpl(
      textSearchRepository: sl(),
      productRepository: sl(),
      userService: sl(),
      gPSServiceAdapter: sl(),
      geohashServiceAdapter: sl()));
  sl.registerLazySingleton<UserService>(() =>
      UserServiceImpl(userRepository: sl(), authenticationRepository: sl()));
  sl.registerLazySingleton<AuthenticationService>(() =>
      AuthenticationServiceImpl(
          authenticationRepository: sl(),
          addressingDataSource: sl(),
          userService: sl()));
  sl.registerLazySingleton<LogService>(() => LogServiceImpl(logAdapter: sl()));
  sl.registerLazySingleton<ShareService>(
      () => ShareServiceImpl(shareAdapter: sl()));
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

  sl.registerLazySingleton<ProductDataSource>(
      () => ProductDataSourceImpl(firebaseFirestore: sl()));
  //Adapter

  sl.registerLazySingleton<GPSServiceAdapter>(
      () => GeolocatorGPSServiceAdapter(geolocatorPlatform: sl()));
  sl.registerLazySingleton<AddressingServiceAdapter>(() =>
      GoogleAddressingServiceAdapter(
          authenticationDataSource: sl(),
          gPSServiceAdapter: sl(),
          httpClient: sl(),
          secretsService: sl()));
  sl.registerLazySingleton<GeohashServiceAdapter>(
      () => GeohashServiceAdapterImpl(geoHasher: sl()));

  sl.registerLazySingleton<LogAdapter>(
      () => CrashlyticsLogAdapter(firebaseCrashlytics: sl()));
  sl.registerLazySingleton<ShareAdapter>(
      () => ShareAdapterImpl(flutterShareStub: FlutterShareStub()));
  // Presentation
  sl.registerLazySingleton<DecorateListWithAds<Hero, BannerAdd>>(
      () => DecorateHeroListWithBanner());
  sl.registerLazySingleton<DecorateListWithAds<Widget, BannerAdd>>(
      () => DecorateWidgetListWithBanner());
  sl.registerLazySingleton<AddFactory<BannerInline>>(() => BannerAdd());

  //External
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => GeolocatorPlatform.instance);
  sl.registerLazySingleton(() => GeoHasher());
  sl.registerLazySingleton(() => FirebaseCrashlytics.instance);
}

void initFeatures() {}
