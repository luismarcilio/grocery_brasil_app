part of 'purchase_bloc.dart';

@immutable
abstract class PurchaseEvent extends Equatable {}

class LoadResumePurchaseByUserId extends PurchaseEvent {
  final String userId;
  LoadResumePurchaseByUserId(this.userId);
  @override
  List<Object> get props => [userId];
}

class LoadPurchaseByAccessKey extends PurchaseEvent {
  final String accessKey;
  LoadPurchaseByAccessKey(this.accessKey);
  @override
  List<Object> get props => [accessKey];
}

class SavePurchaseByQrCodeUrl extends PurchaseEvent {
  final String qrCodeUrl;
  SavePurchaseByQrCodeUrl(this.qrCodeUrl);
  @override
  List<Object> get props => [qrCodeUrl];
}
