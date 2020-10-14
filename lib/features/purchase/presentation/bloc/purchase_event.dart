part of 'purchase_bloc.dart';

abstract class PurchaseEvent extends Equatable {
  const PurchaseEvent();

  @override
  List<Object> get props => [];
}

class ListResumeEvent extends PurchaseEvent {}

class GetPurchaseByIdEvent extends PurchaseEvent {
  final String purchaseId;

  GetPurchaseByIdEvent({@required this.purchaseId});
}
