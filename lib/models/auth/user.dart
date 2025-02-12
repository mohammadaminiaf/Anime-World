class User {
  final String id;
  final String name;
  final String username;
  final String? email;
  final String? phone;
  final bool? isAuthenticated;
  final String? profileUrl;

  const User({
    required this.id,
    required this.name,
    required this.username,
    this.email,
    this.phone,
    this.isAuthenticated = false,
    this.profileUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      isAuthenticated: json['is_authenticated'],
      profileUrl: json['profile_photo'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
        'phone': phone,
        'is_authenticated': isAuthenticated,
        'profile_photo': profileUrl,
      };
}
