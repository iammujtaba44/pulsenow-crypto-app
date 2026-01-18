import '../../models/market_data_model.dart';
import '../../services/api/api_service.dart';

class MarketDataRemoteDataSource {
  final ApiService _apiService;

  const MarketDataRemoteDataSource(this._apiService);

  Future<List<MarketData>> fetchMarketData() async {
    final response = await _apiService.getMarketData();
    return response.map((json) => MarketData.fromJson(json)).toList();
  }
}
