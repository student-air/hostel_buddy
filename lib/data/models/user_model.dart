class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profilePicture;
  final String? city;
  final String?
  role; // AppConstants.roleSeeker / roleManager, null until Role Selection

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePicture,
    this.city,
    this.role,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? profilePicture,
    String? city,
    String? role,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePicture: profilePicture ?? this.profilePicture,
      city: city ?? this.city,
      role: role ?? this.role,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profilePicture: json['profilePicture'] as String?,
      city: json['city'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profilePicture': profilePicture,
      'city': city,
      'role': role,
    };
  }
}
