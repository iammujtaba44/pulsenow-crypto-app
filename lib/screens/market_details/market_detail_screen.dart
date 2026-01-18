import 'package:flutter/material.dart';
import 'package:pulsenow_flutter/utils/string_constants.dart';

import '../../models/market_data_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';
import '../../utils/ui_constants.dart';

class MarketDetailScreen extends StatelessWidget {
  const MarketDetailScreen({super.key, required this.item});

  final MarketData item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final changeColor = item.changePercent24h >= 0 ? AppColors.positive : AppColors.negative;
    final trendIcon = item.changePercent24h >= 0 ? Icons.trending_up : Icons.trending_down;

    final stats = [
      _StatItem(label: AppStrings.change24h, value: AppFormatters.formatPrice(item.change24h)),
      _StatItem(label: AppStrings.volume, value: AppFormatters.formatCompact(item.volume)),
      _StatItem(label: AppStrings.marketCap, value: AppFormatters.formatCompact(item.marketCap)),
      _StatItem(label: AppStrings.high24h, value: AppFormatters.formatPrice(item.high24h)),
      _StatItem(label: AppStrings.low24h, value: AppFormatters.formatPrice(item.low24h)),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(item.symbol),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(UiConstants.pagePadding),
          children: [
            const _SectionHeader(title: AppStrings.overview),
            _DetailCard(
              child: _SummaryCard(
                item: item,
                changeColor: changeColor,
                trendIcon: trendIcon,
              ),
            ),
            const SizedBox(height: UiConstants.sectionSpacing),
            const _SectionHeader(title: AppStrings.statistics),
            _DetailCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatsGrid(items: stats),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${AppStrings.lastUpdated}: ${AppFormatters.formatTimestamp(item.lastUpdated)}',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiConstants.cardRadius),
        side: BorderSide(color: theme.disabledColor.withAlpha(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UiConstants.pagePadding),
        child: child,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.item,
    required this.changeColor,
    required this.trendIcon,
  });

  final MarketData item;
  final Color changeColor;
  final IconData trendIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: '${AppStrings.heroTagSymbolPrefix}${item.symbol}',
              child: CircleAvatar(
                backgroundColor: changeColor.withOpacity(0.12),
                child: Text(
                  item.symbol.split('/').first,
                  style: textTheme.titleMedium?.copyWith(
                    color: changeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.description,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: UiConstants.sectionSpacing),
        Row(
          children: [
            Text(
              AppFormatters.formatPrice(item.price),
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            _ChangePill(
              value: AppFormatters.formatPercent(item.changePercent24h),
              color: changeColor,
              icon: trendIcon,
            ),
          ],
        ),
      ],
    );
  }
}

class _ChangePill extends StatelessWidget {
  const _ChangePill({
    required this.value,
    required this.color,
    required this.icon,
  });

  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.items});

  final List<_StatItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 480 ? 3 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.6,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return _StatChip(label: item.label, value: item.value);
          },
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(UiConstants.chipRadius),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
