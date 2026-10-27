import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/emergency_alert_card.dart';
import '../../navigation/main_scaffold.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/relief_request_provider.dart';

class SubmitRequestScreen extends StatefulWidget {
  const SubmitRequestScreen({super.key});

  @override
  State<SubmitRequestScreen> createState() => _SubmitRequestScreenState();
}

class _SubmitRequestScreenState extends State<SubmitRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _affectedCountController = TextEditingController(text: '1');

  String _selectedDisaster = AppConstants.disasterTypes.first;
  String _selectedAssistance = AppConstants.assistanceTypes.first;
  String _selectedUrgency = 'High';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final user = authProv.currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _contactController.text = user.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _affectedCountController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final reqProv = Provider.of<ReliefRequestProvider>(context, listen: false);
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    final user = authProv.currentUser;
    if (user == null) return;

    setState(() => _isSubmitting = true);

    final success = await reqProv.submitRequest(
      requesterId: user.id,
      requesterName: _nameController.text.trim(),
      requesterContact: _contactController.text.trim(),
      disasterCategory: _selectedDisaster,
      exactLocation: _locationController.text.trim(),
      assistanceCategory: _selectedAssistance,
      description: _descriptionController.text.trim(),
      affectedPeopleCount:
          int.tryParse(_affectedCountController.text.trim()) ?? 1,
      urgencyLevel: _selectedUrgency,
      photoUrl: null,
      isDemoMode: appState.isDemoMode,
    );

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          icon: const Icon(
            Icons.check_circle_outline,
            color: AppColors.success,
            size: 48,
          ),
          title: const Text('Relief Request Submitted'),
          content: const Text(
            'Your emergency request has been registered in the database and dispatched to the relief coordinator queue.\n\n'
            'You can track status updates and coordinator response under "My Requests".',
            style: TextStyle(fontSize: 13.5, height: 1.4),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MainScaffold(initialIndex: 1),
                  ),
                );
              },
              child: const Text('View My Requests'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(reqProv.errorMessage ?? 'Submission failed.'),
          backgroundColor: AppColors.emergency,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Submit Relief Request')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const EmergencyAlertCard(),
              const SizedBox(height: 16),

              const Text(
                'Emergency Situation Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Please provide accurate on-ground details so disaster response teams can coordinate aid effectively.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Requester Contact Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Requester Contact Information',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _nameController,
                      label: 'Requester / Organization Name',
                      hint: 'e.g. Pooja Verma / Ward Relief Volunteer',
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (v) =>
                          Validators.required(v, 'Requester name'),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _contactController,
                      label: 'Emergency Phone Number',
                      hint: '10-digit reachable mobile number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: Validators.phone,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Disaster & Assistance Dropdowns
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Incident & Supply Requirements',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Disaster Category
                    const Text(
                      'Disaster Category',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.cardBorder),
                        color: AppColors.surfaceVariant.withOpacity(0.4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedDisaster,
                          isExpanded: true,
                          items: AppConstants.disasterTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null)
                              setState(() => _selectedDisaster = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Assistance Type
                    const Text(
                      'Primary Assistance Needed',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.cardBorder),
                        color: AppColors.surfaceVariant.withOpacity(0.4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedAssistance,
                          isExpanded: true,
                          items: AppConstants.assistanceTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null)
                              setState(() => _selectedAssistance = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Urgency Level Selector
                    const Text(
                      'Urgency Level',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: AppConstants.urgencyLevels.map((urgency) {
                        final isSelected = _selectedUrgency == urgency;
                        Color color;
                        switch (urgency) {
                          case 'Critical':
                            color = AppColors.urgencyCritical;
                            break;
                          case 'High':
                            color = AppColors.urgencyHigh;
                            break;
                          case 'Medium':
                            color = AppColors.urgencyMedium;
                            break;
                          case 'Low':
                          default:
                            color = AppColors.urgencyLow;
                            break;
                        }
                        return ChoiceChip(
                          label: Text(urgency),
                          selected: isSelected,
                          selectedColor: color.withOpacity(0.2),
                          side: BorderSide(
                            color: isSelected ? color : AppColors.cardBorder,
                          ),
                          labelStyle: TextStyle(
                            color: isSelected ? color : AppColors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _selectedUrgency = urgency);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Location, Description & Number of People
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: _locationController,
                      label: 'Exact Location / Landmark',
                      hint: 'e.g. Ward 4, Near Municipal High School, Silchar',
                      prefixIcon: Icons.location_on_outlined,
                      validator: (v) =>
                          Validators.required(v, 'Exact location'),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _affectedCountController,
                      label: 'Number of People Affected',
                      hint: 'e.g. 12',
                      prefixIcon: Icons.people_outline_rounded,
                      keyboardType: TextInputType.number,
                      validator: (v) => Validators.positiveInteger(
                        v,
                        'Affected people count',
                      ),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _descriptionController,
                      label: 'Situation Description & Urgent Needs',
                      hint: 'Describe condition, trapped individuals, road access, special medical needs...',
                      prefixIcon: Icons.description_outlined,
                      maxLines: 4,
                      validator: (v) =>
                          Validators.required(v, 'Situation description'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: 'Submit Emergency Request',
                icon: Icons.send_rounded,
                isLoading: _isSubmitting,
                onPressed: _handleSubmit,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
