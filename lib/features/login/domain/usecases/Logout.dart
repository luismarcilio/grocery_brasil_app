import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../service/AuthenticationService.dart';

class Logout implements UseCase<bool, NoParams> {
  final AuthenticationService authenticationService;

  Logout({@required this.authenticationService});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authenticationService.logout();
  }
}
