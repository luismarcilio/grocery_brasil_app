import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/ShareUseCase.dart';
import '../../domain/Shareable.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  ShareBloc({@required this.shareUseCase}) : super(ShareInitial());

  final ShareUseCase shareUseCase;

  @override
  Stream<ShareState> mapEventToState(
    ShareEvent event,
  ) async* {
    if (event is ShareContent) {
      yield* _mapShareTextToState(event);
    }
  }

  Stream<ShareState> _mapShareTextToState(ShareContent event) async* {
    yield Sharing();
    final status = await shareUseCase(Params(shareable: event.shareable));
    yield* status.fold((shareFailure) async* {
      yield ShareError(shareFailure: shareFailure);
    }, (user) async* {
      yield Shared();
    });
  }
}
