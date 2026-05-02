import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Create account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Get started today',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create an account with your student email.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Email address',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _buildInputField(
                    controller: _emailController,
                    hint: 'Enter your student email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email is required';
                      if (!value.contains('@')) return 'Invalid email address';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Password',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _buildInputField(
                    controller: _passwordController,
                    hint: 'Create a password',
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Password is required';
                      if (value.length < 6) return 'At least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Confirm password',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _buildInputField(
                    controller: _confirmPasswordController,
                    hint: 'Confirm your password',
                    isPassword: true,
                    validator: (value) {
                      if (value != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final messenger = ScaffoldMessenger.of(context);
                              final navigator = Navigator.of(context);
                              final error = await authProvider.signUp(
                                _emailController.text.trim(),
                                _passwordController.text,
                              );
                              if (error != null) {
                                if (mounted) {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(error),
                                      backgroundColor: Theme.of(context).colorScheme.error,
                                      behavior: SnackBarBehavior.floating,
                                      margin: const EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  );
                                }
                              } else if (mounted) {
                                navigator.pop();
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Create account',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFF8FAFC)
            : const Color(0xFF0F172A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.light
                ? const Color(0xFFE2E8F0)
                : const Color(0xFF1E293B),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.light
                ? const Color(0xFFE2E8F0)
                : const Color(0xFF1E293B),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
