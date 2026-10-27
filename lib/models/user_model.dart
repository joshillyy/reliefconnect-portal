enum UserRole { volunteer, requester, admin }

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.volunteer:
        return 'Volunteer';
      case UserRole.requester:
        return 'Relief Requester';
      case UserRole.admin:
        return 'Administrator';
    }
  }

  static UserRole fromString(String? role) {
    switch (role?.toLowerCase()) {
      case 'admin':
      case 'coordinator':
        return UserRole.admin;
      case 'requester':
      case 'affected_person':
        return UserRole.requester;
      case 'volunteer':
      default:
        return UserRole.volunteer;
    }
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final List<String> skills;
  final String location;
  final int completedTasksCount;
  final DateTime createdAt;
  final bool isAdminBootstrapVerified;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.skills = const [],
    this.location = '',
    this.completedTasksCount = 0,
    required this.createdAt,
    this.isAdminBootstrapVerified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'skills': skills,
      'location': location,
      'completedTasksCount': completedTasksCount,
      'createdAt': createdAt.toIso8601String(),
      'isAdminBootstrapVerified': isAdminBootstrapVerified,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      id: docId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: UserRoleExtension.fromString(map['role']),
      skills: List<String>.from(map['skills'] ?? []),
      location: map['location'] ?? '',
      completedTasksCount: (map['completedTasksCount'] as num?)?.toInt() ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      isAdminBootstrapVerified: map['isAdminBootstrapVerified'] == true,
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    List<String>? skills,
    String? location,
    int? completedTasksCount,
    bool? isAdminBootstrapVerified,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      skills: skills ?? this.skills,
      location: location ?? this.location,
      completedTasksCount: completedTasksCount ?? this.completedTasksCount,
      createdAt: createdAt,
      isAdminBootstrapVerified:
          isAdminBootstrapVerified ?? this.isAdminBootstrapVerified,
    );
  }
}
