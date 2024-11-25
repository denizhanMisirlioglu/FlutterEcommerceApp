import 'package:sqflite/sqflite.dart';
import '../../model/product/product.dart';
import 'database_helper.dart';

class FavoriteDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Favorilere ürün ekleme
  Future<void> addToFavorites(Product product, String username) async {
    final db = await _dbHelper.database;

    try {
      // Ürünün zaten favorilerde olup olmadığını kontrol et
      await db.insert(
        'favorites',
        {
          'product_id': product.id,
          'name': product.name,
          'image': product.image,
          'category': product.category,
          'price': product.price,
          'brand': product.brand,
          'user_name': username, // Kullanıcı adı ekleniyor
        },
        conflictAlgorithm: ConflictAlgorithm.ignore, // UNIQUE kısıtlamasına uygun çalışır
      );
      print("Product added to favorites for user $username: ${product.name}");
    } catch (e) {
      print("Error adding to favorites: $e");
      throw Exception("Failed to add product to favorites.");
    }
  }

  // Favorilerden ürün silme
  Future<void> removeFromFavorites(int productId, String username) async {
    final db = await _dbHelper.database;

    try {
      await db.delete(
        'favorites',
        where: 'product_id = ? AND user_name = ?',
        whereArgs: [productId, username],
      );
      print("Product removed from favorites for user $username: ID $productId");
    } catch (e) {
      print("Error removing from favorites: $e");
      throw Exception("Failed to remove product from favorites.");
    }
  }

  // Tüm favori ürünleri listeleme (kullanıcı bazlı)
  Future<List<Product>> getFavoriteProducts(String username) async {
    final db = await _dbHelper.database;

    try {
      print("Fetching favorites from database for user $username...");
      final result = await db.query(
        'favorites',
        where: 'user_name = ?', // Sadece belirtilen kullanıcı adıyla eşleşen favorileri getir
        whereArgs: [username],
      );

      if (result.isEmpty) {
        print("No favorites found for user $username.");
        return [];
      }

      // Gelen sonucu dönüştür
      return result.map((item) => Product.fromJson({
        "id": item['product_id'],
        "ad": item['name'],
        "resim": item['image'],
        "kategori": item['category'],
        "fiyat": item['price'],
        "marka": item['brand'],
      })).toList();
    } catch (e) {
      print("Error fetching favorite products: $e");
      throw Exception("Failed to fetch favorite products.");
    }
  }

  // Belirli bir ürünün favori olup olmadığını kontrol etme (kullanıcı bazlı)
  Future<bool> isFavorite(int productId, String username) async {
    final db = await _dbHelper.database;

    try {
      final result = await db.query(
        'favorites',
        where: 'product_id = ? AND user_name = ?',
        whereArgs: [productId, username],
      );
      return result.isNotEmpty;
    } catch (e) {
      print("Error checking if product is favorite: $e");
      throw Exception("Failed to check favorite status.");
    }
  }
}
