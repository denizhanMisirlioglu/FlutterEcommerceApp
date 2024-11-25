import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ecommerce_app.db');

    print("Initializing database at path: $path");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    print("Creating new database structure...");

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        name TEXT,
        address TEXT
      )
    ''');
    print("Users table created.");

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        image TEXT NOT NULL,
        category TEXT NOT NULL,
        price INTEGER NOT NULL,
        brand TEXT NOT NULL,
        user_name TEXT NOT NULL,
        UNIQUE(product_id, user_name)
      )
    ''');
    print("Favorites table created.");

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_name TEXT NOT NULL,
        order_date TEXT NOT NULL,
        total_price REAL NOT NULL,
        UNIQUE(user_name, order_date)
      )
    ''');
    print("Orders table created.");

    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        product_name TEXT NOT NULL,
        product_image TEXT NOT NULL,
        price INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        category TEXT NOT NULL, 
        brand TEXT NOT NULL, 
        FOREIGN KEY(order_id) REFERENCES orders(id) ON DELETE CASCADE
      )
    ''');
    print("Order Items table created.");
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ecommerce_app.db');
    final file = File(path);

    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    if (await file.exists()) {
      await file.delete();
      print("Database file deleted successfully.");
    } else {
      print("Database file does not exist.");
    }
  }

  Future<void> debugOrdersTable(String username) async {
    final db = await database;
    try {
      print("Fetching orders for user: $username...");
      final orders = await db.query(
        'orders',
        where: 'user_name = ?',
        whereArgs: [username],
      );

      if (orders.isEmpty) {
        print("Orders table is empty for user: $username.");
      } else {
        print("Orders data for user: $username -> $orders");
        for (var order in orders) {
          await debugOrderItemsTable(order['id'] as int);
        }
      }
    } catch (e) {
      print("Error while debugging orders table for user: $username -> $e");
    }
  }

  Future<void> debugOrderItemsTable(int orderId) async {
    final db = await database;
    try {
      print("Fetching order items for order ID: $orderId...");
      final orderItems = await db.query(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [orderId],
      );

      if (orderItems.isEmpty) {
        print("Order items table is empty for order ID: $orderId.");
      } else {
        print("Order items for order ID $orderId -> $orderItems");
      }
    } catch (e) {
      print("Error while debugging order items table: $e");
    }
  }

  Future<bool> verifyOrderIntegrity(String username) async {
    final db = await database;
    try {
      final orders = await db.query(
        'orders',
        where: 'user_name = ?',
        whereArgs: [username],
      );

      for (var order in orders) {
        final orderId = order['id'] as int;
        final items = await db.query(
          'order_items',
          where: 'order_id = ?',
          whereArgs: [orderId],
        );
        if (items.isEmpty) {
          print("Integrity issue: Order ID $orderId has no associated items.");
          return false;
        }
      }

      print("Order integrity verified for user: $username.");
      return true;
    } catch (e) {
      print("Error verifying order integrity: $e");
      return false;
    }
  }
}
