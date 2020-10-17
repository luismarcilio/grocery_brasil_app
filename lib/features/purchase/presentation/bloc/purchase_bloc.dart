import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_brasil_app/features/purchase/domain/GetFullPurchaseUseCase.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../domain/Purchase.dart';
import '../../domain/ListPurchasesUseCase.dart';

part 'purchase_event.dart';
part 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  PurchaseBloc(
      {@required this.listPurchasesUseCase,
      @required this.getFullPurchaseUseCase})
      : super(PurchaseInitial());

  final ListPurchasesUseCase listPurchasesUseCase;
  final GetFullPurchaseUseCase getFullPurchaseUseCase;

  @override
  Stream<PurchaseState> mapEventToState(
    PurchaseEvent event,
  ) async* {
    print("PurchaseEvent: $event");
    if (event is ListResumeEvent) {
      yield PurchaseLoading();
      final list = await listPurchasesUseCase(NoParams());
      yield* list.fold((purchaseFailure) async* {
        yield PurchaseError(purchaseFailure: purchaseFailure);
      }, (purchaseStreamList) async* {
        yield ResumeListed(purchaseStreamList: purchaseStreamList);
      });
    } else if (event is GetPurchaseByIdEvent) {
      yield PurchaseLoading();
      final result =
          await getFullPurchaseUseCase(Params(purchaseId: event.purchaseId));
      yield* result.fold((purchaseFailure) async* {
        yield PurchaseError(purchaseFailure: purchaseFailure);
      }, (purchase) async* {
        yield PurchaseRetrieved(purchase: purchase);
      });
    }
  }
}
