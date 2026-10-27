import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/relief_request_model.dart';
import '../services/demo_data_service.dart';
import '../services/firebase_service.dart';

class ReliefRequestRepository {
  bool get _isLiveFirebase => FirebaseService.instance.isInitialized;

  Future<List<ReliefRequestModel>> getAllRequests({
    bool forceDemo = false,
  }) async {
    if (!_isLiveFirebase || forceDemo) {
      return DemoDataService.instance.getRequests();
    }

    try {
      final snap = await FirebaseFirestore.instance
          .collection('relief_requests')
          .orderBy('createdAt', descending: true)
          .get();

      return snap.docs
          .map((doc) => ReliefRequestModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      // Fallback to local cache if query fails or requires composite index
      return DemoDataService.instance.getRequests();
    }
  }

  Future<List<ReliefRequestModel>> getRequestsForUser(
    String userId, {
    bool forceDemo = false,
  }) async {
    if (!_isLiveFirebase || forceDemo) {
      return DemoDataService.instance
          .getRequests()
          .where((r) => r.requesterId == userId)
          .toList();
    }

    try {
      final snap = await FirebaseFirestore.instance
          .collection('relief_requests')
          .where('requesterId', isEqualTo: userId)
          .get();

      final list = snap.docs
          .map((doc) => ReliefRequestModel.fromMap(doc.data(), doc.id))
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } catch (e) {
      return DemoDataService.instance
          .getRequests()
          .where((r) => r.requesterId == userId)
          .toList();
    }
  }

  Future<ReliefRequestModel> createRequest(
    ReliefRequestModel request, {
    bool forceDemo = false,
  }) async {
    if (!_isLiveFirebase || forceDemo) {
      DemoDataService.instance.addRequest(request);
      return request;
    }

    try {
      await FirebaseFirestore.instance
          .collection('relief_requests')
          .doc(request.id)
          .set(request.toMap());
      return request;
    } catch (e) {
      throw Exception('Failed to submit relief request to Firebase: $e');
    }
  }

  Future<void> updateRequestStatus(
    String requestId,
    String newStatus, {
    String? adminRemarks,
    bool forceDemo = false,
  }) async {
    if (!_isLiveFirebase || forceDemo) {
      final existing = DemoDataService.instance.getRequestById(requestId);
      if (existing != null) {
        final updated = existing.copyWith(
          status: newStatus,
          adminRemarks: adminRemarks ?? existing.adminRemarks,
          updatedAt: DateTime.now(),
        );
        DemoDataService.instance.updateRequest(updated);
      }
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('relief_requests')
          .doc(requestId)
          .update({
            'status': newStatus,
            'adminRemarks': ?adminRemarks,
            'updatedAt': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      throw Exception('Failed to update request status: $e');
    }
  }

  Future<void> updateRequest(
    ReliefRequestModel request, {
    bool forceDemo = false,
  }) async {
    if (!_isLiveFirebase || forceDemo) {
      DemoDataService.instance.updateRequest(request);
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('relief_requests')
          .doc(request.id)
          .update(request.toMap());
    } catch (e) {
      throw Exception('Failed to update request: $e');
    }
  }

  Future<void> deleteRequest(String requestId, {bool forceDemo = false}) async {
    if (!_isLiveFirebase || forceDemo) {
      DemoDataService.instance.deleteRequest(requestId);
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('relief_requests')
          .doc(requestId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete request: $e');
    }
  }
}
