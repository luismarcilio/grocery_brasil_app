part of 'purchase_bloc.dart';

@immutable
abstract class PurchaseState extends Equatable {}

class PurchaseInitial extends PurchaseState {
  @override
  List<Object> get props => [];
}

class PurchaseLoading extends PurchaseState {
  @override
  List<Object> get props => [];
}

class PurchaseSaving extends PurchaseState {
  @override
  List<Object> get props => [];
}

class PurchaseResumeLoaded extends PurchaseState {
  final Stream<List<Purchase>> resumes;
  @override
  List<Object> get props => [resumes];

  PurchaseResumeLoaded(this.resumes);
}

class PurchaseLoaded extends PurchaseState {
  final Purchase purchase;
  @override
  List<Object> get props => [purchase];

  PurchaseLoaded(this.purchase);
}

class PurchaseError extends PurchaseState {
  @override
  List<Object> get props => [];
}
