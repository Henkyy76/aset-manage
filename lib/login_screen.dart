import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'database_service.dart'; // Now contains AuthService
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PageController _pageController = PageController();
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : Colors.green,
      ),
    );
  }

  Future<void> _performLogin(String email, String password) async {
    setState(() => _isLoading = true);
    try {
      await _authService.login(email: email, password: password);
      if (mounted) {
        // The auth state listener in SplashScreen will handle navigation
      }
    } on AuthException catch (e) {
      _showSnackBar(e.message, isError: true);
    } catch (e) {
      _showSnackBar('An unexpected error occurred: $e', isError: true);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _performSignUp(String email, String password) async {
    setState(() => _isLoading = true);
    try {
      await _authService.signUp(email: email, password: password);
      if (mounted) {
        _showSnackBar('Success! Please check your email for a confirmation link.');
        _pageController.jumpToPage(0); // Switch to login page
      }
    } on AuthException catch (e) {
      _showSnackBar(e.message, isError: true);
    } catch (e) {
      _showSnackBar('An unexpected error occurred: $e', isError: true);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _AuthForm(title: 'Login', buttonText: 'Login', onSubmit: _performLogin, isLoading: _isLoading),
            _AuthForm(title: 'Buat Akun Baru', buttonText: 'Sign Up', onSubmit: _performSignUp, isLoading: _isLoading),
          ],
        ),
      ),
       bottomNavigationBar: _buildToggleButtons(),
    );
  }

   Widget _buildToggleButtons() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Belum punya akun? '),
            TextButton(
              onPressed: _isLoading ? null : () => _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
              child: const Text('Sign Up'),
            ),
             const Text(' | '),
            const Text('Sudah punya akun? '),
            TextButton(
              onPressed: _isLoading ? null : () => _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  final String title;
  final String buttonText;
  final Future<void> Function(String, String) onSubmit;
  final bool isLoading;

  const _AuthForm({
    required this.title,
    required this.buttonText,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    void submit() {
      if (formKey.currentState!.validate()) {
        onSubmit(emailController.text, passwordController.text);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v!.isEmpty ? 'Email tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Password tidak boleh kosong' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : submit,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
