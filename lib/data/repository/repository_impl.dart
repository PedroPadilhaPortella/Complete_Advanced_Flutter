import 'package:complete_advanced_flutter/data/data_source/data_source.dart';
import 'package:complete_advanced_flutter/data/mapper/mapper.dart';
import 'package:complete_advanced_flutter/data/network/network_info.dart';
import 'package:complete_advanced_flutter/domain/model.dart';
import 'package:complete_advanced_flutter/data/request/request.dart';
import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/domain/repository.dart';
import 'package:dartz/dartz.dart';

class RepositortImpl extends Repository {
  RemoteDataSource _remoteDataSource;
  NetworkInfo _networkInfo;

  RepositortImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      final response = await _remoteDataSource.login(loginRequest);
      if (response.status == 0) {
        return Right(response.toDomain());
      } else {
        return Left(Failure(409,
            response.message ?? 'An bussiness error on api side ocurred.'));
      }
    } else {
      return Left(Failure(
          409, 'An error ocurred, please check your internet connection.'));
    }
  }
}
