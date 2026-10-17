import 'package:flutter/foundation.dart';

/// Registration flow status.
enum RegistrationStatus { idle, loading, success, error }

/// Two-step registration form state:
/// Step 1 — merchant details, Step 2 — bank account linking.
class RegistrationNotifier extends ChangeNotifier {
  // ── Step 1 — Merchant details ──────────────────────────────────────────────
  String businessName = '';
  String ownerName = '';
  String phone = '';
  String pin = '';

  // ── Step 2 — Bank linking ──────────────────────────────────────────────────
  int selectedBankIndex = 0; // 0=CBE, 1=Awash, 2=Dashen, 3=BoA
  int selectedTabIndex = 0; // 0=Bank Account, 1=Telebirr SuperApp
  String accountNumber = '';
  String linkedMobile = '';

  RegistrationStatus _status = RegistrationStatus.idle;
  String? _errorMessage;

  RegistrationStatus get status => _status;
  String? get errorMessage => _errorMessage;

  bool get step1Valid =>
      businessName.trim().isNotEmpty &&
      ownerName.trim().isNotEmpty &&
      phone.trim().length >= 9 &&
      pin.trim().length >= 4;

  bool get step2Valid =>
      accountNumber.trim().length == 13 && linkedMobile.trim().isNotEmpty;

  void updateBusinessName(String v) {
    businessName = v;
    notifyListeners();
  }

  void updateOwnerName(String v) {
    ownerName = v;
    notifyListeners();
  }

  void updatePhone(String v) {
    phone = v;
    notifyListeners();
  }

  void updatePin(String v) {
    pin = v;
    notifyListeners();
  }

  void updateBankIndex(int i) {
    selectedBankIndex = i;
    notifyListeners();
  }

  void updateTabIndex(int i) {
    selectedTabIndex = i;
    notifyListeners();
  }

  void updateAccountNumber(String v) {
    accountNumber = v;
    notifyListeners();
  }

  void updateLinkedMobile(String v) {
    linkedMobile = v;
    notifyListeners();
  }

  Future<bool> submitStep1() async {
    if (!step1Valid) return false;
    _status = RegistrationStatus.loading;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _status = RegistrationStatus.success;
    notifyListeners();
    return true;
  }

  Future<bool> submitStep2() async {
    if (!step2Valid) return false;
    _status = RegistrationStatus.loading;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 800));
    _status = RegistrationStatus.success;
    notifyListeners();
    return true;
  }
}

