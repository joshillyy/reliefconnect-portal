import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../models/user_model.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late List<String> _skills;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final user = authProv.currentUser;

    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _locationController = TextEditingController(text: user?.location ?? '');
    _skills = List.from(user?.skills ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final user = authProv.currentUser;

    if (user == null) return;

    setState(() => _isLoading = true);

    final updated = user.copyWith(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      location: _locationController.text.trim(),
      skills: _skills,
    );

    final success = await authProv.updateProfile(
      updated,
      isDemoMode: appState.isDemoMode,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProv.errorMessage ?? 'Failed to update profile.'),
          backgroundColor: AppColors.emergency,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context);
    final user = authProv.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      controller: _nameController,
                      label: 'Full Name',
                      validator: (v) => Validators.required(v, 'Full name'),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _phoneController,
                      label: 'Contact Phone Number',
                      keyboardType: TextInputType.phone,
                      validator: Validators.phone,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _locationController,
                      label: 'Base Location / Relief Zone',
                      hint: 'e.g. Guwahati / Silchar / Puri',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Protected Role Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Role: ${user?.role.displayName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Roles are immutable client-side for system security and administrative verification.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Volunteer Skills
              if (user?.role == UserRole.volunteer) ...[
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
                        'Volunteer Skills & Qualifications',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Select capabilities you can provide in disaster zones:',
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
                          final isSel = _skills.contains(skill);
                          return FilterChip(
                            label: Text(
                              skill,
                              style: const TextStyle(fontSize: 12),
                            ),
                            selected: isSel,
                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  _skills.add(skill);
                                } else {
                                  _skills.remove(skill);
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
              ],

              CustomButton(
                text: 'Save Profile Changes',
                isLoading: _isLoading,
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
