class User {
  int id;
  String name;
  String email;

  User({required this.name, required this.email, required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(name: json['name'], email: json['email'], id: json['id']);
  }
}
