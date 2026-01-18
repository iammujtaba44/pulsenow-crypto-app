import '../../models/market_data_model.dart';
import '../repositories/market_data_repository.dart';

class StreamMarketUpdatesUseCase {
  final MarketDataRepository _repository;

  const StreamMarketUpdatesUseCase(this._repository);

  Stream<MarketDataUpdate> call() => _repository.streamMarketUpdates();
}
