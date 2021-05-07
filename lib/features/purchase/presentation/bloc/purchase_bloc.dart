import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../domain/Purchase.dart';
import '../../domain/DeletePurchaseUseCase.dart' as deletePurchase;
import '../../domain/GetFullPurchaseUseCase.dart';
import '../../domain/ListPurchasesUseCase.dart';

part 'purchase_event.dart';
part 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  PurchaseBloc(
      {@required this.listPurchasesUseCase,
      @required this.getFullPurchaseUseCase,
      @required this.deletePurchaseUseCase})
      : super(PurchaseInitial());

  final ListPurchasesUseCase listPurchasesUseCase;
  final GetFullPurchaseUseCase getFullPurchaseUseCase;
  final deletePurchase.DeletePurchaseUseCase deletePurchaseUseCase;

  @override
  Stream<PurchaseState> mapEventToState(
    PurchaseEvent event,
  ) async* {
    print("PurchaseEvent: $event");
    if (event is ListResumeEvent) {
      yield* _mapListResumeEventToState(event);
    } else if (event is GetPurchaseByIdEvent) {
      yield* _mapGetPurchaseByIdEventToState(event);
    } else if (event is DeletePurchaseEvent) {
      yield* _mapDeletePurchaseEventToState(event);
    }
  }

  Stream<PurchaseState> _mapListResumeEventToState(
      ListResumeEvent event) async* {
    yield PurchaseLoading();
    final list = await listPurchasesUseCase(NoParams());
    yield* list.fold((purchaseFailure) async* {
      yield PurchaseError(purchaseFailure: purchaseFailure);
    }, (purchaseStreamList) async* {
      yield ResumeListed(purchaseStreamList: purchaseStreamList);
    });
  }

  Stream<PurchaseState> _mapGetPurchaseByIdEventToState(
      GetPurchaseByIdEvent event) async* {
    yield PurchaseLoading();
    final result =
        await getFullPurchaseUseCase(Params(purchaseId: event.purchaseId));
    yield* result.fold((purchaseFailure) async* {
      yield PurchaseError(purchaseFailure: purchaseFailure);
    }, (purchase) async* {
      yield PurchaseRetrieved(purchase: purchase);
    });
  }

  Stream<PurchaseState> _mapDeletePurchaseEventToState(
      DeletePurchaseEvent event) async* {
    yield PurchaseLoading();
    final result = await deletePurchaseUseCase(
        deletePurchase.Params(purchaseId: event.purchaseId));
    yield* result.fold((purchaseFailure) async* {
      yield PurchaseError(purchaseFailure: purchaseFailure);
    }, (purchase) async* {
      yield PurchaseDeleted();
    });
  }
}
