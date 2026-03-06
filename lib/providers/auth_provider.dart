import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = true;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _initAuth();
  }

  Future<void> _initAuth() async {
    try {
      _authService.authStateChanges.listen((User? user) async {
        if (user != null) {
          _currentUser = await _authService.getUserData(user.uid);
        } else {
          _currentUser = null;
        }
        _isLoading = false;
        notifyListeners();
      });
      
      // Timeout fallback
      await Future.delayed(const Duration(seconds: 3));
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print('Auth initialization error: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _currentUser = await _authService.signIn(email, password);
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      print('AuthProvider signIn error: $e');
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      _currentUser = await _authService.signUp(name, email, password);
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      print('AuthProvider signUp error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('SignOut error: $e');
    }
  }
}
