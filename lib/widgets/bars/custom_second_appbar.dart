import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/search_filter/filter_widget_cubit.dart';
import '../buttons/filter_button.dart';
import '../filter_sort/filter_bottom_sheet.dart';

class CustomSecondAppBar extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onFilterPrice;

  const CustomSecondAppBar({
    Key? key,
    required this.isVisible,
    required this.onFilterPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isVisible ? 1.0 : 0.0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFA0E4FF).withOpacity(0.85),
                  Color(0xFFB3FFD9).withOpacity(0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterButton(
                  icon: Icons.sort_outlined,
                  label: "Price",
                  onTap: onFilterPrice,
                ),
                FilterButton(
                  icon: Icons.branding_watermark_outlined,
                  label: "Brand",
                  onTap: () {
                    _showFilterBottomSheet(
                      context: context,
                      title: "Select Brand",
                      isCategory: false,
                      optionsKey: "availableBrands",
                    );
                  },
                ),
                FilterButton(
                  icon: Icons.category_outlined,
                  label: "Category",
                  onTap: () {
                    _showFilterBottomSheet(
                      context: context,
                      title: "Select Category",
                      isCategory: true,
                      optionsKey: "availableCategories",
                    );
                  },
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }

  /// Helper function to show filter bottom sheet
  void _showFilterBottomSheet({
    required BuildContext context,
    required String title,
    required bool isCategory,
    required String optionsKey,
  }) {
    final options =
    context.read<FilterWidgetCubit>().state[optionsKey] as List<String>;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        title: title,
        options: options,
        isCategory: isCategory,
      ),
    );
  }
}
