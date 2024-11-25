import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/search_filter/filter_widget_cubit.dart';
import '../../util/design/app_text_styles.dart';
import '../../util/design/app_colors.dart';

class SortingBottomSheet extends StatelessWidget {
  final Function(String) onSortSelected;

  const SortingBottomSheet({
    super.key, // Simplified shorthand for passing the key
    required this.onSortSelected,
  });


  @override
  Widget build(BuildContext context) {
    final sortingOptions = ["Recommended", "Lowest Price", "Highest Price"];
    final selectedSorting = context.watch<FilterWidgetCubit>().state["selectedSorting"];

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sorting Options",
                style: AppTextStyles.headline3,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(color: AppColors.divider),
          ListView.builder(
            shrinkWrap: true,
            itemCount: sortingOptions.length,
            itemBuilder: (context, index) {
              final option = sortingOptions[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio<String>(
                  value: option,
                  groupValue: selectedSorting,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    context.read<FilterWidgetCubit>().setSorting(value!);
                    onSortSelected(value);
                  },
                ),
                title: Text(
                  option,
                  style: AppTextStyles.bodyText1,
                ),
                onTap: () {
                  context.read<FilterWidgetCubit>().setSorting(option);
                  onSortSelected(option);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
