import 'package:plug/app/constants/app_enums.dart';

TransferStatus _transferStatusOf(dynamic s) {
  final v = (s ?? '').toString().toUpperCase();
  return TransferStatus.values.firstWhere(
    (e) => e.name == v,
    orElse: () => TransferStatus.PENDING,
  );
}

class Transfer {
  final String id;
  final String fromCustomerId;
  final String toSellerId;
  final double amount;
  final TransferStatus status;

  Transfer({
    required this.id,
    required this.fromCustomerId,
    required this.toSellerId,
    required this.amount,
    required this.status,
  });

  factory Transfer.fromJson(Map<String, dynamic> j) => Transfer(
    id: j['id'] ?? '',
    fromCustomerId: j['from_customer_id'] ?? '',
    toSellerId: j['to_seller_id'] ?? '',
    amount:
        (j['amount'] is num)
            ? (j['amount'] as num).toDouble()
            : double.tryParse('${j['amount']}') ?? 0.0,
    status: _transferStatusOf(j['status']),
  );
}
