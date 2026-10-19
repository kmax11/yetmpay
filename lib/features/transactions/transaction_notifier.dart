import 'package:flutter/foundation.dart';
import '../charging/payment_notifier.dart' show ConsentRecord;

class TransactionItem {
  TransactionItem({
    required this.id,
    required this.customerName,
    required this.customerInitials,
    required this.amount,
    required this.rail,
    required this.time,
    required this.timestamp,
    required this.maskedAccount,
    required this.channel,
    required this.isPaid,
    required this.date,
    this.failureReason,
  });

  final String id;
  final String customerName;
  final String customerInitials;
  final double amount;
  final String rail;
  final String time;
  final String timestamp;
  final String maskedAccount;
  final String channel;
  final bool isPaid;
  final DateTime date;
  final String? failureReason;

  static String formatAmount(double val) {
    final parts = val.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    final formattedInt = integerPart.replaceAll(reg, ',');
    return '$formattedInt.$decimalPart';
  }

  String get formattedAmount =>
      '${isPaid ? '+' : ''}${formatAmount(amount)} ETB';
}

enum TransactionFilter { today, thisWeek, thisMonth }

/// Helper: build a DateTime for [daysAgo] days back, at [hour]:[minute].
DateTime _daysAgo(int days, int hour, int minute) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day - days, hour, minute);
}

/// Helper: format a DateTime as a display time string, e.g. "2:45 PM".
String _fmt12(DateTime dt) {
  final h = dt.hour > 12
      ? dt.hour - 12
      : (dt.hour == 0 ? 12 : dt.hour);
  final ampm = dt.hour >= 12 ? 'PM' : 'AM';
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m $ampm';
}

/// Helper: format a DateTime as a full timestamp string.
String _fmtTimestamp(DateTime dt) {
  final now = DateTime.now();
  final isToday = dt.year == now.year &&
      dt.month == now.month &&
      dt.day == now.day;
  if (isToday) {
    return 'Today, ${_fmt12(dt)}';
  }
  final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final diff = now.difference(dt).inDays;
  if (diff < 7) {
    // Same week — show weekday + time
    return '${weekdays[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}, ${_fmt12(dt)}';
  }
  // Older — just date + time
  return '${months[dt.month - 1]} ${dt.day}, ${_fmt12(dt)}';
}

class TransactionNotifier extends ChangeNotifier {
  static String formatAmount(double val) => TransactionItem.formatAmount(val);

  TransactionFilter _selectedFilter = TransactionFilter.today;
  String _searchQuery = '';
  TransactionItem? _selectedTransaction;

