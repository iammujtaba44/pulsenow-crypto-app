part of '../market_data_screen.dart';

class _MarketSearchBar extends StatelessWidget {
  const _MarketSearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(UiConstants.pagePadding),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(onPressed: onClear, icon: const Icon(Icons.close)),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainer,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UiConstants.cardRadius),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UiConstants.cardRadius),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
            ),
          ),
        ),
      ),
    );
  }
}
