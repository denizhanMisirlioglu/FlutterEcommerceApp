import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_project/repo/ecommerce_dao_repository.dart';
import 'package:flutter_ecommerce_project/repo/sqlite/favorite_dao.dart';
import 'package:flutter_ecommerce_project/repo/sqlite/order_dao.dart';
import 'package:flutter_ecommerce_project/repo/sqlite/user_dao.dart';
import 'package:flutter_ecommerce_project/util/session_manager.dart';
import 'package:flutter_ecommerce_project/view/login_register/login_view.dart';
import 'package:flutter_ecommerce_project/view/login_register/register_view.dart';
import 'package:flutter_ecommerce_project/view/main_app_view.dart';
import 'cubit/auth/account_cubit.dart';
import 'cubit/auth/user_cubit.dart';
import 'cubit/detail_cubit.dart';
import 'cubit/favorite_cubit.dart';
import 'cubit/home_cubit.dart';
import 'cubit/navigation/navigation_cubit.dart';
import 'cubit/order_basket/basket_cubit.dart';
import 'cubit/order_basket/order_cubit.dart';
import 'cubit/search_filter/filter_widget_cubit.dart';
import 'cubit/search_filter/search_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sessionManager = SessionManager();
  final savedUsername = await sessionManager.getUsername();

  runApp(MyApp(initialRoute: savedUsername != null ? '/main' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    // Singleton repository instance
    final EcommerceDaoRepository repo = EcommerceDaoRepository();
    final FavoriteDao favoriteDao = FavoriteDao();
    final OrderDao orderDao = OrderDao();
    final UserDao userDao = UserDao();
    final sessionManager = SessionManager();

    // Cubit'lerin oluşturulması
    final FavoriteCubit favoriteCubit = FavoriteCubit(favoriteDao, sessionManager);
    final AccountCubit accountCubit = AccountCubit(orderDao, sessionManager);
    final OrderCubit orderCubit = OrderCubit(orderDao, sessionManager);
    final BasketCubit basketCubit = BasketCubit(repo, sessionManager);
    final UserCubit userCubit = UserCubit(
      userDao,
      sessionManager,
      favoriteCubit,
      accountCubit,
      orderCubit,
      basketCubit,
    );

    // Kullanıcı oturumu varsa Cubit'leri yükle
    if (initialRoute == '/main') {
      userCubit.loadUserFromSession();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BasketCubit(repo, sessionManager)),
        BlocProvider(create: (context) => DetailCubit(repo, sessionManager)),
        BlocProvider(create: (context) => HomeCubit(repo)),
        BlocProvider(create: (context) => FilterWidgetCubit()),
        BlocProvider(create: (context) => SearchCubit()),
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(create: (context) => orderCubit),
        BlocProvider(create: (context) => favoriteCubit),
        BlocProvider(create: (context) => userCubit),
        BlocProvider(create: (context) => accountCubit),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: initialRoute,
        routes: {
          '/login': (context) => const LoginView(),
          '/register': (context) => const RegisterView(),
          '/main': (context) => const MainAppView(),
        },
      ),
    );
  }
}
