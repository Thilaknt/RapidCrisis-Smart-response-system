import 'package:cloud_firestore/cloud_firestore.dart';

class AlertModel {
  final String id;
  final String userId;
  final String triggerType; // 'button', 'voice', 'sensor'
  final String message;
  final double latitude;
  final double longitude;
  final String status; // 'pending', 'active', 'resolved', 'cancelled'
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;
  final String? responderId;
  final int severity; // 1-5
  final List<String> acceptedResponders;
  final bool synced;

  AlertModel({
    required this.id,
    required this.userId,
    required this.triggerType,
    required this.message,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.resolvedAt,
    this.responderId,
    this.severity = 5,
    this.acceptedResponders = const [],
    this.synced = false,
  });

  // Duration since alert was created
  Duration get duration => DateTime.now().difference(createdAt);

  // Format duration for display
  String get formattedDuration {
    final secs = duration.inSeconds;
    if (secs < 60) return '$secs sec';
    if (secs < 3600) return '${(secs / 60).floor()} min';
    return '${(secs / 3600).floor()} hr';
  }

  // Is alert still active
  bool get isActive => status == 'pending' || status == 'active';

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'triggerType': triggerType,
      'message': message,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      'responderId': responderId,
      'severity': severity,
      'acceptedResponders': acceptedResponders,
      'synced': synced,
    };
  }

  // Create from Firestore document
  factory AlertModel.fromMap(Map<String, dynamic> map, String docId) {
    return AlertModel(
      id: docId,
      userId: map['userId'] ?? '',
      triggerType: map['triggerType'] ?? 'button',
      message: map['message'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
      resolvedAt: (map['resolvedAt'] as Timestamp?)?.toDate(),
      responderId: map['responderId'],
      severity: map['severity'] ?? 5,
      acceptedResponders: List<String>.from(map['acceptedResponders'] ?? []),
      synced: map['synced'] ?? false,
    );
  }

  AlertModel copyWith({
    String? id,
    String? userId,
    String? triggerType,
    String? message,
    double? latitude,
    double? longitude,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    String? responderId,
    int? severity,
    List<String>? acceptedResponders,
    bool? synced,
  }) {
    return AlertModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      triggerType: triggerType ?? this.triggerType,
      message: message ?? this.message,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      responderId: responderId ?? this.responderId,
      severity: severity ?? this.severity,
      acceptedResponders: acceptedResponders ?? this.acceptedResponders,
      synced: synced ?? this.synced,
    );
  }
}
