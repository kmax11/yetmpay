import 'package:flutter/foundation.dart';

class TransactionItem {
  const TransactionItem({
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

class TransactionNotifier extends ChangeNotifier {
  static String formatAmount(double val) => TransactionItem.formatAmount(val);

  TransactionFilter _selectedFilter = TransactionFilter.today;
  String _searchQuery = '';
  TransactionItem? _selectedTransaction;

  final List<TransactionItem> _allTransactions = [
    const TransactionItem(
      id: 'TX-984321-ET',
      customerName: 'Abebe K.',
      customerInitials: 'AK',
      amount: 350.00,
      rail: 'Telebirr',
      time: '2:45 PM',
      timestamp: 'Today, 2:45:12 PM',
      maskedAccount: '+251 91 •••• 284',
      channel: 'Telebirr QR Push',
      isPaid: true,
    ),
    const TransactionItem(
      id: 'TX-984320-ET',
      customerName: 'Selam D.',
      customerInitials: 'SD',
      amount: 1200.00,
      rail: 'CBE Birr',
      time: '1:15 PM',
      timestamp: 'Today, 1:15:20 PM',
      maskedAccount: '+251 92 •••• 192',
      channel: 'CBE Birr Instant',
      isPaid: true,
    ),
    const TransactionItem(
      id: 'TX-984319-ET',
      customerName: 'Hana T.',
      customerInitials: 'HT',
      amount: 450.00,
      rail: 'Awash Bank',
      time: '11:30 AM',
      timestamp: 'Today, 11:30:44 AM',
      maskedAccount: '+251 94 •••• 881',
      channel: 'Awash Instant Rail',
      isPaid: false,
      failureReason: 'ERR_BIO_MISMATCH (Confidence 42% < 85%)',
    ),
    const TransactionItem(
      id: 'TX-984318-ET',
      customerName: 'Dawit A.',
      customerInitials: 'DA',
      amount: 80.00,
      rail: 'Dashen Amole',
      time: '10:05 AM',
      timestamp: 'Today, 10:05:08 AM',
      maskedAccount: '+251 93 •••• 502',
      channel: 'Dashen Amole Instant',
      isPaid: true,
    ),
  ];

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
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    final timeStr = '$hour:$minute $ampm';
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
    );

    _allTransactions.insert(0, newTx);
    _selectedTransaction = newTx;
    notifyListeners();
  }

  TransactionFilter get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;
  TransactionItem? get selectedTransaction => _selectedTransaction;
  List<TransactionItem> get allTransactions => List.unmodifiable(_allTransactions);

  double get todaySettledVolume => _allTransactions
      .where((t) => t.isPaid)
      .fold(0.0, (sum, t) => sum + t.amount);

  List<TransactionItem> get filteredTransactions {
    return _allTransactions.where((t) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return t.customerName.toLowerCase().contains(q) ||
          t.id.toLowerCase().contains(q) ||
          t.rail.toLowerCase().contains(q);
    }).toList();
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
}

