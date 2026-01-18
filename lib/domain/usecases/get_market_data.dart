import 'package:either_dart/either.dart';
import 'package:pulsenow_flutter/core/errors/app_exceptions.dart';

import '../repositories/market_data_repository.dart';

class GetMarketDataUseCase {
  final MarketDataRepository _repository;

  const GetMarketDataUseCase(this._repository);

  Future<Either<AppException, MarketDataFetchResult>> call({bool forceRefresh = false}) =>
      _repository.fetchMarketData(forceRefresh: forceRefresh);
}
