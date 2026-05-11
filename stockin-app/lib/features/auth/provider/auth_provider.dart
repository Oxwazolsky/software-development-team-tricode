import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/app_user_model.dart';
import '../data/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  AppUserModel? _profile;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AppUserModel? get profile => _profile;

  User? get currentUser => _authService.currentUser;
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<void> loadCurrentUserProfile() async {
    try {
      _profile = await _authService.getCurrentUserProfile();
      notifyListeners();
    } catch (_) {
      _errorMessage = 'Gagal mengambil profil pengguna.';
      notifyListeners();
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String warehouseName,
    String name = '',
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.register(
        email: email,
        password: password,
        warehouseName: warehouseName,
        name: name,
      );

      await loadCurrentUserProfile();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseAuthError(e);
      return false;
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan saat registrasi.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.login(email: email, password: password);
      await loadCurrentUserProfile();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseAuthError(e);
      return false;
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan saat login.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> sendResetPasswordEmail(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.sendResetPasswordEmail(email);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseAuthError(e);
      return false;
    } catch (_) {
      _errorMessage = 'Gagal mengirim email reset password.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _profile = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-not-found':
        return 'Akun tidak ditemukan.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau password salah.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar.';
      case 'weak-password':
        return 'Password terlalu lemah.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah.';
      default:
        return e.message ?? 'Terjadi kesalahan autentikasi.';
    }
  }
}
