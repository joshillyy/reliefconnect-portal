class ActivityLogModel {
  final String id;
  final String title;
  final String details;
  final DateTime timestamp;
  final String
  type; // request_created, task_created, volunteer_joined, status_updated, etc.
  final String actorName;
  final String actorRole;

  const ActivityLogModel({
    required this.id,
    required this.title,
    required this.details,
    required this.timestamp,
    required this.type,
    required this.actorName,
    required this.actorRole,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'actorName': actorName,
      'actorRole': actorRole,
    };
  }

  factory ActivityLogModel.fromMap(Map<String, dynamic> map, String docId) {
    return ActivityLogModel(
      id: docId,
      title: map['title'] ?? '',
      details: map['details'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
          : DateTime.now(),
      type: map['type'] ?? 'general',
      actorName: map['actorName'] ?? 'System',
      actorRole: map['actorRole'] ?? 'User',
    );
  }
}
