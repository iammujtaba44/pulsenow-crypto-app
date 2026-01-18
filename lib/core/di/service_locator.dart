import 'package:get_it/get_it.dart';
import 'package:pulsenow_flutter/services/analytics/analytics_service.dart';
import 'package:pulsenow_flutter/services/api/api_service_imp.dart';
import 'package:pulsenow_flutter/services/websocket/websocket_service_imp.dart';

import '../../data/datasources/market_data_local_data_source.dart';
import '../../data/datasources/market_data_remote_data_source.dart';
import '../../data/repositories/market_data_repository_impl.dart';
import '../../domain/repositories/market_data_repository.dart';
import '../../domain/usecases/get_market_data.dart';
import '../../domain/usecases/stream_market_updates.dart';
import '../../providers/market_data_provider/market_data_provider.dart';
import '../../services/analytics/analytics_service_imp.dart';
import '../../services/api/api_service.dart';
import '../../services/websocket/websocket_service.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  if (getIt.isRegistered<ApiServiceImpl>()) return;

  // Core Services
  getIt
    ..registerLazySingleton<ApiService>(() => ApiServiceImpl())
    ..registerLazySingleton<AnalyticsService>(() => AnalyticsServiceImpl())
    ..registerLazySingleton<WebSocketService>(() => WebSocketServiceImpl())

    // Data Sources
    ..registerLazySingleton<MarketDataRemoteDataSource>(
      () => MarketDataRemoteDataSource(getIt<ApiService>()),
    )
    ..registerLazySingleton<MarketDataLocalDataSource>(
      () => MarketDataLocalDataSource(),
    )

    // Repositories
    ..registerLazySingleton<MarketDataRepository>(
      () => MarketDataRepositoryImpl(
        getIt<MarketDataRemoteDataSource>(),
        getIt<MarketDataLocalDataSource>(),
        getIt<WebSocketService>(),
      ),
    )

    // Use Cases
    ..registerLazySingleton<GetMarketDataUseCase>(
      () => GetMarketDataUseCase(getIt<MarketDataRepository>()),
    )
    ..registerLazySingleton<StreamMarketUpdatesUseCase>(
      () => StreamMarketUpdatesUseCase(getIt<MarketDataRepository>()),
    )

    // Providers
    ..registerFactory<MarketDataProvider>(
      () => MarketDataProvider(
        getIt<GetMarketDataUseCase>(),
        getIt<StreamMarketUpdatesUseCase>(),
        getIt<AnalyticsService>(),
      ),
    );
}