  final List<TransactionItem> _allTransactions = () {
    final now = DateTime.now();

    // ── TODAY transactions ────────────────────────────────────────────────────
    final todayData = [
      (
        id: 'TX-984321-ET',
        name: 'Abebe K.',
        initials: 'AK',
        amount: 350.00,
        rail: 'Telebirr',
        account: '+251 91 •••• 284',
        channel: 'Telebirr QR Push',
        paid: true,
        failure: null as String?,
        date: _daysAgo(0, 14, 45),
      ),
      (
        id: 'TX-984320-ET',
        name: 'Selam D.',
        initials: 'SD',
        amount: 1200.00,
        rail: 'CBE Birr',
        account: '+251 92 •••• 192',
        channel: 'CBE Birr Instant',
        paid: true,
        failure: null as String?,
        date: _daysAgo(0, 13, 15),
      ),
      (
        id: 'TX-984319-ET',
        name: 'Hana T.',
        initials: 'HT',
        amount: 450.00,
        rail: 'Awash Bank',
        account: '+251 94 •••• 881',
        channel: 'Awash Instant Rail',
        paid: false,
        failure: 'ERR_BIO_MISMATCH (Confidence 42% < 85%)',
        date: _daysAgo(0, 11, 30),
      ),
      (
        id: 'TX-984318-ET',
        name: 'Dawit A.',
        initials: 'DA',
        amount: 80.00,
        rail: 'Dashen Amole',
        account: '+251 93 •••• 502',
        channel: 'Dashen Amole Instant',
        paid: true,
        failure: null as String?,
        date: _daysAgo(0, 10, 5),
      ),
      (
        id: 'TX-984317-ET',
        name: 'Mekdes B.',
        initials: 'MB',
        amount: 620.00,
        rail: 'Telebirr',
        account: '+251 91 •••• 773',
        channel: 'Telebirr QR Push',
        paid: true,
        failure: null as String?,
        date: _daysAgo(0, 9, 0),
      ),
    ];

    // ── THIS WEEK transactions (2-6 days ago) ────────────────────────────────
    final weekData = [
      (
        id: 'TX-984316-ET',
        name: 'Yonas G.',
        initials: 'YG',
        amount: 2400.00,
        rail: 'CBE Birr',
        account: '+251 92 •••• 441',
        channel: 'CBE Birr Instant',
        paid: true,
        failure: null as String?,
        date: _daysAgo(1, 16, 20),
      ),
      (
        id: 'TX-984315-ET',
        name: 'Tigist H.',
        initials: 'TH',
        amount: 155.00,
        rail: 'Telebirr',
        account: '+251 91 •••• 334',
        channel: 'Telebirr QR Push',
        paid: true,
        failure: null as String?,
        date: _daysAgo(1, 11, 50),
      ),
      (
        id: 'TX-984314-ET',
        name: 'Solomon W.',
        initials: 'SW',
        amount: 3100.00,
        rail: 'Awash Bank',
        account: '+251 94 •••• 112',
        channel: 'Awash Instant Rail',
        paid: false,
        failure: 'ERR_TIMEOUT — Bank gateway unreachable',
        date: _daysAgo(2, 15, 10),
      ),
      (
        id: 'TX-984313-ET',
        name: 'Almaz T.',
        initials: 'AT',
        amount: 480.00,
        rail: 'Dashen Amole',
        account: '+251 93 •••• 667',
        channel: 'Dashen Amole Instant',
        paid: true,
        failure: null as String?,
        date: _daysAgo(2, 9, 35),
      ),
      (
        id: 'TX-984312-ET',
        name: 'Bereket M.',
        initials: 'BM',
        amount: 900.00,
        rail: 'Telebirr',
        account: '+251 91 •••• 988',
        channel: 'Telebirr QR Push',
        paid: true,
        failure: null as String?,
        date: _daysAgo(3, 13, 55),
      ),
      (
        id: 'TX-984311-ET',
        name: 'Liya F.',
        initials: 'LF',
        amount: 70.00,
        rail: 'CBE Birr',
        account: '+251 92 •••• 209',
        channel: 'CBE Birr Instant',
        paid: true,
        failure: null as String?,
        date: _daysAgo(3, 8, 15),
      ),
      (
        id: 'TX-984310-ET',
        name: 'Henok S.',
        initials: 'HS',
        amount: 1750.00,
        rail: 'Awash Bank',
        account: '+251 94 •••• 543',
        channel: 'Awash Instant Rail',
        paid: true,
        failure: null as String?,
        date: _daysAgo(4, 17, 40),
      ),
      (
        id: 'TX-984309-ET',
        name: 'Marta G.',
        initials: 'MG',
        amount: 220.00,
        rail: 'Telebirr',
        account: '+251 91 •••• 874',
        channel: 'Telebirr QR Push',
        paid: false,
        failure: 'ERR_BIO_MISMATCH (Confidence 38% < 85%)',
        date: _daysAgo(5, 12, 5),
      ),
      (
        id: 'TX-984308-ET',
        name: 'Kebede R.',
        initials: 'KR',
        amount: 560.00,
        rail: 'Dashen Amole',
        account: '+251 93 •••• 329',
        channel: 'Dashen Amole Instant',
        paid: true,
        failure: null as String?,
        date: _daysAgo(6, 10, 20),
      ),
    ];

    // ── THIS MONTH transactions (7-28 days ago) ──────────────────────────────
    final monthData = [
      (
        id: 'TX-984307-ET',
        name: 'Fikirte A.',
        initials: 'FA',
        amount: 5800.00,
        rail: 'CBE Birr',
        account: '+251 92 •••• 651',
        channel: 'CBE Birr Instant',
        paid: true,
        failure: null as String?,
        date: _daysAgo(7, 14, 30),
      ),
      (
        id: 'TX-984306-ET',
        name: 'Natnael D.',
        initials: 'ND',
        amount: 1100.00,
        rail: 'Telebirr',
        account: '+251 91 •••• 472',
        channel: 'Telebirr QR Push',
        paid: true,
        failure: null as String?,
        date: _daysAgo(8, 9, 45),
      ),
      (
        id: 'TX-984305-ET',
        name: 'Rahel E.',
        initials: 'RE',
        amount: 340.00,
        rail: 'Awash Bank',
        account: '+251 94 •••• 236',
        channel: 'Awash Instant Rail',
        paid: true,
        failure: null as String?,
        date: _daysAgo(9, 16, 10),
      ),
      (
        id: 'TX-984304-ET',
        name: 'Biniam Y.',
        initials: 'BY',
        amount: 2600.00,
        rail: 'Dashen Amole',
        account: '+251 93 •••• 815',
        channel: 'Dashen Amole Instant',
        paid: false,
        failure: 'ERR_INSUFFICIENT_BALANCE — Wallet balance low',
        date: _daysAgo(10, 11, 0),
      ),
      (
        id: 'TX-984303-ET',
        name: 'Tsehay M.',
        initials: 'TM',
        amount: 720.00,
        rail: 'Telebirr',
        account: '+251 91 •••• 119',
        channel: 'Telebirr QR Push',
        paid: true,
        failure: null as String?,
        date: _daysAgo(11, 13, 25),
      ),
      (
        id: 'TX-984302-ET',
        name: 'Ermias K.',
        initials: 'EK',
        amount: 4300.00,
        rail: 'CBE Birr',
        account: '+251 92 •••• 703',
        channel: 'CBE Birr Instant',
        paid: true,
        failure: null as String?,
        date: _daysAgo(13, 10, 50),
      ),
      (
        id: 'TX-984301-ET',
        name: 'Hiwot Z.',
        initials: 'HZ',
        amount: 190.00,
        rail: 'Awash Bank',
        account: '+251 94 •••• 907',
        channel: 'Awash Instant Rail',
        paid: true,
        failure: null as String?,
        date: _daysAgo(15, 8, 30),
      ),
      (
        id: 'TX-984300-ET',
        name: 'Selamawit B.',
        initials: 'SB',
        amount: 860.00,
        rail: 'Dashen Amole',
        account: '+251 93 •••• 461',
        channel: 'Dashen Amole Instant',
        paid: true,
        failure: null as String?,
        date: _daysAgo(16, 15, 15),
      ),
      (
        id: 'TX-984299-ET',
        name: 'Tewodros A.',
        initials: 'TA',
        amount: 3500.00,
        rail: 'Telebirr',
        account: '+251 91 •••• 638',
        channel: 'Telebirr QR Push',
        paid: true,
        failure: null as String?,
        date: _daysAgo(18, 12, 40),
      ),
      (
        id: 'TX-984298-ET',
        name: 'Azeb W.',
        initials: 'AW',
        amount: 500.00,
        rail: 'CBE Birr',
        account: '+251 92 •••• 025',
        channel: 'CBE Birr Instant',
        paid: false,
        failure: 'ERR_BIO_MISMATCH (Confidence 51% < 85%)',
        date: _daysAgo(20, 9, 5),
      ),
      (
        id: 'TX-984297-ET',
        name: 'Girma H.',
        initials: 'GH',
        amount: 1400.00,
        rail: 'Awash Bank',
        account: '+251 94 •••• 387',
        channel: 'Awash Instant Rail',
        paid: true,
        failure: null as String?,
        date: _daysAgo(22, 17, 0),
      ),
      (
        id: 'TX-984296-ET',
        name: 'Meseret F.',
        initials: 'MF',
        amount: 95.00,
        rail: 'Telebirr',
        account: '+251 91 •••• 744',
        channel: 'Telebirr QR Push',
        paid: true,
        failure: null as String?,
        date: _daysAgo(24, 14, 20),
      ),
      (
        id: 'TX-984295-ET',
        name: 'Amanuel T.',
        initials: 'AT',
        amount: 2900.00,
        rail: 'Dashen Amole',
        account: '+251 93 •••• 953',
        channel: 'Dashen Amole Instant',
        paid: true,
        failure: null as String?,
        date: _daysAgo(26, 11, 35),
      ),
      (
        id: 'TX-984294-ET',
        name: 'Wubet G.',
        initials: 'WG',
        amount: 640.00,
        rail: 'CBE Birr',
        account: '+251 92 •••• 814',
        channel: 'CBE Birr Instant',
        paid: true,
        failure: null as String?,
        date: _daysAgo(27, 8, 50),
      ),
      (
        id: 'TX-984293-ET',
        name: 'Kidist L.',
        initials: 'KL',
        amount: 1950.00,
        rail: 'Awash Bank',
        account: '+251 94 •••• 162',
        channel: 'Awash Instant Rail',
        paid: true,
        failure: null as String?,
        date: _daysAgo(28, 16, 5),
      ),
    ];

    List<TransactionItem> build(dynamic list) {
      return (list as List).map((e) {
        return TransactionItem(
          id: e.id,
          customerName: e.name,
          customerInitials: e.initials,
          amount: e.amount,
          rail: e.rail,
          time: _fmt12(e.date),
          timestamp: _fmtTimestamp(e.date),
          maskedAccount: e.account,
          channel: e.channel,
          isPaid: e.paid,
          date: e.date,
          failureReason: e.failure,
        );
      }).toList();
    }

    // Return all combined, sorted newest-first
    return [
      ...build(todayData),
      ...build(weekData),
      ...build(monthData),
    ];
  }();

