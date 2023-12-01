import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/data/request/request.dart';
import 'package:complete_advanced_flutter/domain/model.dart';
import 'package:complete_advanced_flutter/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

import '../repository.dart';

class RegisterUseCase
    implements BaseUseCase<RegisterUsecaseInput, Authentication> {
  Repository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
    RegisterUsecaseInput input,
  ) async {
    return await _repository.register(
      RegisterRequest(
        input.userName,
        input.email,
        input.password,
        input.mobileNumber,
        input.countryMobileCode,
        input.profilePicture,
      ),
    );
  }
}

class RegisterUsecaseInput {
  String userName;
  String email;
  String password;
  String mobileNumber;
  String countryMobileCode;
  String profilePicture;

  RegisterUsecaseInput(
    this.userName,
    this.email,
    this.password,
    this.mobileNumber,
    this.countryMobileCode,
    this.profilePicture,
  );
}
