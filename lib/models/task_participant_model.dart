class TaskParticipantModel {
  final String id;
  final String taskId;
  final String taskTitle;
  final String volunteerId;
  final String volunteerName;
  final String volunteerContact;
  final List<String> volunteerSkills;
  final String status; // Pending, Approved, In Progress, Completed, Cancelled
  final DateTime joinedAt;
  final DateTime? approvedAt;

  const TaskParticipantModel({
    required this.id,
    required this.taskId,
    required this.taskTitle,
    required this.volunteerId,
    required this.volunteerName,
    required this.volunteerContact,
    this.volunteerSkills = const [],
    this.status = 'Pending',
    required this.joinedAt,
    this.approvedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'taskTitle': taskTitle,
      'volunteerId': volunteerId,
      'volunteerName': volunteerName,
      'volunteerContact': volunteerContact,
      'volunteerSkills': volunteerSkills,
      'status': status,
      'joinedAt': joinedAt.toIso8601String(),
      'approvedAt': approvedAt?.toIso8601String(),
    };
  }

  factory TaskParticipantModel.fromMap(Map<String, dynamic> map, String docId) {
    return TaskParticipantModel(
      id: docId,
      taskId: map['taskId'] ?? '',
      taskTitle: map['taskTitle'] ?? '',
      volunteerId: map['volunteerId'] ?? '',
      volunteerName: map['volunteerName'] ?? '',
      volunteerContact: map['volunteerContact'] ?? '',
      volunteerSkills: List<String>.from(map['volunteerSkills'] ?? []),
      status: map['status'] ?? 'Pending',
      joinedAt: map['joinedAt'] != null
          ? DateTime.tryParse(map['joinedAt']) ?? DateTime.now()
          : DateTime.now(),
      approvedAt: map['approvedAt'] != null
          ? DateTime.tryParse(map['approvedAt'])
          : null,
    );
  }

  TaskParticipantModel copyWith({String? status, DateTime? approvedAt}) {
    return TaskParticipantModel(
      id: id,
      taskId: taskId,
      taskTitle: taskTitle,
      volunteerId: volunteerId,
      volunteerName: volunteerName,
      volunteerContact: volunteerContact,
      volunteerSkills: volunteerSkills,
      status: status ?? this.status,
      joinedAt: joinedAt,
      approvedAt: approvedAt ?? this.approvedAt,
    );
  }
}
