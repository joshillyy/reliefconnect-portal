import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/demo_mode_banner.dart';
import '../../models/user_model.dart';
import '../../navigation/main_scaffold.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _adminCodeController = TextEditingController();

  UserRole _selectedRole = UserRole.volunteer;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _adminCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    final success = await authProv.signUp(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      phone: _phoneController.text.trim(),
      role: _selectedRole,
      adminBootstrapCode: _selectedRole == UserRole.admin
          ? _adminCodeController.text.trim()
          : null,
      isDemoMode: appState.isDemoMode,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Account created as ${_selectedRole.displayName}! Welcome to ReliefConnect.',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScaffold()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProv.errorMessage ?? 'Registration failed. Check details.',
          ),
          backgroundColor: AppColors.emergency,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: Column(
          children: [
            const DemoModeBanner(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 18.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppLogo(size: 40, showText: true),
                      const SizedBox(height: 18),
                      const Text(
                        AppStrings.registerTitle,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        AppStrings.registerSubtitle,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 22),
                      CustomTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        hint: 'e.g. Aarav Sharma',
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (v) => Validators.required(v, 'Full name'),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        hint: 'e.g. volunteer@example.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _phoneController,
                        label: 'Phone Number (10 digits)',
                        hint: 'e.g. 9876543210',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: Validators.phone,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Password (min. 6 characters)',
                        hint: 'Create a secure password',
                        prefixIcon: Icons.lock_outline_rounded,
                        isPassword: true,
                        validator: Validators.password,
                      ),
                      const SizedBox(height: 20),

                      // Role Selection
                      const Text(
                        'Select Your Role',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                          child: DropdownButton<UserRole>(
                            value: _selectedRole,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(
                                value: UserRole.volunteer,
                                child: Text(
                                  'Volunteer (Respond & Help in Relief Tasks)',
                                ),
                              ),
                              DropdownMenuItem(
                                value: UserRole.requester,
                                child: Text(
                                  'Relief Requester / Affected Person',
                                ),
                              ),
                              DropdownMenuItem(
                                value: UserRole.admin,
                                child: Text(
                                  'Administrator / Relief Coordinator (Restricted)',
                                ),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedRole = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      // Administrator Bootstrap Key (Security Requirement)
                      if (_selectedRole == UserRole.admin) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.emergencyLight.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.emergency.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.shield_rounded,
                                    size: 18,
                                    color: AppColors.emergency,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Admin Authorization Required',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.5,
                                      color: AppColors.emergencyDark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Coordinator roles cannot be self-assigned. Enter your relief cell coordinator key. (For faculty evaluation demo: enter RELIEF2026).',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.emergencyDark,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                controller: _adminCodeController,
                                label: 'Coordinator Bootstrap Key',
                                hint: 'e.g. RELIEF2026',
                                prefixIcon: Icons.key_rounded,
                                validator: (val) {
                                  if (_selectedRole == UserRole.admin &&
                                      (val == null || val.trim().isEmpty)) {
                                    return 'Coordinator bootstrap key is required for admin role';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 26),
                      CustomButton(
                        text: 'Create Account',
                        isLoading: authProv.isLoading,
                        onPressed: _handleRegister,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Already have an account? Sign In',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
