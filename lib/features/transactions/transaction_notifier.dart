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

  String get formattedAmount =>
      '${isPaid ? '+' : ''}${amount.toStringAsFixed(2)} ETB';
}

enum TransactionFilter { today, thisWeek, thisMonth }

class TransactionNotifier extends ChangeNotifier {
  TransactionFilter _selectedFilter = TransactionFilter.today;
  String _searchQuery = '';
  TransactionItem? _selectedTransaction;

  final List<TransactionItem> _allTransactions = const [
    TransactionItem(
      id: 'TXN-894120938-ET',
      customerName: 'Abebe Kebede',
      customerInitials: 'AK',
      amount: 350.00,
      rail: 'Telebirr SuperApp',
      time: '2:45 PM',
      timestamp: 'Today, 14:45:12 EAT',
      maskedAccount: '+251 91 ••• 8821',
      channel: 'Telebirr Biometric Face',
      isPaid: true,
    ),
    TransactionItem(
      id: 'TXN-894120937-ET',
      customerName: 'Tigist Mengistu',
      customerInitials: 'TM',
      amount: 820.00,
      rail: 'CBE Birr',
      time: '1:12 PM',
      timestamp: 'Today, 13:12:05 EAT',
      maskedAccount: '1000 •••• 4492',
      channel: 'CBE Core Direct RTGS',
      isPaid: true,
    ),
    TransactionItem(
      id: 'TXN-894120936-ET',
      customerName: 'Hailemariam Assefa',
      customerInitials: 'HA',
      amount: 460.00,
      rail: 'Awash Bank',
      time: '11:30 AM',
      timestamp: 'Today, 11:30:44 EAT',
      maskedAccount: '0132 •••• 9910',
      channel: 'Awash Instant Rail',
      isPaid: true,
    ),
    TransactionItem(
      id: 'TXN-894120935-ET',
      customerName: 'Biruk Tadesse',
      customerInitials: 'BT',
      amount: 350.00,
      rail: 'Telebirr Face',
      time: '10:04 AM',
      timestamp: 'Today, 10:04:19 EAT',
      maskedAccount: '+251 92 ••• 3310',
      channel: 'Telebirr Biometric Scan',
      isPaid: false,
      failureReason: 'ERR_BIO_MISMATCH (Confidence 42% < 85%)',
    ),
  ];

  TransactionNotifier() {
    _selectedTransaction = _allTransactions.first;
  }

  TransactionFilter get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;
  TransactionItem? get selectedTransaction => _selectedTransaction;

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
