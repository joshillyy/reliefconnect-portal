import 'package:flutter/foundation.dart';

import '../models/activity_log_model.dart';
import '../repositories/activity_repository.dart';

class ActivityProvider extends ChangeNotifier {
  final ActivityRepository _repository = ActivityRepository();

  List<ActivityLogModel> _activities = [];
  bool _isLoading = false;

  List<ActivityLogModel> get activities => _activities;
  bool get isLoading => _isLoading;

  Future<void> fetchActivities({bool isDemoMode = true}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _activities = await _repository.getActivities(forceDemo: isDemoMode);
      _isLoading = false;
      notifyListeners();
    } catch (_) {
      _isLoading = false;
      notifyListeners();
    }
  }
}
