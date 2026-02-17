class Wallet {
  final String id;
  final double balance;
  final String? borrowerId;
  final String? lenderId;

  Wallet({
    required this.id,
    required this.balance,
    this.borrowerId,
    this.lenderId,
  });

  factory Wallet.fromJson(Map<String, dynamic> j) => Wallet(
    id: j['id'] ?? '',
    balance:
        (j['balance'] is num)
            ? (j['balance'] as num).toDouble()
            : double.tryParse('${j['balance']}') ?? 0.0,
    borrowerId: j['borrower_id'],
    lenderId: j['lender_id'],
  );
}
