import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../Models/AddressItem.dart';
import '../Models/CartModel.dart';
import '../Models/FavoriteItem.dart';

class CartDatabaseHelper {
  static final CartDatabaseHelper _instance = CartDatabaseHelper._internal();
  static final int dbVersion = 4;

  factory CartDatabaseHelper() => _instance;

  CartDatabaseHelper._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<CartItem?> getCartItemByProductId(int productId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'cart',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    if (maps.isEmpty) {
      return null;
    }

    return CartItem.fromJson(maps.first);
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'fawri.db');

    return await openDatabase(
      path,
      version: dbVersion,
      onUpgrade: _onUpgrade,
      onCreate: (db, version) async {
        await _createDb(db);
      },
    );
  }

  Future<void> _createDb(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        name TEXT NOT NULL,
        image TEXT NOT NULL,
        type TEXT NOT NULL,
        place_in_warehouse TEXT NOT NULL,
        sku TEXT NOT NULL,
        nickname TEXT NOT NULL,
        vendor_sku TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        quantityExist INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        availability INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS addresses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        user_id INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        name TEXT NOT NULL,
        image TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Drop existing tables
    await db.execute('DROP TABLE IF EXISTS cart');
    await db.execute('DROP TABLE IF EXISTS favorites');

    // Recreate tables with updated schema
    await _createDb(db);
  }

  Future<FavoriteItem?> getFavoriteItemByProductId(int productId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'favorites',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    if (maps.isEmpty) {
      return null;
    }

    return FavoriteItem.fromJson(maps.first);
  }

  Future<int> insertFavoriteItem(FavoriteItem item) async {
    final db = await database;
    return await db!.insert('favorites', item.toJson());
  }

  Future<List<FavoriteItem>> getFavoriteItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('favorites');
    return List.generate(
      maps.length,
      (i) => FavoriteItem.fromJson(maps[i]),
    );
  }

  Future<void> deleteFavoriteItem(int id) async {
    final db = await database;
    await db!.delete('favorites', where: 'productId = ?', whereArgs: [id]);
  }

  // Method to clear the cart database
  Future<void> clearCart() async {
    final db = await database;
    await db!.delete('cart'); // Delete all records from the 'cart' table
  }

  Future<void> clearUserAddress() async {
    final db = await database;
    await db!.delete('addresses');
  }

  Future<int> insertCartItem(CartItem item) async {
    final db = await database;
    return await db!.insert('cart', item.toJson());
  }

  Future<int> insertAddressItem(AddressItem item) async {
    final db = await database;
    return await db!.insert('addresses', item.toJson());
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('cart');
    return List.generate(
      maps.length,
      (i) => CartItem.fromJson(maps[i]),
    );
  }

  Future<List<AddressItem>> getAddresses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('addresses');
    return List.generate(
      maps.length,
      (i) => AddressItem.fromJson(maps[i]),
    );
  }

  Future<List<AddressItem>> getUserAddresses() async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('addresses');

    return List.generate(maps.length, (i) {
      return AddressItem(
        id: maps[i]['id'],
        user_id: maps[i]['user_id'],
        name: maps[i]['name'],
      );
    });
  }

  Future<void> deleteCartItem(int id) async {
    final db = await database;
    print(id);
    await db!.delete('cart', where: 'productId = ?', whereArgs: [id]);
  }

  Future<void> deleteAddressItem(int id) async {
    final db = await database;
    print(id);
    await db!.delete('addresses', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateCartItem(CartItem item) async {
    final db = await database;
    await db!.update(
      'cart',
      item.toJson(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> updateAddressItem(AddressItem item) async {
    final db = await database;
    await db!.update(
      'addresses',
      item.toJson(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<bool> isProductInFavorites(String productID) async {
    final db = await database;
    final result = await db!.query(
      'favorites',
      where: 'productId = ?',
      whereArgs: [productID],
    );
    return result.isNotEmpty;
  }
}
