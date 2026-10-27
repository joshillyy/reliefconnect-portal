import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/relief_request_model.dart';
import '../repositories/relief_request_repository.dart';

class ReliefRequestProvider extends ChangeNotifier {
  final ReliefRequestRepository _repository = ReliefRequestRepository();
  final _uuid = const Uuid();

  List<ReliefRequestModel> _requests = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Filters
  String _searchQuery = '';
  String? _selectedDisasterType;
  String? _selectedUrgency;
  String? _selectedStatus;

  List<ReliefRequestModel> get allRequests => _requests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;
  String? get selectedDisasterType => _selectedDisasterType;
  String? get selectedUrgency => _selectedUrgency;
  String? get selectedStatus => _selectedStatus;

  // Filtered List
  List<ReliefRequestModel> get filteredRequests {
    return _requests.where((r) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          r.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.exactLocation.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.requesterName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.id.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesDisaster =
          _selectedDisasterType == null ||
          _selectedDisasterType == 'All' ||
          r.disasterCategory.toLowerCase() ==
              _selectedDisasterType!.toLowerCase();

      final matchesUrgency =
          _selectedUrgency == null ||
          _selectedUrgency == 'All' ||
          r.urgencyLevel.toLowerCase() == _selectedUrgency!.toLowerCase();

      final matchesStatus =
          _selectedStatus == null ||
          _selectedStatus == 'All' ||
          r.status.toLowerCase() == _selectedStatus!.toLowerCase();

      return matchesSearch &&
          matchesDisaster &&
          matchesUrgency &&
          matchesStatus;
    }).toList();
  }

  // Dashboard Statistics
  int get totalRequestsCount => _requests.length;
  int get pendingRequestsCount =>
      _requests.where((r) => r.status == 'Pending').length;
  int get criticalRequestsCount =>
      _requests.where((r) => r.urgencyLevel == 'Critical').length;
  int get inProgressRequestsCount =>
      _requests.where((r) => r.status == 'In Progress').length;
  int get resolvedRequestsCount =>
      _requests.where((r) => r.status == 'Completed').length;

  void setSearchQuery(String query) {
    _searchQuery = query;
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

  void setFilterStatus(String? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedDisasterType = null;
    _selectedUrgency = null;
    _selectedStatus = null;
    notifyListeners();
  }

  Future<void> fetchRequests({bool isDemoMode = true}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _requests = await _repository.getAllRequests(forceDemo: isDemoMode);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  List<ReliefRequestModel> getRequestsForUser(String userId) {
    return _requests.where((r) => r.requesterId == userId).toList();
  }

  Future<bool> submitRequest({
    required String requesterId,
    required String requesterName,
    required String requesterContact,
    required String disasterCategory,
    required String exactLocation,
    required String assistanceCategory,
    required String description,
    required int affectedPeopleCount,
    required String urgencyLevel,
    String? photoUrl,
    bool isDemoMode = true,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final reqId = 'REQ-2026-${_uuid.v4().substring(0, 4).toUpperCase()}';
      final newReq = ReliefRequestModel(
        id: reqId,
        requesterId: requesterId,
        requesterName: requesterName,
        requesterContact: requesterContact,
        disasterCategory: disasterCategory,
        exactLocation: exactLocation,
        assistanceCategory: assistanceCategory,
        description: description,
        affectedPeopleCount: affectedPeopleCount,
        urgencyLevel: urgencyLevel,
        status: 'Pending',
        photoUrl: photoUrl,
        createdAt: DateTime.now(),
      );

      await _repository.createRequest(newReq, forceDemo: isDemoMode);
      _requests.insert(0, newReq);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateRequestStatus(
    String requestId,
    String newStatus, {
    String? adminRemarks,
    bool isDemoMode = true,
  }) async {
    try {
      await _repository.updateRequestStatus(
        requestId,
        newStatus,
        adminRemarks: adminRemarks,
        forceDemo: isDemoMode,
      );

      final index = _requests.indexWhere((r) => r.id == requestId);
      if (index != -1) {
        _requests[index] = _requests[index].copyWith(
          status: newStatus,
          adminRemarks: adminRemarks,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteRequest(String requestId, {bool isDemoMode = true}) async {
    try {
      await _repository.deleteRequest(requestId, forceDemo: isDemoMode);
      _requests.removeWhere((r) => r.id == requestId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
