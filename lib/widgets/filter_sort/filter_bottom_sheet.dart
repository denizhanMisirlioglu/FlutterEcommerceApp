import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/search_filter/filter_widget_cubit.dart';
import '../../util/design/app_colors.dart';
import '../../util/design/app_text_styles.dart';

class FilterBottomSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final bool isCategory;

  const FilterBottomSheet({
    Key? key,
    required this.title,
    required this.options,
    required this.isCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filterType = isCategory ? "selectedCategories" : "selectedBrands";

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.headline3),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const Divider(color: AppColors.divider),
          Expanded(
            child: BlocBuilder<FilterWidgetCubit, Map<String, dynamic>>(
              builder: (context, state) {
                final selectedOptions = List<String>.from(state[filterType] ?? []);
                return ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return CheckboxListTile(
                      title: Text(option, style: AppTextStyles.bodyText1),
                      value: selectedOptions.contains(option),
                      activeColor: AppColors.primary,
                      onChanged: (bool? isSelected) {
                        if (isSelected == true) {
                          context.read<FilterWidgetCubit>().addOption(filterType, option);
                        } else {
                          context.read<FilterWidgetCubit>().removeOption(filterType, option);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Oval kenarlar
                  ),
                ),
                onPressed: () {
                  context.read<FilterWidgetCubit>().clearOptions(filterType);
                },
                child: Text(
                  "Clear",
                  style: AppTextStyles.button, // Siyah yazı
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary ,
                  padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Oval kenarlar
                  ),
                ),
                onPressed: () {
                  final selectedCategories = context.read<FilterWidgetCubit>().getSelectedOptions("selectedCategories");
                  final selectedBrands = context.read<FilterWidgetCubit>().getSelectedOptions("selectedBrands");

                  context.read<HomeCubit>().applyFilters(
                    categories: selectedCategories,
                    brands: selectedBrands,
                  );

                  Navigator.of(context).pop();
                },
                child: Text(
                  "Apply",
                  style: AppTextStyles.button,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
