import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repo/sqlite/user_dao.dart';
import '../../util/session_manager.dart';
import '../favorite_cubit.dart';
import '../auth/account_cubit.dart';
import '../order_basket/basket_cubit.dart';
import '../order_basket/order_cubit.dart';

class UserCubit extends Cubit<Map<String, dynamic>?> {
  final UserDao _userDao;
  final SessionManager _sessionManager;
  final FavoriteCubit _favoriteCubit;
  final AccountCubit _accountCubit;
  final OrderCubit _orderCubit;
  final BasketCubit _basketCubit;

  UserCubit(
    this._userDao,
    this._sessionManager,
    this._favoriteCubit,
    this._accountCubit,
    this._orderCubit,
    this._basketCubit,
      ) : super(null);

  // Kullanıcı giriş yap
  Future<bool> login(String username, String password) async {
    final isPasswordCorrect = await _userDao.verifyPassword(username, password);
    if (isPasswordCorrect) {
      final user = await _userDao.getUserByUserName(username);
      if (user != null) {
        emit(user); // Kullanıcı bilgilerini emit et
        await _sessionManager.saveUsername(username); // Oturumu kaydet
        print("UserCubit: Logged in successfully. Global username -> $username");

        // Kullanıcı giriş yaptıktan sonra ilgili cubit'leri baştan yükle
        await _favoriteCubit.loadFavorites(); // Favori ürünleri yükle
        await _accountCubit.loadAccountInfo(); // Hesap bilgilerini yükle
        await _orderCubit.loadOrders(); // Siparişleri yükle
        await _basketCubit.getBasketItems(); // Sepetteki ürünleri yükle

        return true;
      }
    }
    print("UserCubit: Login failed for username -> $username");
    return false;
  }

  // Kullanıcı çıkış yap
  Future<void> logout() async {
    emit(null); // Kullanıcı bilgilerini sıfırla
    await _sessionManager.clearSession(); // Oturumu temizle
    print("UserCubit: User logged out. Global username cleared.");

    // Tüm ilgili cubit'leri sıfırla
    _favoriteCubit.clearFavorites(); // Favori ürünleri sıfırla
    _accountCubit.clearAccount(); // Hesap bilgilerini sıfırla
    _orderCubit.clearOrders(); // Siparişleri sıfırla
    _basketCubit.clearBasket(); // Sepetteki ürünleri sıfırla
  }

  // Kaydedilmiş kullanıcıyı yükle
  Future<void> loadUserFromSession() async {
    final username = await _sessionManager.getUsername();
    if (username != null) {
      final user = await _userDao.getUserByUserName(username);
      if (user != null) {
        emit(user);
        print("UserCubit: Session loaded. Global username -> $username");

        // Kullanıcıyı yükledikten sonra ilgili cubit'leri baştan yükle
        await _favoriteCubit.loadFavorites(); // Favori ürünleri yükle
        await _accountCubit.loadAccountInfo(); // Hesap bilgilerini yükle
        await _orderCubit.loadOrders(); // Siparişleri yükle
        await _basketCubit.getBasketItems(); // Sepetteki ürünleri yükle
      }
    } else {
      print("UserCubit: No session found.");
    }
  }
}
