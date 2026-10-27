import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/relief_task_model.dart';
import '../models/task_participant_model.dart';
import '../services/demo_data_service.dart';
import '../services/firebase_service.dart';

class ReliefTaskRepository {
  bool get _isLiveFirebase =>
      FirebaseService.instance.isInitialized &&
      FirebaseService.instance.hasRealFirebaseConfig;

  Future<List<ReliefTaskModel>> getAllTasks({bool forceDemo = false}) async {
    if (!_isLiveFirebase || forceDemo) {
      return DemoDataService.instance.getTasks();
    }

    try {
      final snap = await FirebaseFirestore.instance
          .collection('relief_tasks')
          .orderBy('createdAt', descending: true)
          .get();

      return snap.docs
          .map((doc) => ReliefTaskModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      return DemoDataService.instance.getTasks();
    }
  }

  Future<ReliefTaskModel> createTask(
    ReliefTaskModel task, {
    bool forceDemo = false,
  }) async {
    if (!_isLiveFirebase || forceDemo) {
      DemoDataService.instance.addTask(task);
      return task;
    }

    try {
      await FirebaseFirestore.instance
          .collection('relief_tasks')
          .doc(task.id)
          .set(task.toMap());
      return task;
    } catch (e) {
      throw Exception('Failed to create task in Firebase: $e');
    }
  }

  Future<void> updateTask(
    ReliefTaskModel task, {
    bool forceDemo = false,
  }) async {
    if (!_isLiveFirebase || forceDemo) {
      DemoDataService.instance.updateTask(task);
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('relief_tasks')
          .doc(task.id)
          .update(task.toMap());
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> joinTask(
    TaskParticipantModel participant, {
    bool forceDemo = false,
  }) async {
    if (!_isLiveFirebase || forceDemo) {
      if (DemoDataService.instance.isUserRegisteredForTask(
        participant.volunteerId,
        participant.taskId,
      )) {
        throw Exception('You have already applied or joined this task.');
      }
      DemoDataService.instance.addParticipant(participant);
      return;
    }

    try {
      // Check duplicate in Firestore
      final existing = await FirebaseFirestore.instance
          .collection('task_participants')
          .where('taskId', isEqualTo: participant.taskId)
          .where('volunteerId', isEqualTo: participant.volunteerId)
          .get();

      final active = existing.docs.where(
        (d) => d.data()['status'] != 'Cancelled',
      );
      if (active.isNotEmpty) {
        throw Exception('You have already registered for this task.');
      }

      await FirebaseFirestore.instance
          .collection('task_participants')
          .doc(participant.id)
          .set(participant.toMap());

      // Increment current volunteers
      await FirebaseFirestore.instance
          .collection('relief_tasks')
          .doc(participant.taskId)
          .update({'currentVolunteers': FieldValue.increment(1)});
    } catch (e) {
      throw Exception('Could not register for task: $e');
    }
  }

  Future<List<TaskParticipantModel>> getParticipantsForUser(
    String userId, {
    bool forceDemo = false,
  }) async {
    if (!_isLiveFirebase || forceDemo) {
      return DemoDataService.instance.getParticipantsForUser(userId);
    }

    try {
      final snap = await FirebaseFirestore.instance
          .collection('task_participants')
          .where('volunteerId', isEqualTo: userId)
          .get();

      return snap.docs
          .map((d) => TaskParticipantModel.fromMap(d.data(), d.id))
          .toList();
    } catch (e) {
      return DemoDataService.instance.getParticipantsForUser(userId);
    }
  }

  Future<List<TaskParticipantModel>> getAllParticipants({
    bool forceDemo = false,
  }) async {
    if (!_isLiveFirebase || forceDemo) {
      return DemoDataService.instance.getParticipants();
    }

    try {
      final snap = await FirebaseFirestore.instance
          .collection('task_participants')
          .get();

      return snap.docs
          .map((d) => TaskParticipantModel.fromMap(d.data(), d.id))
          .toList();
    } catch (e) {
      return DemoDataService.instance.getParticipants();
    }
  }

  Future<void> updateParticipantStatus(
    String participantId,
    String status, {
    bool forceDemo = false,
  }) async {
    if (!_isLiveFirebase || forceDemo) {
      DemoDataService.instance.updateParticipantStatus(participantId, status);
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('task_participants')
          .doc(participantId)
          .update({
            'status': status,
            if (status == 'Approved')
              'approvedAt': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      throw Exception('Failed to update participant status: $e');
    }
  }
}
