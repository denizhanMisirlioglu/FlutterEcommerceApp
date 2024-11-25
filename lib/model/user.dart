class User {
  int id;
  String username;
  String password;
  String? name;
  String? address;

  User({
    required this.id,
    required this.username,
    required this.password,
    this.name,
    this.address,
  });

  // Map'e dönüştürme (Veritabanı için kullanılabilir)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'address': address,
    };
  }

  // Map'ten User modeline dönüştürme
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      username: map['username'] as String,
      password: map['password'] as String,
      name: map['name'] as String?,
      address: map['address'] as String?,
    );
  }

  // JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'address': address,
    };
  }

  // JSON'dan User modeline dönüştürme
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      password: json['password'] as String,
      name: json['name'] as String?,
      address: json['address'] as String?,
    );
  }
}
