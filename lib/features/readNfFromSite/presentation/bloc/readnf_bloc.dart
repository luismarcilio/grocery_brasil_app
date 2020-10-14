import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/GetDetailsfromUrlUseCase.dart' as GetDetailsfromUrlUseCase;
import '../../domain/SaveNfUseCase.dart' as SaveNfUseCase;
import '../../domain/model/NFProcessData.dart';
import '../../domain/model/NfHtmlFromSite.dart';

part 'readnf_event.dart';
part 'readnf_state.dart';

class ReadnfBloc extends Bloc<ReadnfEvent, ReadnfState> {
  ReadnfBloc(
      {@required this.saveNfUseCase, @required this.getDetailsfromUrlUseCase})
      : super(ReadnfInitial());

  final GetDetailsfromUrlUseCase.GetDetailsfromUrlUseCase
      getDetailsfromUrlUseCase;
  final SaveNfUseCase.SaveNfUseCase saveNfUseCase;

  @override
  Stream<ReadnfState> mapEventToState(
    ReadnfEvent event,
  ) async* {
    if (event is GetDetailsFromUrl) {
      yield GetDetailsFromUrlDoing();
      final result = await getDetailsfromUrlUseCase(
          GetDetailsfromUrlUseCase.Params(url: event.url));
      yield* result.fold((nFProcessDataFailure) async* {
        yield GetDetailsFromUrlError(failure: nFProcessDataFailure);
      }, (nFProcessData) async* {
        yield GetDetailsFromUrlDone(nFProcessData: nFProcessData);
      });
    } else if (event is SaveNfEvent) {
      yield SaveNfDoing();
      final result = await saveNfUseCase(
          SaveNfUseCase.Params(nfHtmlFromSite: event.nfHtmlFromSite));
      yield* result.fold((purchaseFailure) async* {
        yield SaveNfError(purchaseFailure: purchaseFailure);
      }, (nFProcessData) async* {
        yield SaveNfDone();
      });
    }
  }
}
