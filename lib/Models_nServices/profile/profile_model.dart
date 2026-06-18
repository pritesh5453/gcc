class SimpleUser {
  final int id;
  final String name;
  final String email;
  final String phone;

  SimpleUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory SimpleUser.fromJson(Map<String, dynamic> json) {
    return SimpleUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
    );
  }
}