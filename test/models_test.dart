import 'package:flutter_test/flutter_test.dart';
import 'package:relief_connect/models/relief_request_model.dart';
import 'package:relief_connect/models/relief_task_model.dart';
import 'package:relief_connect/models/task_participant_model.dart';
import 'package:relief_connect/models/user_model.dart';

void main() {
  group('Data Models Unit Tests', () {
    test('UserModel serialization and copyWith works correctly', () {
      final now = DateTime.now();
      final user = UserModel(
        id: 'usr_123',
        name: 'Aarav Sharma',
        email: 'aarav@reliefconnect.org',
        phone: '9876543210',
        role: UserRole.volunteer,
        skills: ['First Aid & CPR'],
        location: 'Guwahati',
        completedTasksCount: 5,
        createdAt: now,
      );

      final map = user.toMap();
      expect(map['name'], 'Aarav Sharma');
      expect(map['role'], 'volunteer');

      final reconstructed = UserModel.fromMap(map, 'usr_123');
      expect(reconstructed.name, 'Aarav Sharma');
      expect(reconstructed.role, UserRole.volunteer);
      expect(reconstructed.skills, contains('First Aid & CPR'));

      final modified = user.copyWith(completedTasksCount: 6);
      expect(modified.completedTasksCount, 6);
      expect(modified.name, 'Aarav Sharma');
    });

    test('ReliefTaskModel capacity and spotsRemaining calculations', () {
      final now = DateTime.now();
      final task = ReliefTaskModel(
        id: 'TSK-001',
        title: 'Emergency Flood Evacuation',
        description: 'Assisting flood rescue',
        category: 'Rescue',
        disasterType: 'Flood',
        location: 'Silchar',
        requiredVolunteers: 10,
        currentVolunteers: 7,
        date: now,
        urgencyLevel: 'Critical',
        createdBy: 'admin_1',
        createdAt: now,
      );

      expect(task.isFull, isFalse);
      expect(task.spotsRemaining, 3);

      final fullTask = task.copyWith(currentVolunteers: 10);
      expect(fullTask.isFull, isTrue);
      expect(fullTask.spotsRemaining, 0);
    });

    test('ReliefRequestModel serialization and status updates', () {
      final now = DateTime.now();
      final request = ReliefRequestModel(
        id: 'REQ-1001',
        requesterId: 'usr_1',
        requesterName: 'Pooja Verma',
        requesterContact: '9812345678',
        disasterCategory: 'Flood',
        exactLocation: 'Ward 4, Silchar',
        assistanceCategory: 'Food Supplies',
        description: 'Stranded on roof',
        affectedPeopleCount: 8,
        urgencyLevel: 'Critical',
        createdAt: now,
      );

      expect(request.status, 'Pending');
      final updated = request.copyWith(
        status: 'In Progress',
        adminRemarks: 'Boat dispatched',
      );
      expect(updated.status, 'In Progress');
      expect(updated.adminRemarks, 'Boat dispatched');
    });

    test('TaskParticipantModel correctly tracks status lifecycle', () {
      final now = DateTime.now();
      final participant = TaskParticipantModel(
        id: 'PRT-1',
        taskId: 'TSK-001',
        taskTitle: 'Flood Evacuation',
        volunteerId: 'usr_123',
        volunteerName: 'Aarav',
        volunteerContact: '9876543210',
        status: 'Pending',
        joinedAt: now,
      );

      expect(participant.status, 'Pending');
      expect(participant.approvedAt, isNull);

      final approved = participant.copyWith(
        status: 'Approved',
        approvedAt: now.add(const Duration(hours: 1)),
      );
      expect(approved.status, 'Approved');
      expect(approved.approvedAt, isNotNull);
    });
  });
}
