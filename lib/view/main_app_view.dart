import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/navigation/navigation_cubit.dart';
import '../cubit/search_filter/search_cubit.dart';
import '../widgets/bars/custom_appbar.dart';
import '../widgets/bars/custom_bottom_navigation_bar.dart';
import 'bottom_screens/account_view.dart';
import 'bottom_screens/home_view.dart';
import 'bottom_screens/favorite_view.dart';
import 'bottom_screens/basket_view.dart';

class MainAppView extends StatelessWidget {
  const MainAppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, activeIndex) {
        return Scaffold(
          appBar: const CustomAppBar(),
          body: IndexedStack(
            index: activeIndex,
            children: [
              HomeView(
                searchQuery: context.watch<SearchCubit>().state,
              ),
              const FavoriteView(),
              const BasketView(),
              const AccountView(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: activeIndex,
            onTap: (index) => context.read<NavigationCubit>().navigateTo(index),
          ),
        );
      },
    );
  }
}
