import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/relief_task_model.dart';
import '../models/task_participant_model.dart';
import '../models/user_model.dart';
import '../repositories/relief_task_repository.dart';

class ReliefTaskProvider extends ChangeNotifier {
  final ReliefTaskRepository _repository = ReliefTaskRepository();
  final _uuid = const Uuid();

  List<ReliefTaskModel> _tasks = [];
  List<TaskParticipantModel> _participants = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Filters
  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedDisasterType;
  String? _selectedUrgency;

  List<ReliefTaskModel> get allTasks => _tasks;
  List<TaskParticipantModel> get allParticipants => _participants;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  String? get selectedDisasterType => _selectedDisasterType;
  String? get selectedUrgency => _selectedUrgency;

  // Filtered Tasks
  List<ReliefTaskModel> get filteredTasks {
    return _tasks.where((t) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.location.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == null ||
          _selectedCategory == 'All' ||
          t.category.toLowerCase() == _selectedCategory!.toLowerCase();

      final matchesDisaster =
          _selectedDisasterType == null ||
          _selectedDisasterType == 'All' ||
          t.disasterType.toLowerCase() == _selectedDisasterType!.toLowerCase();

      final matchesUrgency =
          _selectedUrgency == null ||
          _selectedUrgency == 'All' ||
          t.urgencyLevel.toLowerCase() == _selectedUrgency!.toLowerCase();

      return matchesSearch &&
          matchesCategory &&
          matchesDisaster &&
          matchesUrgency;
    }).toList();
  }

  // Statistics
  int get totalTasksCount => _tasks.length;
  int get openTasksCount => _tasks.where((t) => t.status == 'Open').length;
  int get totalVolunteersNeeded =>
      _tasks.fold(0, (sum, t) => sum + t.requiredVolunteers);
  int get totalVolunteersEnrolled =>
      _tasks.fold(0, (sum, t) => sum + t.currentVolunteers);
  int get pendingApprovalsCount =>
      _participants.where((p) => p.status == 'Pending').length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setFilterDisaster(String? disaster) {
    _selectedDisasterType = disaster;
    notifyListeners();
  }

  void setFilterUrgency(String? urgency) {
    _selectedUrgency = urgency;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _selectedDisasterType = null;
    _selectedUrgency = null;
    notifyListeners();
  }

  Future<void> fetchTasksAndParticipants({bool isDemoMode = true}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getAllTasks(forceDemo: isDemoMode),
        _repository.getAllParticipants(forceDemo: isDemoMode),
      ]);
      _tasks = results[0] as List<ReliefTaskModel>;
      _participants = results[1] as List<TaskParticipantModel>;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  bool isUserRegistered(String userId, String taskId) {
    return _participants.any(
      (p) =>
          p.volunteerId == userId &&
          p.taskId == taskId &&
          p.status != 'Cancelled',
    );
  }

  TaskParticipantModel? getUserParticipantRecord(String userId, String taskId) {
    try {
      return _participants.firstWhere(
        (p) =>
            p.volunteerId == userId &&
            p.taskId == taskId &&
            p.status != 'Cancelled',
      );
    } catch (_) {
      return null;
    }
  }

  List<TaskParticipantModel> getParticipantsForUser(String userId) {
    return _participants.where((p) => p.volunteerId == userId).toList();
  }

  List<TaskParticipantModel> getParticipantsForTask(String taskId) {
    return _participants.where((p) => p.taskId == taskId).toList();
  }

  Future<bool> joinTask({
    required ReliefTaskModel task,
    required UserModel user,
    bool isDemoMode = true,
  }) async {
    if (isUserRegistered(user.id, task.id)) {
      _errorMessage = 'You have already applied or registered for this task.';
      notifyListeners();
      return false;
    }

    if (task.isFull) {
      _errorMessage = 'This task has reached its required volunteer capacity.';
      notifyListeners();
      return false;
    }

    try {
      final participant = TaskParticipantModel(
        id: 'PRT-${_uuid.v4().substring(0, 6).toUpperCase()}',
        taskId: task.id,
        taskTitle: task.title,
        volunteerId: user.id,
        volunteerName: user.name,
        volunteerContact: user.phone,
        volunteerSkills: user.skills,
        status: 'Pending',
        joinedAt: DateTime.now(),
      );

      await _repository.joinTask(participant, forceDemo: isDemoMode);
      _participants.add(participant);

      final tIdx = _tasks.indexWhere((t) => t.id == task.id);
      if (tIdx != -1) {
        _tasks[tIdx] = _tasks[tIdx].copyWith(
          currentVolunteers: _tasks[tIdx].currentVolunteers + 1,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelParticipation({
    required String participantId,
    required String taskId,
    bool isDemoMode = true,
  }) async {
    try {
      await _repository.updateParticipantStatus(
        participantId,
        'Cancelled',
        forceDemo: isDemoMode,
      );

      final pIdx = _participants.indexWhere((p) => p.id == participantId);
      if (pIdx != -1) {
        _participants[pIdx] = _participants[pIdx].copyWith(status: 'Cancelled');
      }

      final tIdx = _tasks.indexWhere((t) => t.id == taskId);
      if (tIdx != -1) {
        final task = _tasks[tIdx];
        _tasks[tIdx] = task.copyWith(
          currentVolunteers: (task.currentVolunteers - 1).clamp(
            0,
            task.requiredVolunteers,
          ),
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateParticipantStatus({
    required String participantId,
    required String status,
    bool isDemoMode = true,
  }) async {
    try {
      await _repository.updateParticipantStatus(
        participantId,
        status,
        forceDemo: isDemoMode,
      );

      final pIdx = _participants.indexWhere((p) => p.id == participantId);
      if (pIdx != -1) {
        _participants[pIdx] = _participants[pIdx].copyWith(
          status: status,
          approvedAt: status == 'Approved' ? DateTime.now() : null,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> createTask({
    required String title,
    required String description,
    required String category,
    required String disasterType,
    required String location,
    required int requiredVolunteers,
    required DateTime date,
    required List<String> requiredSkills,
    required String urgencyLevel,
    required String createdBy,
    bool isDemoMode = true,
  }) async {
    try {
      final taskId = 'TSK-2026-${_uuid.v4().substring(0, 4).toUpperCase()}';
      final newTask = ReliefTaskModel(
        id: taskId,
        title: title,
        description: description,
        category: category,
        disasterType: disasterType,
        location: location,
        requiredVolunteers: requiredVolunteers,
        currentVolunteers: 0,
        date: date,
        requiredSkills: requiredSkills,
        urgencyLevel: urgencyLevel,
        status: 'Open',
        createdBy: createdBy,
        createdAt: DateTime.now(),
      );

      await _repository.createTask(newTask, forceDemo: isDemoMode);
      _tasks.insert(0, newTask);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask(
    ReliefTaskModel task, {
    bool isDemoMode = true,
  }) async {
    try {
      await _repository.updateTask(task, forceDemo: isDemoMode);
      final idx = _tasks.indexWhere((t) => t.id == task.id);
      if (idx != -1) {
        _tasks[idx] = task;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
