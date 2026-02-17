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
  final String fromBorrowerId;
  final String toLenderId;
  final double amount;
  final TransferStatus status;

  Transfer({
    required this.id,
    required this.fromBorrowerId,
    required this.toLenderId,
    required this.amount,
    required this.status,
  });

  factory Transfer.fromJson(Map<String, dynamic> j) => Transfer(
    id: j['id'] ?? '',
    fromBorrowerId: j['from_borrower_id'] ?? '',
    toLenderId: j['to_lender_id'] ?? '',
    amount:
        (j['amount'] is num)
            ? (j['amount'] as num).toDouble()
            : double.tryParse('${j['amount']}') ?? 0.0,
    status: _transferStatusOf(j['status']),
  );
}
