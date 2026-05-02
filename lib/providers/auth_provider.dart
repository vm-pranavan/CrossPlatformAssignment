import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../services/parse_service.dart';

class AuthProvider extends ChangeNotifier {
  final ParseService _parseService = ParseService();
  ParseUser? _currentUser;
  bool _isLoading = false;

  ParseUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    _currentUser = await _parseService.getCurrentUser();
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    _setLoading(true);
    try {
      final response = await _parseService.login(email, password);
      if (response.success) {
        _currentUser = response.result as ParseUser?;
        notifyListeners();
        return null; // Success
      } else {
        return response.error?.message ?? 'Login failed';
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> signUp(String email, String password) async {
    _setLoading(true);
    try {
      final response = await _parseService.signUp(email, password);
      if (response.success) {
        _currentUser = response.result as ParseUser?;
        notifyListeners();
        return null; // Success
      } else {
        return response.error?.message ?? 'Registration failed';
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _parseService.logout();
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
