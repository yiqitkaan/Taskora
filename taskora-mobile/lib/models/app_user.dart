class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  final int id;
  final String name;
  final String email;
  final String password;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'password': password,
  };

  bool matches(String candidateEmail, String candidatePassword) =>
      email.toLowerCase() == candidateEmail.trim().toLowerCase() &&
      password == candidatePassword;
}
