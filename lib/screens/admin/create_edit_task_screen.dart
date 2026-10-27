import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../models/relief_task_model.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/relief_task_provider.dart';

class CreateEditTaskScreen extends StatefulWidget {
  final ReliefTaskModel? taskToEdit;
  const CreateEditTaskScreen({super.key, this.taskToEdit});

  @override
  State<CreateEditTaskScreen> createState() => _CreateEditTaskScreenState();
}

class _CreateEditTaskScreenState extends State<CreateEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  late TextEditingController _volunteersCountController;

  late String _selectedDisaster;
  late String _selectedCategory;
  late String _selectedUrgency;
  late DateTime _selectedDate;
  late List<String> _selectedSkills;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final edit = widget.taskToEdit;
    _titleController = TextEditingController(text: edit?.title ?? '');
    _descController = TextEditingController(text: edit?.description ?? '');
    _locationController = TextEditingController(text: edit?.location ?? '');
    _volunteersCountController = TextEditingController(
      text: edit != null ? '${edit.requiredVolunteers}' : '10',
    );

    _selectedDisaster = edit?.disasterType ?? AppConstants.disasterTypes.first;
    _selectedCategory = edit?.category ?? AppConstants.taskCategories.first;
    _selectedUrgency = edit?.urgencyLevel ?? 'High';
    _selectedDate = edit?.date ?? DateTime.now().add(const Duration(days: 1));
    _selectedSkills = edit != null
        ? List.from(edit.requiredSkills)
        : ['First Aid & CPR'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _volunteersCountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final taskProv = Provider.of<ReliefTaskProvider>(context, listen: false);
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final user = authProv.currentUser;

    if (user == null) return;

    setState(() => _isSaving = true);

    bool ok;
    if (widget.taskToEdit != null) {
      final updated = widget.taskToEdit!.copyWith(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        category: _selectedCategory,
        disasterType: _selectedDisaster,
        location: _locationController.text.trim(),
        requiredVolunteers:
            int.tryParse(_volunteersCountController.text.trim()) ?? 5,
        date: _selectedDate,
        requiredSkills: _selectedSkills,
        urgencyLevel: _selectedUrgency,
      );
      ok = await taskProv.updateTask(updated, isDemoMode: appState.isDemoMode);
    } else {
      ok = await taskProv.createTask(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        category: _selectedCategory,
        disasterType: _selectedDisaster,
        location: _locationController.text.trim(),
        requiredVolunteers:
            int.tryParse(_volunteersCountController.text.trim()) ?? 5,
        date: _selectedDate,
        requiredSkills: _selectedSkills,
        urgencyLevel: _selectedUrgency,
        createdBy: user.id,
        isDemoMode: appState.isDemoMode,
      );
    }

    setState(() => _isSaving = false);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.taskToEdit != null
                ? 'Relief task updated successfully!'
                : 'New relief operation published for volunteers!',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(taskProv.errorMessage ?? 'Failed to save task.'),
          backgroundColor: AppColors.emergency,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskToEdit != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Relief Task' : 'Publish Relief Operation',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing
                    ? 'Modify Operation Details'
                    : 'Create New Volunteer Task',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Publish coordinated volunteer relief missions to respond to emergency zones.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 18),

              // Title and Description
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _titleController,
                      label: 'Task Title',
                      hint: 'e.g. Emergency Flood Evacuation & Boat Support',
                      validator: (v) => Validators.required(v, 'Task title'),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _descController,
                      label: 'Operation Description & Briefing',
                      hint: 'Specify roles, equipment supplied, field reporting point...',
                      maxLines: 4,
                      validator: (v) => Validators.required(v, 'Description'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Categories & Urgency
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
                    // Disaster Type
                    const Text(
                      'Disaster Type',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedDisaster,
                          isExpanded: true,
                          items: AppConstants.disasterTypes
                              .map(
                                (t) =>
                                    DropdownMenuItem(value: t, child: Text(t)),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null)
                              setState(() => _selectedDisaster = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Task Category
                    const Text(
                      'Task Category',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          items: AppConstants.taskCategories
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null)
                              setState(() => _selectedCategory = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Urgency Level
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
                      children: AppConstants.urgencyLevels.map((u) {
                        final isSel = _selectedUrgency == u;
                        return ChoiceChip(
                          label: Text(u),
                          selected: isSel,
                          onSelected: (val) {
                            if (val) setState(() => _selectedUrgency = u);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Location, Date, Volunteer Count
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
                      label: 'Exact Deployment Location',
                      hint: 'e.g. Barak Riverfront, Silchar East',
                      prefixIcon: Icons.location_on_outlined,
                      validator: (v) => Validators.required(v, 'Location'),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _volunteersCountController,
                      label: 'Required Volunteer Capacity',
                      hint: 'e.g. 10',
                      prefixIcon: Icons.group_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          Validators.positiveInteger(v, 'Capacity count'),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Operation Date',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              DateFormatter.formatDate(_selectedDate),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'Change',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Required Skills
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
                      'Required Volunteer Skills',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Select all skills beneficial for this mission:',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: AppConstants.volunteerSkills.map((skill) {
                        final isSel = _selectedSkills.contains(skill);
                        return FilterChip(
                          label: Text(
                            skill,
                            style: const TextStyle(fontSize: 12),
                          ),
                          selected: isSel,
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                _selectedSkills.add(skill);
                              } else {
                                _selectedSkills.remove(skill);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: isEditing ? 'Save Changes' : 'Publish Relief Operation',
                icon: Icons.check_rounded,
                isLoading: _isSaving,
                onPressed: _handleSave,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
