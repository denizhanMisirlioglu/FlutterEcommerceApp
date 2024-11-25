import 'package:flutter/material.dart';
import '../repo/sqlite/database_helper.dart';
import '../util/session_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Veritabanı işlemleri için gerekli

  final dbHelper = DatabaseHelper();
  final sessionManager = SessionManager();

  print("Starting Database Debug Test...");

  // 1. Oturumu sıfırla
  print("Clearing session...");
  await sessionManager.clearSession();

  // 2. Veritabanını sil ve yeniden başlat
  await dbHelper.deleteDatabaseFile();
  print("Database deleted.");

  // 3. Veritabanını yeniden başlat
  await dbHelper.database;
  print("Database reinitialized.");

  // 4. Kullanıcı tablosunu test et
  final db = await dbHelper.database;

  try {
    // Kullanıcı ekle
    print("Adding test user...");
    await db.insert('users', {
      'username': 'Denizhan',
      'password': 'sifre123',
      'name': 'Denizhan',
      'address': 'a'
    });
    print("Test user added successfully.");

    // Kullanıcıları al
    print("Fetching users...");
    final users = await db.query('users');
    print("Users table data: $users");
  } catch (e) {
    print("Error testing users table: $e");
  }

  try {
    // Sipariş ekle
    print("Adding test order...");
    final orderId = await db.insert('orders', {
      'user_name': 'Denizhan',
      'order_date': DateTime.now().toIso8601String(),
      'total_price': 150.0,
    });
    print("Test order added successfully with ID: $orderId");

    // Sipariş ürünlerini ekle
    print("Adding test order items...");
    await db.insert('order_items', {
      'order_id': orderId,
      'product_id': 101,
      'product_name': 'Test Product',
      'product_image': 'https://example.com/test.png',
      'price': 50.0,
      'quantity': 3,
    });
    print("Test order items added successfully.");

    // Siparişleri al
    print("Fetching orders...");
    final orders = await db.query('orders');
    print("Orders table data: $orders");

    // Sipariş ürünlerini al
    print("Fetching order items...");
    final orderItems = await db.query('order_items');
    print("Order items table data: $orderItems");
  } catch (e) {
    print("Error testing orders and order items: $e");
  }

  print("Database Debug Test Finished.");
}
