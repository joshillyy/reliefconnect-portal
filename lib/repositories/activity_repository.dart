import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/activity_log_model.dart';
import '../services/demo_data_service.dart';
import '../services/firebase_service.dart';

class ActivityRepository {
  bool get _isLiveFirebase =>
      FirebaseService.instance.isInitialized &&
      FirebaseService.instance.hasRealFirebaseConfig;

  Future<List<ActivityLogModel>> getActivities({bool forceDemo = false}) async {
    if (!_isLiveFirebase || forceDemo) {
      return DemoDataService.instance.getActivities();
    }

    try {
      final snap = await FirebaseFirestore.instance
          .collection('activity_logs')
          .orderBy('timestamp', descending: true)
          .limit(30)
          .get();

      return snap.docs
          .map((d) => ActivityLogModel.fromMap(d.data(), d.id))
          .toList();
    } catch (e) {
      return DemoDataService.instance.getActivities();
    }
  }

  Future<void> logActivity(
    ActivityLogModel activity, {
    bool forceDemo = false,
  }) async {
    if (!_isLiveFirebase || forceDemo) {
      DemoDataService.instance.addActivity(activity);
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('activity_logs')
          .doc(activity.id)
          .set(activity.toMap());
    } catch (_) {
      // Best-effort logging
    }
  }
}
