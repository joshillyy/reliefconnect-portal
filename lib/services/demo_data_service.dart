import '../models/user_model.dart';
import '../models/relief_request_model.dart';
import '../models/relief_task_model.dart';
import '../models/task_participant_model.dart';
import '../models/activity_log_model.dart';

class DemoDataService {
  DemoDataService._();
  static final DemoDataService instance = DemoDataService._();

  // In-Memory Collections
  final List<UserModel> _users = [];
  final List<ReliefRequestModel> _requests = [];
  final List<ReliefTaskModel> _tasks = [];
  final List<TaskParticipantModel> _participants = [];
  final List<ActivityLogModel> _activities = [];

  bool _initialized = false;

  void ensureInitialized() {
    if (_initialized) return;
    _seedData();
    _initialized = true;
  }

  void _seedData() {
    final now = DateTime.now();

    // 1. Seed Users
    _users.addAll([
      UserModel(
        id: 'usr_volunteer_1',
        name: 'Aarav Sharma',
        email: 'volunteer@reliefconnect.org',
        phone: '9876543210',
        role: UserRole.volunteer,
        skills: [
          'First Aid & CPR',
          'Driving / Heavy Vehicle',
          'Swimming & Water Rescue',
        ],
        location: 'Guwahati, Assam',
        completedTasksCount: 4,
        createdAt: now.subtract(const Duration(days: 30)),
        isAdminBootstrapVerified: false,
      ),
      UserModel(
        id: 'usr_requester_1',
        name: 'Pooja Verma',
        email: 'requester@reliefconnect.org',
        phone: '9812345678',
        role: UserRole.requester,
        skills: [],
        location: 'Silchar, Cachar District',
        completedTasksCount: 0,
        createdAt: now.subtract(const Duration(days: 20)),
        isAdminBootstrapVerified: false,
      ),
      UserModel(
        id: 'usr_admin_1',
        name: 'Dr. Ananya Sharma',
        email: 'admin@reliefconnect.org',
        phone: '9988776655',
        role: UserRole.admin,
        skills: ['Communication & Coordination', 'Doctor / Nurse / Paramedic'],
        location: 'State Disaster Management Cell',
        completedTasksCount: 15,
        createdAt: now.subtract(const Duration(days: 60)),
        isAdminBootstrapVerified: true,
      ),
      UserModel(
        id: 'usr_volunteer_2',
        name: 'Sunita Reddy',
        email: 'sunita.reddy@example.com',
        phone: '9845012345',
        role: UserRole.volunteer,
        skills: ['Cooking & Mass Catering', 'First Aid & CPR'],
        location: 'Bhubaneswar, Odisha',
        completedTasksCount: 2,
        createdAt: now.subtract(const Duration(days: 15)),
        isAdminBootstrapVerified: false,
      ),
    ]);

    // 2. Seed Relief Requests
    _requests.addAll([
      ReliefRequestModel(
        id: 'REQ-2026-1001',
        requesterId: 'usr_requester_1',
        requesterName: 'Pooja Verma',
        requesterContact: '9812345678',
        disasterCategory: 'Flood',
        exactLocation: 'Ward 4, Near Municipal High School, Silchar',
        assistanceCategory: 'Food Supplies',
        description: 'Water level reached first floor. 12 family members stranded on rooftop without dry ration and drinking water for 36 hours.',
        affectedPeopleCount: 12,
        urgencyLevel: 'Critical',
        status: 'In Progress',
        photoUrl: null,
        createdAt: now.subtract(const Duration(hours: 14)),
        updatedAt: now.subtract(const Duration(hours: 6)),
        adminRemarks: 'Boat dispatched with NDRF team. In progress.',
      ),
      ReliefRequestModel(
        id: 'REQ-2026-1002',
        requesterId: 'usr_requester_2',
        requesterName: 'Manoj Bora',
        requesterContact: '9701122334',
        disasterCategory: 'Landslide',
        exactLocation: 'NH-27 Junction, Haflong Hill Cut',
        assistanceCategory: 'Rescue Support',
        description: 'Hillside mudslide trapped 3 tourist vehicles and a local bus. Road completely blocked. Urgent clearance and medical assessment needed.',
        affectedPeopleCount: 28,
        urgencyLevel: 'Critical',
        status: 'Approved',
        photoUrl: null,
        createdAt: now.subtract(const Duration(hours: 8)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        adminRemarks: 'Assigned to Highway Clearance and First Aid Team.',
      ),
      ReliefRequestModel(
        id: 'REQ-2026-1003',
        requesterId: 'usr_requester_3',
        requesterName: 'Sister Teresa Memorial Orphanage',
        requesterContact: '9435098765',
        disasterCategory: 'Cyclone',
        exactLocation: 'Coastal Road, Sector 3, Puri Sub-division',
        assistanceCategory: 'Temporary Shelter',
        description: 'Asbestos roof blown away by gale winds. Need waterproof tarpaulins, 40 dry blankets, and infant milk powder.',
        affectedPeopleCount: 45,
        urgencyLevel: 'High',
        status: 'Pending',
        photoUrl: null,
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: null,
        adminRemarks: null,
      ),
      ReliefRequestModel(
        id: 'REQ-2026-1004',
        requesterId: 'usr_requester_4',
        requesterName: 'Kishore Das',
        requesterContact: '9123456780',
        disasterCategory: 'Fire',
        exactLocation: 'Old Market Alley, Shop No. 14, Dibrugarh',
        assistanceCategory: 'Medical Assistance',
        description: 'Short circuit fire in market warehouse. 4 workers sustained mild burn injuries and smoke inhalation. Need burn ointment and oxygen support.',
        affectedPeopleCount: 4,
        urgencyLevel: 'High',
        status: 'Completed',
        photoUrl: null,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1)),
        adminRemarks: 'Red Cross First Aid team administered care and transferred to district hospital.',
      ),
      ReliefRequestModel(
        id: 'REQ-2026-1005',
        requesterId: 'usr_requester_1',
        requesterName: 'Pooja Verma',
        requesterContact: '9812345678',
        disasterCategory: 'Flood',
        exactLocation: 'Relief Camp at Community Hall, Silchar',
        assistanceCategory: 'Drinking Water',
        description: 'Groundwater borewell contaminated with flood silt. 150 refugees need 500 liters of potable drinking water and halogen tablets.',
        affectedPeopleCount: 150,
        urgencyLevel: 'Medium',
        status: 'Approved',
        photoUrl: null,
        createdAt: now.subtract(const Duration(hours: 22)),
        updatedAt: now.subtract(const Duration(hours: 10)),
        adminRemarks: 'Water tanker scheduled for delivery at 4:00 PM.',
      ),
    ]);

