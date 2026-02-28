import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (!_isLogin && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your name')));
      return;
    }

    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      bool success;
      if (_isLogin) {
        print('Attempting login...');
        success = await authProvider.signIn(_emailController.text.trim(), _passwordController.text);
        print('Login result: $success');
      } else {
        print('Attempting signup...');
        success = await authProvider.signUp(_nameController.text.trim(), _emailController.text.trim(), _passwordController.text);
        print('Signup result: $success');
      }

      setState(() => _isLoading = false);

      if (success && mounted) {
        print('Success! Navigating to dashboard...');
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (mounted) {
        print('Failed!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isLogin ? 'Login failed. Check email/password.' : 'Signup failed. Try again.'))
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('CityCare', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 16),
              Text(_isLogin ? 'Login' : 'Sign Up', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              if (!_isLogin)
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                ),
              if (!_isLogin) const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
                    ),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin ? 'Create Account' : 'Already have account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
