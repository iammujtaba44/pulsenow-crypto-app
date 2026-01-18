import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsenow_flutter/services/analytics/analytics_service.dart';

import 'package:pulsenow_flutter/core/di/service_locator.dart';
import 'package:pulsenow_flutter/models/market_data_model.dart';
import 'package:pulsenow_flutter/providers/theme_provider.dart';
import '../../providers/market_data_provider/market_data_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';
import '../../utils/string_constants.dart';
import '../../utils/ui_constants.dart';
import '../market_details/market_detail_screen.dart';

part 'widgets/market_app_bar.dart';
part 'widgets/market_search_bar.dart';
part 'widgets/market_sort_bar.dart';
part 'widgets/market_status_bar.dart';
part 'widgets/market_states.dart';
part 'widgets/market_data_loaded_state_view.dart';

class MarketDataScreen extends StatefulWidget {
  const MarketDataScreen({super.key});

  @override
  State<MarketDataScreen> createState() => _MarketDataScreenState();
}

class _MarketDataScreenState extends State<MarketDataScreen> {
  final TextEditingController _controller = TextEditingController();
  final AnalyticsService _analytics = getIt<AnalyticsService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _analytics.trackScreenView(AppStrings.screenMarketData);
      context.read<MarketDataProvider>().init();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MarketAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _MarketSearchBar(
              controller: _controller,
              onChanged: (value) => context.read<MarketDataProvider>().updateQuery(value),
              onClear: () {
                _controller.clear();
                context.read<MarketDataProvider>().clearQuery();
              },
            ),
            const _MarketSortBar(),
            const _MarketStatusBanner(),
            const Expanded(child: _MarketDataContent()),
          ],
        ),
      ),
    );
  }
}

class _MarketDataContent extends StatelessWidget {
  const _MarketDataContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketDataProvider>(builder: (context, provider, _) {
      final content = switch (provider.state) {
        MarketDataState.loading => const _LoadingStateView(),
        MarketDataState.error => _ErrorStateView(message: provider.error, onRetry: provider.refresh),
        MarketDataState.empty => _EmptyStateView(onRefresh: provider.refresh),
        MarketDataState.success => _MarketDataLoadedStateView(
            items: provider.marketData,
            onRefresh: provider.refresh,
          ),
        MarketDataState.initial => const SizedBox.shrink(),
      };

      return AnimatedSwitcher(
        duration: UiConstants.shortAnimation,
        child: content,
      );
    });
  }
}
