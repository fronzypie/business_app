enum UserType { user, owner }

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserType type;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
  type: UserType.values.firstWhere((e) => e.toString() == 'UserType.${json['type'] ?? 'user'}'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'type': type.name,
      };
}
