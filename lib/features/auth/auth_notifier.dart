import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Demo login states.
enum AuthStatus { idle, loading, success, error, lockedOut }

/// Handles demo authentication with attempt lockout.
///
/// In debug builds any non-empty credentials succeed.
/// After [_maxAttempts] failures the user is locked out for [_lockoutSeconds].
/// Session token is persisted in [FlutterSecureStorage].
class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    _checkExistingSession();
  }

  static const _storage = FlutterSecureStorage();
  static const _sessionKey = 'session_token';
  static const _demoToken = 'demo_session_2024';
  static const _maxAttempts = 5;
  static const _lockoutSeconds = 30;

  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;
  int _failedAttempts = 0;
  Timer? _lockoutTimer;
  int _lockoutRemaining = 0;
  bool _isLoggedIn = false;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  int get lockoutRemaining => _lockoutRemaining;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLockedOut => _status == AuthStatus.lockedOut;

  Future<void> _checkExistingSession() async {
    final token = await _storage.read(key: _sessionKey);
    if (token == _demoToken) {
      _isLoggedIn = true;
      _status = AuthStatus.success;
      notifyListeners();
    }
  }

  Future<bool> login(String identifier, String password) async {
    if (_status == AuthStatus.lockedOut) return false;

    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    // Simulate network delay.
    await Future<void>.delayed(const Duration(milliseconds: 800));

    // In debug: any non-empty credentials work.
    final isValid = kDebugMode
        ? (identifier.isNotEmpty && password.isNotEmpty)
        : false; // production would validate against a real API

    if (isValid) {
      await _storage.write(key: _sessionKey, value: _demoToken);
      _failedAttempts = 0;
      _isLoggedIn = true;
      _status = AuthStatus.success;
      notifyListeners();
      return true;
    } else {
      _failedAttempts++;
      if (_failedAttempts >= _maxAttempts) {
        _startLockout();
      } else {
        _status = AuthStatus.error;
        _errorMessage = kDebugMode
            ? 'Demo mode: enter any credentials'
            : 'Invalid credentials. ${_maxAttempts - _failedAttempts} attempts remaining.';
      }
      notifyListeners();
      return false;
    }
  }

  void _startLockout() {
    _status = AuthStatus.lockedOut;
    _lockoutRemaining = _lockoutSeconds;
    _lockoutTimer?.cancel();
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      _lockoutRemaining--;
      if (_lockoutRemaining <= 0) {
        t.cancel();
        _failedAttempts = 0;
        _status = AuthStatus.idle;
      }
      notifyListeners();
    });
  }

  Future<void> logout() async {
    await _storage.delete(key: _sessionKey);
    _isLoggedIn = false;
    _status = AuthStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _lockoutTimer?.cancel();
    super.dispose();
  }
}

