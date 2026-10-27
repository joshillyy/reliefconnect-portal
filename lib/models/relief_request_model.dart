class ReliefRequestModel {
  final String id;
  final String requesterId;
  final String requesterName;
  final String requesterContact;
  final String disasterCategory;
  final String exactLocation;
  final String assistanceCategory;
  final String description;
  final int affectedPeopleCount;
  final String urgencyLevel; // Low, Medium, High, Critical
  final String status; // Pending, Approved, In Progress, Completed, Cancelled
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? adminRemarks;

  const ReliefRequestModel({
    required this.id,
    required this.requesterId,
    required this.requesterName,
    required this.requesterContact,
    required this.disasterCategory,
    required this.exactLocation,
    required this.assistanceCategory,
    required this.description,
    required this.affectedPeopleCount,
    required this.urgencyLevel,
    this.status = 'Pending',
    this.photoUrl,
    required this.createdAt,
    this.updatedAt,
    this.adminRemarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requesterId': requesterId,
      'requesterName': requesterName,
      'requesterContact': requesterContact,
      'disasterCategory': disasterCategory,
      'exactLocation': exactLocation,
      'assistanceCategory': assistanceCategory,
      'description': description,
      'affectedPeopleCount': affectedPeopleCount,
      'urgencyLevel': urgencyLevel,
      'status': status,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'adminRemarks': adminRemarks,
    };
  }

  factory ReliefRequestModel.fromMap(Map<String, dynamic> map, String docId) {
    return ReliefRequestModel(
      id: docId,
      requesterId: map['requesterId'] ?? '',
      requesterName: map['requesterName'] ?? '',
      requesterContact: map['requesterContact'] ?? '',
      disasterCategory: map['disasterCategory'] ?? 'Other',
      exactLocation: map['exactLocation'] ?? '',
      assistanceCategory: map['assistanceCategory'] ?? 'Other',
      description: map['description'] ?? '',
      affectedPeopleCount: (map['affectedPeopleCount'] as num?)?.toInt() ?? 1,
      urgencyLevel: map['urgencyLevel'] ?? 'Medium',
      status: map['status'] ?? 'Pending',
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'])
          : null,
      adminRemarks: map['adminRemarks'],
    );
  }

  ReliefRequestModel copyWith({
    String? status,
    String? adminRemarks,
    DateTime? updatedAt,
    String? description,
    int? affectedPeopleCount,
    String? urgencyLevel,
    String? exactLocation,
    String? assistanceCategory,
    String? disasterCategory,
    String? photoUrl,
  }) {
    return ReliefRequestModel(
      id: id,
      requesterId: requesterId,
      requesterName: requesterName,
      requesterContact: requesterContact,
      disasterCategory: disasterCategory ?? this.disasterCategory,
      exactLocation: exactLocation ?? this.exactLocation,
      assistanceCategory: assistanceCategory ?? this.assistanceCategory,
      description: description ?? this.description,
      affectedPeopleCount: affectedPeopleCount ?? this.affectedPeopleCount,
      urgencyLevel: urgencyLevel ?? this.urgencyLevel,
      status: status ?? this.status,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      adminRemarks: adminRemarks ?? this.adminRemarks,
    );
  }
}
