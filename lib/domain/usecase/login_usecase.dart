import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/data/request/request.dart';
import 'package:complete_advanced_flutter/domain/model.dart';
import 'package:complete_advanced_flutter/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

import '../../app/functions.dart';
import '../repository.dart';

class LoginUseCase implements BaseUseCase<LoginUsecaseInput, Authentication> {
  Repository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      LoginUsecaseInput input) async {
    DeviceInfo deviceInfo = await getDeviceDetails();

    return await _repository.login(
      LoginRequest(
        input.email,
        input.password,
        deviceInfo.identifier,
        deviceInfo.name,
      ),
    );
  }
}

class LoginUsecaseInput {
  String email;
  String password;

  LoginUsecaseInput(this.email, this.password);
}
