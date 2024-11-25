import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/search_filter/search_cubit.dart';
import '../../cubit/navigation/navigation_cubit.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(120.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFA6E4FF), Color(0xFFB3FFCC)], // Eski mavi-yeşil tonları
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10), // Üst kısımda daha fazla boşluk
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const SizedBox(
                height: 10,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    context.read<SearchCubit>().setSearchQuery(query);
                    context.read<NavigationCubit>().navigateTo(0); // Home sekmesine git
                  } else {
                    context.read<SearchCubit>().clearSearchQuery(); // Arama sorgusunu temizle
                  }
                },
                decoration: InputDecoration(
                  hintText: "Search Product",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.grey),
                    onPressed: () {
                      // Arama sorgusunu sıfırla ve HomeView'i yeniden başlat
                      context.read<SearchCubit>().clearSearchQuery();
                      context.read<NavigationCubit>().navigateTo(0); // Home sekmesine git
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(8.0),
                ),
              ),
            ),
            const SizedBox(height: 12), // Arama widgetının altında ek bir boşluk
          ],
        ),
      ),
    );
  }
}
