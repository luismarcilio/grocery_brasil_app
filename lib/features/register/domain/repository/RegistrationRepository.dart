import 'package:dartz/dartz.dart';
import 'package:grocery_brasil_app/features/register/data/datasource/RegistrationDataSource.dart';

import '../../../../core/errors/failures.dart';
import '../../../../domain/User.dart';

abstract class RegistrationRepository {
  final RegistrationDataSource registrationDataSource;

  RegistrationRepository({this.registrationDataSource});

  Future<Either<RegistrationFailure, User>> registerWithEmailAndPassword(
      {String email, String password});
}
