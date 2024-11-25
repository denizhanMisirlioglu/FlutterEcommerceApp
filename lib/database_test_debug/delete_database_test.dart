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
    print("Adding test user...");
    await db.insert('users', {
      'username': 'Denizhan',
      'password': 'sifre',
      'name': 'Denizhan',
      'address': 'Bursa/Nilüfer Dumlupınar mah. Gökova sk. No:18 Esenler apt. Daire:2'
    });
    print("Test user added successfully.");

    print("Fetching users...");
    final users = await db.query('users');
    print("Users table data: $users");
  } catch (e) {
    print("Error testing users table: $e");
  }

  print("Database Debug Test Finished.");



}
