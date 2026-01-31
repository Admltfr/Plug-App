class Wallet {
  final String id;
  final double balance;
  final String? customerId;
  final String? sellerId;

  Wallet({
    required this.id,
    required this.balance,
    this.customerId,
    this.sellerId,
  });

  factory Wallet.fromJson(Map<String, dynamic> j) => Wallet(
    id: j['id'] ?? '',
    balance:
        (j['balance'] is num)
            ? (j['balance'] as num).toDouble()
            : double.tryParse('${j['balance']}') ?? 0.0,
    customerId: j['customer_id'],
    sellerId: j['seller_id'],
  );
}