  TransactionNotifier() {
    _selectedTransaction = _allTransactions.first;
  }

  void recordTransaction({
    required double amount,
    required String rail,
    required String customerName,
    required String maskedAccount,
    required String channel,
  }) {
    final now = DateTime.now();
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    final timeStr = _fmt12(now);
    final timestampStr =
        'Today, ${now.hour.toString().padLeft(2, '0')}:$minute:$second EAT';

    final id =
        'TXN-${now.millisecondsSinceEpoch.toString().substring(4)}-ET';
    final initials = customerName
        .trim()
        .split(' ')
        .map((p) => p.isNotEmpty ? p[0].toUpperCase() : '')
        .take(2)
        .join();

    final newTx = TransactionItem(
      id: id,
      customerName: customerName,
      customerInitials: initials.isEmpty ? 'YM' : initials,
      amount: amount,
      rail: rail,
      time: timeStr,
      timestamp: timestampStr,
      maskedAccount: maskedAccount,
      channel: channel,
      isPaid: true,
      date: now,
    );

    _allTransactions.insert(0, newTx);
    _selectedTransaction = newTx;
    notifyListeners();
  }

  TransactionFilter get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;
  TransactionItem? get selectedTransaction => _selectedTransaction;
  List<TransactionItem> get allTransactions => List.unmodifiable(_allTransactions);

