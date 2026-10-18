import 'package:flutter/foundation.dart';

/// Registration flow status.
enum RegistrationStatus { idle, loading, success, error }

/// Settlement type for the registration form.
enum SettlementType { telebirr, bank }

/// Two-step registration form state.
class RegistrationNotifier extends ChangeNotifier {
  // ── Step 1 — Merchant details ──────────────────────────────────────────────
  String businessName = '';
  String ownerName = '';
  String phone = '';
  String tin = '';
  String businessLicense = '';

  // ── Step 2 — Settlement account ────────────────────────────────────────────
  SettlementType settlementType = SettlementType.telebirr;
  int selectedBankIndex = 0; // 0=CBE, 1=Awash, 2=Dashen, 3=BoA
  int selectedTabIndex = 0;  // 0=Bank Account, 1=Telebirr SuperApp (link_bank_screen)
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
      tin.trim().length >= 8 &&
      businessLicense.trim().isNotEmpty;

  bool get step2Valid => settlementType == SettlementType.telebirr
      ? linkedMobile.trim().length >= 9
      : accountNumber.trim().length >= 10 && linkedMobile.trim().length >= 9;

  void updateBusinessName(String v) { businessName = v; notifyListeners(); }
  void updateOwnerName(String v) { ownerName = v; notifyListeners(); }
  void updatePhone(String v) { phone = v; notifyListeners(); }
  void updateTin(String v) { tin = v; notifyListeners(); }
  void updateBusinessLicense(String v) { businessLicense = v; notifyListeners(); }
  void updateSettlementType(SettlementType t) { settlementType = t; notifyListeners(); }
  void updateTabIndex(int i) { selectedTabIndex = i; notifyListeners(); }
  void updateBankIndex(int i) { selectedBankIndex = i; notifyListeners(); }
  void updateAccountNumber(String v) { accountNumber = v; notifyListeners(); }
  void updateLinkedMobile(String v) { linkedMobile = v; notifyListeners(); }

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
