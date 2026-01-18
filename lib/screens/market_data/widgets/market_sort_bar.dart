part of '../market_data_screen.dart';

class _MarketSortBar extends StatelessWidget {
  const _MarketSortBar();

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketDataProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: UiConstants.pagePadding),
          child: Row(
            children: [
              const Icon(Icons.tune, size: 18),
              const SizedBox(width: 8),
              PopupMenuButton<MarketSortField>(
                onSelected: provider.updateSortField,
                itemBuilder: (context) => MarketSortField.values
                    .map(
                      (field) => PopupMenuItem(
                        value: field,
                        child: Text(field.label),
                      ),
                    )
                    .toList(),
                child: Row(
                  children: [
                    Text(
                      provider.sortField.label,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Icon(Icons.expand_more),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                provider.sortDirection == MarketSortDirection.ascending
                    ? AppStrings.sortAscending
                    : AppStrings.sortDescending,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}
