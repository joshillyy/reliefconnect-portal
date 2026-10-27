class ReliefTaskModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String disasterType;
  final String location;
  final int requiredVolunteers;
  final int currentVolunteers;
  final DateTime date;
  final List<String> requiredSkills;
  final String urgencyLevel; // Low, Medium, High, Critical
  final String status; // Open, In Progress, Completed, Cancelled
  final String createdBy;
  final DateTime createdAt;

  const ReliefTaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.disasterType,
    required this.location,
    required this.requiredVolunteers,
    this.currentVolunteers = 0,
    required this.date,
    this.requiredSkills = const [],
    required this.urgencyLevel,
    this.status = 'Open',
    required this.createdBy,
    required this.createdAt,
  });

  bool get isFull => currentVolunteers >= requiredVolunteers;
  int get spotsRemaining =>
      (requiredVolunteers - currentVolunteers).clamp(0, requiredVolunteers);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'disasterType': disasterType,
      'location': location,
      'requiredVolunteers': requiredVolunteers,
      'currentVolunteers': currentVolunteers,
      'date': date.toIso8601String(),
      'requiredSkills': requiredSkills,
      'urgencyLevel': urgencyLevel,
      'status': status,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReliefTaskModel.fromMap(Map<String, dynamic> map, String docId) {
    return ReliefTaskModel(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'General Support',
      disasterType: map['disasterType'] ?? 'Flood',
      location: map['location'] ?? '',
      requiredVolunteers: (map['requiredVolunteers'] as num?)?.toInt() ?? 5,
      currentVolunteers: (map['currentVolunteers'] as num?)?.toInt() ?? 0,
      date: map['date'] != null
          ? DateTime.tryParse(map['date']) ?? DateTime.now()
          : DateTime.now(),
      requiredSkills: List<String>.from(map['requiredSkills'] ?? []),
      urgencyLevel: map['urgencyLevel'] ?? 'Medium',
      status: map['status'] ?? 'Open',
      createdBy: map['createdBy'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  ReliefTaskModel copyWith({
    String? title,
    String? description,
    String? category,
    String? disasterType,
    String? location,
    int? requiredVolunteers,
    int? currentVolunteers,
    DateTime? date,
    List<String>? requiredSkills,
    String? urgencyLevel,
    String? status,
  }) {
    return ReliefTaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      disasterType: disasterType ?? this.disasterType,
      location: location ?? this.location,
      requiredVolunteers: requiredVolunteers ?? this.requiredVolunteers,
      currentVolunteers: currentVolunteers ?? this.currentVolunteers,
      date: date ?? this.date,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      urgencyLevel: urgencyLevel ?? this.urgencyLevel,
      status: status ?? this.status,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }
}
