import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../domain/Purchase.dart';
import '../services/PurchaseRepository.dart';

part 'purchase_event.dart';
part 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final PurchaseRepository _purchaseRepository;
  PurchaseBloc(this._purchaseRepository) : super(PurchaseInitial());

  @override
  Stream<PurchaseState> mapEventToState(
    PurchaseEvent event,
  ) async* {
    if (event is LoadResumePurchaseByUserId) {
      yield* _mapLoadResumePurchaseByUserIdToState(event.userId);
    } else if (event is LoadPurchaseByAccessKey) {
      yield* _mapLoadPurchaseByAccessKeyToState(event.accessKey);
    }
  }

  Stream<PurchaseState> _mapLoadResumePurchaseByUserIdToState(
      String userId) async* {
    print('_mapLoadResumePurchaseByUserIdToState');
    yield PurchaseLoading();
    try {
      final purchases = _purchaseRepository.getResumePurchaseForUser(userId);
      yield PurchaseResumeLoaded(purchases);
    } catch (error) {
      print('error: $error');
      yield PurchaseError();
    }
  }

  Stream<PurchaseState> _mapLoadPurchaseByAccessKeyToState(
      String docId) async* {
    print('_mapLoadPurchaseByAccessKeyToState');

    yield PurchaseLoading();
    try {
      final purchase = await _purchaseRepository.getPurchaseFromDocId(docId);
      print('yield PurchaseLoaded(purchase)');
      yield PurchaseLoaded(purchase);
    } catch (error) {
      print('error: $error');
      yield PurchaseError();
    }
  }
}