    // 3. Seed Relief Tasks
    _tasks.addAll([
      ReliefTaskModel(
        id: 'TSK-2026-001',
        title: 'Emergency Flood Evacuation & Boat Support',
        description: 'Assist state disaster management personnel and NDRF in operating inflatable rescue boats, life-jacket distribution, and assisting senior citizens and children from inundated streets.',
        category: 'Rescue & Evacuation',
        disasterType: 'Flood',
        location: 'Barak Riverfront, Silchar East',
        requiredVolunteers: 10,
        currentVolunteers: 6,
        date: now.add(const Duration(days: 1)),
        requiredSkills: ['Swimming & Water Rescue', 'First Aid & CPR'],
        urgencyLevel: 'Critical',
        status: 'Open',
        createdBy: 'usr_admin_1',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      ReliefTaskModel(
        id: 'TSK-2026-002',
        title: 'Community Relief Food & Water Distribution Hub',
        description: 'Package cooked meal packets, sort sealed water bottles, and manage queue distribution for 450 displaced families at the municipal relief depot.',
        category: 'Food & Water Distribution',
        disasterType: 'Flood',
        location: 'City Indoor Stadium, Relief Depot 2',
        requiredVolunteers: 15,
        currentVolunteers: 12,
        date: now.add(const Duration(hours: 18)),
        requiredSkills: ['Cooking & Mass Catering', 'Logistics & Warehousing'],
        urgencyLevel: 'High',
        status: 'Open',
        createdBy: 'usr_admin_1',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      ReliefTaskModel(
        id: 'TSK-2026-003',
        title: 'Medical Triage & First Aid Field Camp',
        description: 'Support attending physicians with vital sign monitoring, dressing flood-borne abrasions, antiseptic cleaning, and ORS distribution.',
        category: 'Medical First Aid',
        disasterType: 'Flood',
        location: 'Zilla Parishad High School Ground',
        requiredVolunteers: 8,
        currentVolunteers: 5,
        date: now.add(const Duration(days: 2)),
        requiredSkills: ['Doctor / Nurse / Paramedic', 'First Aid & CPR'],
        urgencyLevel: 'High',
        status: 'Open',
        createdBy: 'usr_admin_1',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      ReliefTaskModel(
        id: 'TSK-2026-004',
        title: 'Temporary Shelter Setup & Tarpaulin Erection',
        description: 'Erect emergency waterproof tents, assemble portable cots, and set up solar mobile charging stations for cyclone victims.',
        category: 'Shelter Setup',
        disasterType: 'Cyclone',
        location: 'Sub-divisional Sports Complex, Puri',
        requiredVolunteers: 12,
        currentVolunteers: 12, // Full
        date: now.add(const Duration(days: 3)),
        requiredSkills: [
          'Civil Engineering / Construction',
          'Logistics & Warehousing',
        ],
        urgencyLevel: 'Medium',
        status: 'Open',
        createdBy: 'usr_admin_1',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      ReliefTaskModel(
        id: 'TSK-2026-005',
        title: 'Road Debris & Fallen Tree Clearance',
        description: 'Clear fallen tree branches, electrical conduit debris, and mud deposits along emergency ambulance corridors.',
        category: 'Debris Clearance',
        disasterType: 'Cyclone',
        location: 'Grand Coastal Highway KM 14-22',
        requiredVolunteers: 6,
        currentVolunteers: 6,
        date: now.subtract(const Duration(days: 1)),
        requiredSkills: ['Driving / Heavy Vehicle'],
        urgencyLevel: 'Medium',
        status: 'Completed',
        createdBy: 'usr_admin_1',
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    ]);

    // 4. Seed Task Participants
    _participants.addAll([
      TaskParticipantModel(
        id: 'PRT-1001',
        taskId: 'TSK-2026-001',
        taskTitle: 'Emergency Flood Evacuation & Boat Support',
        volunteerId: 'usr_volunteer_1',
        volunteerName: 'Aarav Sharma',
        volunteerContact: '9876543210',
        volunteerSkills: ['First Aid & CPR', 'Swimming & Water Rescue'],
        status: 'Approved',
        joinedAt: now.subtract(const Duration(hours: 20)),
        approvedAt: now.subtract(const Duration(hours: 15)),
      ),
      TaskParticipantModel(
        id: 'PRT-1002',
        taskId: 'TSK-2026-002',
        taskTitle: 'Community Relief Food & Water Distribution Hub',
        volunteerId: 'usr_volunteer_1',
        volunteerName: 'Aarav Sharma',
        volunteerContact: '9876543210',
        volunteerSkills: ['First Aid & CPR'],
        status: 'Pending',
        joinedAt: now.subtract(const Duration(hours: 3)),
        approvedAt: null,
      ),
      TaskParticipantModel(
        id: 'PRT-1003',
        taskId: 'TSK-2026-003',
        taskTitle: 'Medical Triage & First Aid Field Camp',
        volunteerId: 'usr_volunteer_2',
        volunteerName: 'Sunita Reddy',
        volunteerContact: '9845012345',
        volunteerSkills: ['First Aid & CPR'],
        status: 'Approved',
        joinedAt: now.subtract(const Duration(days: 1)),
        approvedAt: now.subtract(const Duration(hours: 18)),
      ),
    ]);

    // 5. Seed Activity Logs
    _activities.addAll([
      ActivityLogModel(
        id: 'ACT-001',
        title: 'Critical Relief Request Submitted',
        details: 'Flood rescue request REQ-2026-1001 submitted for 12 affected individuals in Silchar.',
        timestamp: now.subtract(const Duration(hours: 14)),
        type: 'request_created',
        actorName: 'Pooja Verma',
        actorRole: 'Requester',
      ),
      ActivityLogModel(
        id: 'ACT-002',
        title: 'New Relief Task Published',
        details: 'Task "Emergency Flood Evacuation & Boat Support" posted by Coordinator.',
        timestamp: now.subtract(const Duration(days: 1)),
        type: 'task_created',
        actorName: 'Dr. Ananya Sharma',
        actorRole: 'Administrator',
      ),
      ActivityLogModel(
        id: 'ACT-003',
        title: 'Volunteer Joined Task',
        details: 'Aarav Sharma registered for Emergency Flood Evacuation & Boat Support.',
        timestamp: now.subtract(const Duration(hours: 20)),
        type: 'volunteer_joined',
        actorName: 'Aarav Sharma',
        actorRole: 'Volunteer',
      ),
      ActivityLogModel(
        id: 'ACT-004',
        title: 'Volunteer Approved',
        details:
            'Aarav Sharma was approved by coordinator for Task TSK-2026-001.',
        timestamp: now.subtract(const Duration(hours: 15)),
        type: 'status_updated',
        actorName: 'Dr. Ananya Sharma',
        actorRole: 'Administrator',
      ),
    ]);
  }

  // --- User Operations ---
  List<UserModel> getUsers() {
    ensureInitialized();
    return List.unmodifiable(_users);
  }

  UserModel? getUserById(String id) {
    ensureInitialized();
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  UserModel? getUserByEmail(String email) {
    ensureInitialized();
    try {
      return _users.firstWhere(
        (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  void addUser(UserModel user) {
    ensureInitialized();
    _users.removeWhere((u) => u.id == user.id || u.email == user.email);
    _users.add(user);
  }

  void updateUser(UserModel user) {
    ensureInitialized();
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
  }

  // --- Relief Request Operations ---
  List<ReliefRequestModel> getRequests() {
    ensureInitialized();
    return List.unmodifiable(_requests);
  }

  ReliefRequestModel? getRequestById(String id) {
    ensureInitialized();
    try {
      return _requests.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  void addRequest(ReliefRequestModel request) {
    ensureInitialized();
    _requests.insert(0, request);
    addActivity(
      ActivityLogModel(
        id: 'ACT-${DateTime.now().millisecondsSinceEpoch}',
        title: 'New Relief Request Submitted',
        details: '${request.disasterCategory} request: ${request.description}',
        timestamp: DateTime.now(),
        type: 'request_created',
        actorName: request.requesterName,
        actorRole: 'Requester',
      ),
    );
  }

  void updateRequest(ReliefRequestModel request) {
    ensureInitialized();
    final index = _requests.indexWhere((r) => r.id == request.id);
    if (index != -1) {
      _requests[index] = request;
    }
  }

  void deleteRequest(String id) {
    ensureInitialized();
    _requests.removeWhere((r) => r.id == id);
  }

  // --- Relief Task Operations ---
  List<ReliefTaskModel> getTasks() {
    ensureInitialized();
    return List.unmodifiable(_tasks);
  }

  ReliefTaskModel? getTaskById(String id) {
    ensureInitialized();
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  void addTask(ReliefTaskModel task) {
    ensureInitialized();
    _tasks.insert(0, task);
    addActivity(
      ActivityLogModel(
        id: 'ACT-${DateTime.now().millisecondsSinceEpoch}',
        title: 'New Task Created',
        details: task.title,
        timestamp: DateTime.now(),
        type: 'task_created',
        actorName: 'Coordinator',
        actorRole: 'Administrator',
      ),
    );
  }

  void updateTask(ReliefTaskModel task) {
    ensureInitialized();
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  // --- Task Participant Operations ---
  List<TaskParticipantModel> getParticipants() {
    ensureInitialized();
    return List.unmodifiable(_participants);
  }

  List<TaskParticipantModel> getParticipantsForTask(String taskId) {
    ensureInitialized();
    return _participants.where((p) => p.taskId == taskId).toList();
  }

  List<TaskParticipantModel> getParticipantsForUser(String userId) {
    ensureInitialized();
    return _participants.where((p) => p.volunteerId == userId).toList();
  }

  bool isUserRegisteredForTask(String userId, String taskId) {
    ensureInitialized();
    return _participants.any(
      (p) =>
          p.volunteerId == userId &&
          p.taskId == taskId &&
          p.status != 'Cancelled',
    );
  }

  void addParticipant(TaskParticipantModel participant) {
    ensureInitialized();
    _participants.add(participant);

    // Update current volunteers count on task
    final taskIndex = _tasks.indexWhere((t) => t.id == participant.taskId);
    if (taskIndex != -1) {
      final task = _tasks[taskIndex];
      _tasks[taskIndex] = task.copyWith(
        currentVolunteers: task.currentVolunteers + 1,
      );
    }

    addActivity(
      ActivityLogModel(
        id: 'ACT-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Volunteer Applied for Task',
        details:
            '${participant.volunteerName} applied for ${participant.taskTitle}',
        timestamp: DateTime.now(),
        type: 'volunteer_joined',
        actorName: participant.volunteerName,
        actorRole: 'Volunteer',
      ),
    );
  }

  void updateParticipantStatus(String participantId, String status) {
    ensureInitialized();
    final index = _participants.indexWhere((p) => p.id == participantId);
    if (index != -1) {
      final old = _participants[index];
      _participants[index] = old.copyWith(
        status: status,
        approvedAt: status == 'Approved' ? DateTime.now() : old.approvedAt,
      );

      // If cancelled, decrement task currentVolunteers count
      if (status == 'Cancelled' && old.status != 'Cancelled') {
        final taskIdx = _tasks.indexWhere((t) => t.id == old.taskId);
        if (taskIdx != -1) {
          final task = _tasks[taskIdx];
          _tasks[taskIdx] = task.copyWith(
            currentVolunteers: (task.currentVolunteers - 1).clamp(
              0,
              task.requiredVolunteers,
            ),
          );
        }
      }

      addActivity(
        ActivityLogModel(
          id: 'ACT-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Volunteer Status Updated',
          details:
              '${old.volunteerName} status changed to $status for ${old.taskTitle}',
          timestamp: DateTime.now(),
          type: 'status_updated',
          actorName: 'Coordinator',
          actorRole: 'Administrator',
        ),
      );
    }
  }

  // --- Activity Logs ---
  List<ActivityLogModel> getActivities() {
    ensureInitialized();
    return List.unmodifiable(_activities);
  }

  void addActivity(ActivityLogModel activity) {
    ensureInitialized();
    _activities.insert(0, activity);
    if (_activities.length > 50) {
      _activities.removeLast();
    }
  }
}
