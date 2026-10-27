/// Disaster categories, assistance types, and constants
class AppConstants {
  AppConstants._();

  static const List<String> disasterTypes = [
    'Flood',
    'Cyclone',
    'Earthquake',
    'Fire',
    'Landslide',
    'Drought',
    'Other',
  ];

  static const List<String> assistanceTypes = [
    'Food Supplies',
    'Drinking Water',
    'Temporary Shelter',
    'Clothing & Blankets',
    'Medical Assistance',
    'Rescue Support',
    'Sanitation Kits',
    'Other',
  ];

  static const List<String> urgencyLevels = [
    'Low',
    'Medium',
    'High',
    'Critical',
  ];

  static const List<String> taskCategories = [
    'Rescue & Evacuation',
    'Food & Water Distribution',
    'Medical First Aid',
    'Shelter Setup',
    'Logistics & Transport',
    'Debris Clearance',
    'Counseling & Support',
  ];

  static const List<String> volunteerSkills = [
    'First Aid & CPR',
    'Driving / Heavy Vehicle',
    'Swimming & Water Rescue',
    'Cooking & Mass Catering',
    'Doctor / Nurse / Paramedic',
    'Civil Engineering / Construction',
    'Communication & Coordination',
    'Logistics & Warehousing',
  ];

  // Admin secret invite code for bootstrapping coordinator access in student demo
  static const String adminBootstrapCode = 'RELIEF2026';
}
