part of '../market_data_screen.dart';

class _MarketStatusBanner extends StatelessWidget {
  const _MarketStatusBanner();

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketDataProvider>(
      builder: (context, provider, _) {
        if (!provider.isFromCache || provider.lastUpdated == null) {
          return const SizedBox.shrink();
        }

        final colorScheme = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UiConstants.pagePadding,
            vertical: 8,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(UiConstants.cardRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.cloud_off, size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${AppStrings.offlineDataUpdatedPrefix}'
                      '${AppFormatters.formatTimestamp(provider.lastUpdated!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
