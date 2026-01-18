part of '../market_data_screen.dart';

class _MarketDataLoadedStateView extends StatelessWidget {
  const _MarketDataLoadedStateView({required this.items, required this.onRefresh});
  final List<MarketData> items;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(UiConstants.pagePadding),
        itemExtent: UiConstants.listItemExtent,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _MarketDataItem(key: ValueKey(item.symbol), item: item);
        },
      ),
    );
  }
}

class _MarketDataItem extends StatelessWidget {
  const _MarketDataItem({super.key, required this.item});
  final MarketData item;

  @override
  Widget build(BuildContext context) {
    final changeColor = item.changePercent24h >= 0 ? AppColors.positive : AppColors.negative;
    return TweenAnimationBuilder<double>(
      duration: UiConstants.shortAnimation,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 6),
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiConstants.cardRadius),
          side: BorderSide(color: Theme.of(context).disabledColor.withAlpha(12)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(UiConstants.cardRadius),
          onTap: () {
            context.read<MarketDataProvider>().trackDetailOpened(item);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MarketDetailScreen(item: item),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Hero(
                  tag: '${AppStrings.heroTagSymbolPrefix}${item.symbol}',
                  child: CircleAvatar(
                    backgroundColor: changeColor.withOpacity(0.12),
                    child: Text(
                      item.symbol.split('/').first,
                      style: TextStyle(color: changeColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.symbol,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppFormatters.formatPrice(item.price),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppFormatters.formatPercent(item.changePercent24h),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: changeColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
