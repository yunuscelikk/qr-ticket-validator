class UserModel {
  final int id;
  final String email;
  final String full_name;

  UserModel({required this.id, required this.email, required this.full_name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      email: json['email'],
      full_name: json['full_name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'full_name': full_name};
  }
}
