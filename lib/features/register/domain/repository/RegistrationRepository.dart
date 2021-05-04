import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../domain/User.dart';
import '../../data/datasource/RegistrationDataSource.dart';

abstract class RegistrationRepository {
  final RegistrationDataSource registrationDataSource;

  RegistrationRepository({this.registrationDataSource});

  Future<Either<RegistrationFailure, User>> registerWithEmailAndPassword(
      {String email, String password});
}
