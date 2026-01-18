part of '../market_data_screen.dart';

class MarketAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MarketAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(UiConstants.headerHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(AppStrings.appTitle),
      elevation: 0,
      centerTitle: false,
      actions: const [
        _ThemeToggleButton(),
        _MarketSortDirectionButton(),
      ],
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDarkMode = themeProvider.effectiveDarkMode;
        return IconButton(
          tooltip: isDarkMode ? AppStrings.tooltipSwitchToLight : AppStrings.tooltipSwitchToDark,
          onPressed: themeProvider.toggleTheme,
          icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
        );
      },
    );
  }
}

class _MarketSortDirectionButton extends StatelessWidget {
  const _MarketSortDirectionButton();

  @override
  Widget build(BuildContext context) => Consumer<MarketDataProvider>(
        builder: (context, provider, _) {
          return IconButton(
            tooltip: AppStrings.tooltipToggleSortDirection,
            onPressed: provider.toggleSortDirection,
            icon: Icon(switch (provider.sortDirection) {
              MarketSortDirection.ascending => Icons.arrow_upward,
              MarketSortDirection.descending => Icons.arrow_downward,
            }),
          );
        },
      );
}
