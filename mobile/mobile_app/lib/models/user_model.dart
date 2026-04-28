import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String role; // 'user', 'volunteer', 'responder'
  final double latitude;
  final double longitude;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastSeenAt;
  final List<String> emergencyContacts;
  final Map<String, bool> permissions; // 'location', 'notifications', 'contacts'

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.role,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.isActive = true,
    required this.createdAt,
    this.lastSeenAt,
    this.emergencyContacts = const [],
    this.permissions = const {
      'location': true,
      'notifications': true,
      'contacts': false,
    },
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'latitude': latitude,
      'longitude': longitude,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastSeenAt': lastSeenAt != null ? Timestamp.fromDate(lastSeenAt!) : null,
      'emergencyContacts': emergencyContacts,
      'permissions': permissions,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      id: docId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
      role: map['role'] ?? 'user',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastSeenAt: (map['lastSeenAt'] as Timestamp?)?.toDate(),
      emergencyContacts: List<String>.from(map['emergencyContacts'] ?? []),
      permissions: Map<String, bool>.from(map['permissions'] ?? {
        'location': true,
        'notifications': true,
        'contacts': false,
      }),
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? role,
    double? latitude,
    double? longitude,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastSeenAt,
    List<String>? emergencyContacts,
    Map<String, bool>? permissions,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      permissions: permissions ?? this.permissions,
    );
  }
}
