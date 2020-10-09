import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../domain/User.dart';
import '../../domain/repository/RegistrationRepository.dart';
import '../datasource/RegistrationDataSource.dart';

class RegistrationRepositoryImpl extends RegistrationRepository {
  final RegistrationDataSource registrationDataSource;

  RegistrationRepositoryImpl({this.registrationDataSource});

  @override
  Future<Either<RegistrationFailure, User>> registerWithEmailAndPassword(
      {String email, String password}) async {
    try {
      User user = await registrationDataSource.registerWithEmailAndPassword(
          email: email, password: password);
      return Right(user);
    } on RegistrationException catch (e) {
      RegistrationFailure registrationFailure = RegistrationFailure(
          messageId: MessageIds.UNEXPECTED,
          message:
              'Falha ao criar usuário (mensagem original: [${e.message}])');
      return Left(registrationFailure);
    }
  }
}
