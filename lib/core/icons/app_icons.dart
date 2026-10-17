import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter/widgets.dart';

/// Single source of truth for all icons used in YETMPAY.
/// Swap the underlying icon set here without touching screens.
abstract final class AppIcons {
  static const IconData arrowRight = Symbols.arrow_forward;
  static const IconData arrowLeft = Symbols.arrow_back;
  static const IconData chevronRight = Symbols.chevron_right;
  static const IconData close = Symbols.close;
  static const IconData lock = Symbols.lock;
  static const IconData lockOpen = Symbols.lock_open;
  static const IconData eyeOff = Symbols.visibility_off;
  static const IconData eyeOn = Symbols.visibility;
  static const IconData store = Symbols.store;
  static const IconData person = Symbols.person;
  static const IconData phone = Symbols.phone;
  static const IconData qrCode = Symbols.qr_code;
  static const IconData qrScan = Symbols.qr_code_scanner;
  static const IconData checkCircle = Symbols.check_circle;
  static const IconData check = Symbols.check;
  static const IconData shieldCheck = Symbols.verified_user;
  static const IconData bank = Symbols.account_balance;
  static const IconData copy = Symbols.content_copy;
  static const IconData download = Symbols.download;
  static const IconData notifications = Symbols.notifications;
  static const IconData terminal = Symbols.point_of_sale;
  static const IconData transactions = Symbols.receipt_long;
  static const IconData settings = Symbols.settings;
  static const IconData lightning = Symbols.bolt;
  static const IconData fingerprint = Symbols.fingerprint;
  static const IconData faceId = Symbols.face;
  static const IconData info = Symbols.info;
  static const IconData backspace = Symbols.backspace;
  static const IconData locationPin = Symbols.location_on;
  static const IconData bulb = Symbols.lightbulb;
  static const IconData mobile = Symbols.smartphone;
}

