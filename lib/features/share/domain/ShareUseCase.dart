import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareFormat.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import 'ShareService.dart';

class ShareUseCase implements UseCase<bool, Params> {
  final ShareService shareService;

  ShareUseCase({@required this.shareService});

  @override
  Future<Either<ShareFailure, bool>> call(Params params) async {
    try {
      final outcome =
          await shareService.shareContent(params.content, params.format);
      if (!outcome) {
        return Left(
          ShareFailure(
              messageId: MessageIds.UNEXPECTED,
              message: 'Erro ao compartilhar'),
        );
      }
      return (Right(outcome));
    } catch (e) {
      return Left(
        ShareFailure(
          messageId: MessageIds.UNEXPECTED,
          message: e.toString(),
        ),
      );
    }
  }
}

class Params extends Equatable {
  final dynamic content;
  final ShareFormat format;

  Params({@required this.content, @required this.format});

  @override
  // TODO: implement props
  List<Object> get props => [content, format];
}
