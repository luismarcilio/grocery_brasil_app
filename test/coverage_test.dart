import 'package:grocery_brasil_app/domain/Purchase.dart';
import 'package:grocery_brasil_app/domain/Product.dart';
import 'package:grocery_brasil_app/domain/Address.dart';
import 'package:grocery_brasil_app/domain/Unity.dart';
import 'package:grocery_brasil_app/domain/PurchaseItem.dart';
import 'package:grocery_brasil_app/domain/FiscalNote.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/business/NfProviderConfig.dart';
import 'package:grocery_brasil_app/business/State.dart';
import 'package:grocery_brasil_app/main.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/core/usecases/asyncUseCase.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/widgets/AppTheme.dart';
import 'package:grocery_brasil_app/core/widgets/registration_widgets.dart';
import 'package:grocery_brasil_app/core/utils/Utils.dart';
import 'package:grocery_brasil_app/injection_container.dart';
import 'package:grocery_brasil_app/services/UserRepository.dart';
import 'package:grocery_brasil_app/services/apiConfiguration.dart';
import 'package:grocery_brasil_app/services/authentication/userRepository.dart';
import 'package:grocery_brasil_app/services/LocationServices.dart';
import 'package:grocery_brasil_app/services/ProductsRepository.dart';
import 'package:grocery_brasil_app/services/PurchaseRepository.dart';
import 'package:grocery_brasil_app/services/FiscalNoteBusiness.dart';
import 'package:grocery_brasil_app/services/qrcode.dart';
import 'package:grocery_brasil_app/cubit/user_cubit.dart';
import 'package:grocery_brasil_app/screens/SetupAccountScreen.dart';
import 'package:grocery_brasil_app/screens/produtosScreen.dart';
import 'package:grocery_brasil_app/screens/FullFiscalNote.dart';
import 'package:grocery_brasil_app/screens/notasFiscaisScreen.dart';
import 'package:grocery_brasil_app/screens/common/loading.dart';
import 'package:grocery_brasil_app/screens/common/dialog.dart';
import 'package:grocery_brasil_app/screens/common/NfItemCard.dart';
import 'package:grocery_brasil_app/screens/common/CommonWidgets.dart';
import 'package:grocery_brasil_app/screens/dashboard.dart';
import 'package:grocery_brasil_app/screens/UserAddress.dart';
import 'package:grocery_brasil_app/utils.dart';
import 'package:grocery_brasil_app/features/scanQrCode/domain/QRCodeRepository.dart';
import 'package:grocery_brasil_app/features/scanQrCode/domain/ScanQrCodeUseCase.dart';
import 'package:grocery_brasil_app/features/scanQrCode/domain/QRCode.dart';
import 'package:grocery_brasil_app/features/scanQrCode/data/QRCodeRepositoryImpl.dart';
import 'package:grocery_brasil_app/features/scanQrCode/data/QRCodeScanner.dart';
import 'package:grocery_brasil_app/features/scanQrCode/data/QRCodeScannerImpl.dart';
import 'package:grocery_brasil_app/features/scanQrCode/presentation/bloc/qrcode_bloc.dart';
import 'package:grocery_brasil_app/features/scanQrCode/presentation/pages/qrcodeScreen.dart';
import 'package:grocery_brasil_app/features/initialize_firebase/bloc/initialize_firebase_bloc.dart';
import 'package:grocery_brasil_app/features/initialize_firebase/presentation/pages/initialize_firebase.dart';
import 'package:grocery_brasil_app/features/register/domain/usecases/register.dart';
import 'package:grocery_brasil_app/features/register/domain/repository/RegistrationRepository.dart';
import 'package:grocery_brasil_app/features/register/data/datasource/FirebaseRegistrationDataSourceImpl.dart';
import 'package:grocery_brasil_app/features/register/data/datasource/RegistrationDataSource.dart';
import 'package:grocery_brasil_app/features/register/data/repository/RegistrationRepositoryImpl.dart';
import 'package:grocery_brasil_app/features/register/presentation/bloc/registration_bloc_bloc.dart';
import 'package:grocery_brasil_app/features/register/presentation/pages/register.dart';
import 'package:grocery_brasil_app/features/purchase/domain/GetFullPurchaseUseCase.dart';
import 'package:grocery_brasil_app/features/purchase/domain/ListPurchasesUseCase.dart';
import 'package:grocery_brasil_app/features/purchase/presentation/bloc/purchase_bloc.dart';
import 'package:grocery_brasil_app/features/purchase/presentation/widgets/NFScreensWidgets.dart';
import 'package:grocery_brasil_app/features/purchase/presentation/pages/ResumePurchaseList.dart';
import 'package:grocery_brasil_app/features/purchase/presentation/pages/FullPurchaseList.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AuthenticateWithEmailAndPassword.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AsyncLogin.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AuthenticateWithFacebook.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/Logout.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AuthenticateWithGoogle.dart';
import 'package:grocery_brasil_app/features/login/domain/repositories/AuthenticationRepository.dart';
import 'package:grocery_brasil_app/features/login/data/datasources/FirebaseAuthenticationDataSourceImpl.dart';
import 'package:grocery_brasil_app/features/login/data/datasources/FirebaseOAuthProvider.dart';
import 'package:grocery_brasil_app/features/login/data/datasources/AuthenticationDataSource.dart';
import 'package:grocery_brasil_app/features/login/data/repositories/AuthenticationRepositoryImpl.dart';
import 'package:grocery_brasil_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:grocery_brasil_app/features/login/presentation/pages/login.dart';
import 'package:grocery_brasil_app/features/common/domain/PurchaseRepository.dart';
import 'package:grocery_brasil_app/features/common/data/PurchaseDataSource.dart';
import 'package:grocery_brasil_app/features/common/data/PurchaseRepositoryImpl.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/SaveNfUseCase.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/model/NfHtmlFromSite.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/model/NFProcessData.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/GetDetailsfromUrlUseCase.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/DetailsFromUrlRepository.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/data/NFDataSource.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/data/DetailsFromUrlDataSource.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/data/DetailsFromUrlRepositoryImpl.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/presentation/bloc/readnf_bloc.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/presentation/pages/ReadNfScreen.dart';
import 'package:grocery_brasil_app/features/apisDetails/domain/BackendFunctionsConfiguration.dart';
import 'package:grocery_brasil_app/features/apisDetails/data/FunctionsDetailsDataSource.dart';
import 'package:grocery_brasil_app/bloc_backup/product_bloc.dart';
import 'package:grocery_brasil_app/bloc_backup/purchase_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
void main () {test('', () {});}