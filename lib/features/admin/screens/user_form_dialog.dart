import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/mkes_text_field.dart';
import '../../../shared/widgets/mkes_primary_button.dart';
import '../models/user_profile.dart';
import '../providers/users_provider.dart';

class UserFormDialog extends ConsumerStatefulWidget {
  const UserFormDialog({super.key, this.user});
  final UserProfile? user;

  @override
  ConsumerState<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends ConsumerState<UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _departmentController;
  late final TextEditingController _designationController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  
  String _selectedRole = 'staff';
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get _isCreating => widget.user == null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.fullName);
    _emailController = TextEditingController(text: widget.user?.email);
    _phoneController = TextEditingController(text: widget.user?.phoneNumber);
    _departmentController = TextEditingController(text: widget.user?.department);
    _designationController = TextEditingController(text: widget.user?.designation);
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    if (widget.user != null) {
      _selectedRole = widget.user!.role;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _designationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isCreating) {
        // Create new user
        await ref.read(usersProvider.notifier).createUser(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          department: _departmentController.text.trim().isEmpty ? null : _departmentController.text.trim(),
          designation: _designationController.text.trim().isEmpty ? null : _designationController.text.trim(),
          role: _selectedRole,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User created successfully.')),
          );
        }
      } else {
        // Edit existing user
        await ref.read(usersProvider.notifier).updateUser(widget.user!.id, {
          'full_name': _nameController.text.trim(),
          'phone_number': _phoneController.text.trim(),
          'department': _departmentController.text.trim(),
          'designation': _designationController.text.trim(),
          'role': _selectedRole,
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated.')),
          );
        }
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isCreating ? 'Add New User' : 'Edit User',
                  style: AppTypography.headlineMd,
                ),
                const SizedBox(height: AppSpacing.md),
                MkesTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                MkesTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  enabled: _isCreating, // Prevent editing email for existing users
                  validator: (v) {
                    if (v!.isEmpty) return 'Required';
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(v)) return 'Invalid email format';
                    return null;
                  },
                ),
                // Password fields — only shown when creating a new user
                if (_isCreating) ...[
                  const SizedBox(height: AppSpacing.md),
                  MkesTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hintText: 'Minimum 6 characters',
                    prefixIcon: Icons.lock_outlined,
                    obscureText: _obscurePassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.onSurfaceVariant,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password is required';
                      if (v.length < 6) return 'Minimum 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  MkesTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hintText: 'Re-enter password',
                    prefixIcon: Icons.lock_outlined,
                    obscureText: _obscureConfirmPassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.onSurfaceVariant,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Please confirm the password';
                      if (v != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: MkesTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        validator: (v) {
                          if (v != null && v.isNotEmpty && v.length < 10) {
                            return 'Enter a valid phone number (min 10 digits)';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedRole,
                        decoration: InputDecoration(
                          labelText: 'Role',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'staff', child: Text('Staff')),
                          DropdownMenuItem(value: 'admin', child: Text('Admin')),
                        ],
                        onChanged: (val) {
                          setState(() => _selectedRole = val!);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: MkesTextField(
                        controller: _departmentController,
                        label: 'Department',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: MkesTextField(
                        controller: _designationController,
                        label: 'Designation',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      MkesPrimaryButton(
                        label: _isCreating ? 'Create User' : 'Save Changes',
                        onPressed: _submit,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
