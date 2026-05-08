import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../storage_services.dart';
import '../../providers/app_session_provider.dart';
import '../../core/theme_extensions.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  String? errorMessage;
  bool isLoading = false;
  String _loadingMessage = 'Logging in...';

  @override
  void initState() {
    super.initState();
    _loadStoredEmail();
    _handleAutofill();
  }

  void _handleAutofill() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra as Map<String, String>?;
      if (extra != null) {
        if (extra['email'] != null) emailController.text = extra['email']!;
        if (extra['password'] != null) passwordController.text = extra['password']!;
        setState(() {});
      }
    });
  }

  Future<void> _loadStoredEmail() async {
    final storedEmail = await StorageService.getEmail();
    final storedPassword = await StorageService.getPassword();

    if (mounted) {
      if (emailController.text.isEmpty && storedEmail != null && storedEmail.isNotEmpty) {
        emailController.text = storedEmail;
      }
      if (passwordController.text.isEmpty && storedPassword != null && storedPassword.isNotEmpty) {
        passwordController.text = storedPassword;
      }
      setState(() {});
    }
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    final input = emailController.text.trim().toLowerCase();
    final isDoctor = input.contains('doctor') || input.contains('professor') || input.contains('dr.');
    setState(() {
      isLoading = true;
      errorMessage = null;
      _loadingMessage = isDoctor
          ? 'Logging in...'
          : 'Connecting to university portal… this may take up to a minute';
    });

    final result = await ref.read(appSessionControllerProvider.notifier).login(
      emailController.text.trim(),
      passwordController.text,
    );

    if (mounted) {
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigation is handled by authStateProvider in main.dart
      } else {
        // Fetch error from state
        final state = ref.read(appSessionControllerProvider);
        String msg = 'Invalid email or password';
        if (state is AppSessionError) {
          msg = state.message;
        }
        
        setState(() {
          errorMessage = msg;
        });
      }
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002147),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 48),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Login with your SSN, Passport number, or Email',
                    style: TextStyle(color: Color(0xFFd1d5db)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        TextFormField(
                          controller: emailController,
                          decoration: _buildInputDecoration('SSN / Passport No. / Email'),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your SSN, Passport No., or Email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          decoration: _buildInputDecoration(
                            'Password',
                            IconButton(
                              icon: Icon(obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () => setState(
                                  () => obscurePassword = !obscurePassword),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF002147),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor:
                                  const Color(0xFF4D7BAF),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Log In',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        if (isLoading) ...[
                          const SizedBox(height: 12),
                          Text(
                            _loadingMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6b7280),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, [Widget? suffix]) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: context.mutedText),
      filled: true,
      fillColor: context.inputFill,
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.borderCol),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF002147), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}
