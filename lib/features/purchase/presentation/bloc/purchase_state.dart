part of 'purchase_bloc.dart';

abstract class PurchaseState extends Equatable {
  const PurchaseState();

  @override
  List<Object> get props => [];
}

class PurchaseInitial extends PurchaseState {}

class PurchaseLoading extends PurchaseState {}

class ResumeListed extends PurchaseState {
  final Stream<List<Purchase>> purchaseStreamList;

  ResumeListed({@required this.purchaseStreamList});
}

class PurchaseError extends PurchaseState {
  final PurchaseFailure purchaseFailure;

  PurchaseError({@required this.purchaseFailure});
}

class PurchaseRetrieved extends PurchaseState {
  final Purchase purchase;

  PurchaseRetrieved({@required this.purchase});
}

class PurchaseDeleted extends PurchaseState {}
