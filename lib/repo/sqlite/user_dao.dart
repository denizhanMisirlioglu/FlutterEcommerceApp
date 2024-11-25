import '../../util/session_manager.dart';
import 'database_helper.dart';

class UserDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final SessionManager _sessionManager = SessionManager();

  // Kullanıcı ekleme
  Future<void> insertUser(
      String username, String password, String name, String address) async {
    if (await isUsernameTaken(username)) {
      throw Exception("Username already exists.");
    }
    final db = await _dbHelper.database;
    await db.insert(
      'users',
      {
        'username': username,
        'password': password,
        'name': name,
        'address': address,
      },
    );
  }

  // Kullanıcıları listeleme
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await _dbHelper.database;
    return await db.query('users');
  }

  // Kullanıcı güncelleme
  Future<void> updateUser(int id, String name, String address) async {
    final db = await _dbHelper.database;
    await db.update(
      'users',
      {'name': name, 'address': address},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Kullanıcı silme
  Future<void> deleteUser(int id) async {
    final db = await _dbHelper.database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Kullanıcı bilgilerini username'e göre getirme
  Future<Map<String, dynamic>?> getUserByUserName(String username) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Kullanıcı bilgilerini ID'ye göre getirme
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Kullanıcı parolası kontrolü
  Future<bool> verifyPassword(String username, String password) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  // Kullanıcı giriş işlemi (login)
  Future<bool> login(String username, String password) async {
    final isPasswordCorrect = await verifyPassword(username, password);
    if (isPasswordCorrect) {
      final user = await getUserByUserName(username);
      if (user != null) {
        await _sessionManager.saveUsername(
            username); // Kullanıcı adını SharedPreferences'a kaydet
        return true;
      }
    }
    return false;
  }

  // Kullanıcı adının mevcut olup olmadığını kontrol et
  Future<bool> isUsernameTaken(String username) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  // Kullanıcı çıkış işlemi (logout)
  Future<void> logout() async {
    await _sessionManager.clearSession(); // Oturumu SharedPreferences'tan sil
  }
}