  /// Volume for the currently active filter (used on the Transactions screen).
  double get settledVolumeForFilter => filteredTransactions
      .where((t) => t.isPaid)
      .fold(0.0, (sum, t) => sum + t.amount);

  /// Today-only volume — kept for ChargingScreen compatibility.
  double get todaySettledVolume {
    final now = DateTime.now();
    return _allTransactions
        .where((t) =>
            t.isPaid &&
            t.date.year == now.year &&
            t.date.month == now.month &&
            t.date.day == now.day)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  List<TransactionItem> get filteredTransactions {
    final now = DateTime.now();
    return _allTransactions.where((t) {
      // ── Date filter ──────────────────────────────────────────────────────
      final bool dateMatch;
      switch (_selectedFilter) {
        case TransactionFilter.today:
          dateMatch = t.date.year == now.year &&
              t.date.month == now.month &&
              t.date.day == now.day;
        case TransactionFilter.thisWeek:
          dateMatch = now.difference(t.date).inDays < 7;
        case TransactionFilter.thisMonth:
          dateMatch = t.date.year == now.year && t.date.month == now.month;
      }
      if (!dateMatch) return false;

      // ── Search filter ────────────────────────────────────────────────────
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return t.customerName.toLowerCase().contains(q) ||
          t.id.toLowerCase().contains(q) ||
          t.rail.toLowerCase().contains(q);
    }).toList();
  }

  /// Count per filter — used on filter pill labels.
  int get todayCount {
    final now = DateTime.now();
    return _allTransactions
        .where((t) =>
            t.date.year == now.year &&
            t.date.month == now.month &&
            t.date.day == now.day)
        .length;
  }

  int get thisWeekCount {
    final now = DateTime.now();
    return _allTransactions
        .where((t) => now.difference(t.date).inDays < 7)
        .length;
  }

  int get thisMonthCount {
    final now = DateTime.now();
    return _allTransactions
        .where((t) =>
            t.date.year == now.year && t.date.month == now.month)
        .length;
  }

  void setFilter(TransactionFilter filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectTransaction(TransactionItem item) {
    _selectedTransaction = item;
    notifyListeners();
  }

  // ── Consent records ──────────────────────────────────────────────────────────

  /// In-memory consent log. In production this would be flushed to secure
  /// server-side storage. Face images are **never** saved here.
  final List<ConsentRecord> _consentRecords = [];

  List<ConsentRecord> get consentRecords => List.unmodifiable(_consentRecords);

  /// Write a consent record for an approval or rejection.
  ///
  /// Must be called by the screen/notifier that owns the approval flow, never
  /// from image-processing code (we do not pass face data here).
  void saveConsentRecord(ConsentRecord record) {
    _consentRecords.add(record);
    // No notifyListeners needed — consent log is not shown in the UI yet.
  }
}
