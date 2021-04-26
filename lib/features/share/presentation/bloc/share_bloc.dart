import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareFormat.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareUseCase.dart';
import 'package:grocery_brasil_app/features/share/domain/Shareable.dart';
import 'package:meta/meta.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  ShareBloc({@required this.shareUseCase}) : super(ShareInitial());

  final ShareUseCase shareUseCase;

  @override
  Stream<ShareState> mapEventToState(
    ShareEvent event,
  ) async* {
    if (event is ShareText) {
      yield* _mapShareTextToState(event);
    }
  }

  Stream<ShareState> _mapShareTextToState(ShareText event) async* {
    yield Sharing();
    final status = await shareUseCase(Params(
        shareable:
            Shareable(content: event.textToShare, format: ShareFormat.TEXT)));
    yield* status.fold((shareFailure) async* {
      yield ShareError(shareFailure: shareFailure);
    }, (user) async* {
      yield Shared();
    });
  }
}
