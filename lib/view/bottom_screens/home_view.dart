import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/search_filter/filter_widget_cubit.dart';
import '../../model/product/product.dart';
import '../../widgets/bars/custom_second_appbar.dart';
import '../../widgets/cards/product_card.dart';
import '../../util/scroll_controller_handler.dart';
import '../../widgets/filter_sort/sorting_bottom_sheet.dart';
import '../../util/session_manager.dart';

class HomeView extends StatefulWidget {
  final String? searchQuery; // Arama sorgusu parametresi

  const HomeView({Key? key, this.searchQuery}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final ScrollControllerHandler _scrollHandler;
  bool _showSecondAppBar = true;

  @override
  void initState() {
    super.initState();

    // Ürünleri yükle ve filtre uygula
    context.read<HomeCubit>().getProducts().then((_) {
      final categories = context.read<HomeCubit>().getAvailableCategories();
      final brands = context.read<HomeCubit>().getAvailableBrands();
      context.read<FilterWidgetCubit>().initializeFilters(
        categories: categories,
        brands: brands,
      );

      _applySearchQuery();
    });

    // Scroll kontrolü ayarla
    _scrollHandler = ScrollControllerHandler(
      onVisibilityChanged: (isVisible) {
        setState(() {
          _showSecondAppBar = isVisible;
        });
      },
    );
  }

  @override
  void didUpdateWidget(covariant HomeView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Arama sorgusu değiştiğinde filtreleme yap
    if (widget.searchQuery != oldWidget.searchQuery) {
      if (widget.searchQuery == null || widget.searchQuery!.isEmpty) {
        context.read<HomeCubit>().resetFilters(); // Tüm ürünleri yeniden listele
      } else {
        context.read<HomeCubit>().searchProducts(widget.searchQuery!); // Arama uygula
      }
    }
  }

  void _applySearchQuery() {
    if (widget.searchQuery == null || widget.searchQuery!.isEmpty) {
      context.read<HomeCubit>().resetFilters(); // Listeyi eski haline getir
    } else {
      context.read<HomeCubit>().searchProducts(widget.searchQuery!); // Arama uygula
    }
  }

  @override
  void dispose() {
    _scrollHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionManager = SessionManager(); // SessionManager örneği oluşturuldu

    return Scaffold(
      body: BlocBuilder<HomeCubit, List<Product>>(
        builder: (context, productList) {
          if (productList.isEmpty) { // Ortak Filtreleme sonucu ürün bulunamazsa
            context.read<HomeCubit>().resetFilters(); // Listeyi eski haline getir

            // Snackbar'ı mevcut frame tamamlandıktan sonra göster
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "No products found",
                    style: TextStyle(fontSize: 16),
                  ),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(16),
                ),
              );
            });
          }


          return Stack(
            children: [
              // Ürün Listesi
              CustomScrollView(
                controller: _scrollHandler.controller,
                slivers: [
                  // Üstte boşluk oluştur
                  SliverToBoxAdapter(
                    child: SizedBox(height: 30),
                  ),
                  // Ürün Listesi
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: productList.length,
                        itemBuilder: (context, index) {
                          final product = productList[index];
                          return ProductCard(
                            key: ValueKey(product.id), // Benzersiz Key
                            product: product,
                            sessionManager: sessionManager, // SessionManager sağlandı
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // Dinamik İkinci AppBar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: BlocBuilder<FilterWidgetCubit, Map<String, dynamic>>(
                  builder: (context, filterState) {
                    return CustomSecondAppBar(
                      isVisible: _showSecondAppBar,
                      onFilterPrice: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => SortingBottomSheet(
                            onSortSelected: (selectedSorting) {
                              context.read<FilterWidgetCubit>().setSorting(selectedSorting);
                              context.read<HomeCubit>().sortProductsBy(selectedSorting);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
