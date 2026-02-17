import 'package:plug/app/constants/app_enums.dart';
import 'package:plug/app/data/models/product.dart';
import 'package:plug/app/data/models/borrower.dart';

LoanStatus loanStatusOf(dynamic s) {
  final v = (s ?? '').toString().toUpperCase();
  return LoanStatus.values.firstWhere(
    (e) => e.name == v,
    orElse: () => LoanStatus.PENDING,
  );
}

class Loan {
  final String id;
  final String productId;
  final String borrowerId;
  final String lenderId;
  final double amount;
  final LoanStatus status;
  final Product? product;
  final Borrower? borrower;

  Loan({
    required this.id,
    required this.productId,
    required this.borrowerId,
    required this.lenderId,
    required this.amount,
    required this.status,
    this.product,
    this.borrower,
  });

  factory Loan.fromJson(Map<String, dynamic> j) => Loan(
    id: j['id'],
    productId: j['product_id'],
    borrowerId: j['borrower_id'],
    lenderId: j['lender_id'],
    amount:
        (j['amount'] is num)
            ? (j['amount'] as num).toDouble()
            : double.tryParse('${j['amount']}') ?? 0.0,
    status: loanStatusOf(j['status']),
    product: j['product'] != null ? Product.fromJson(j['product']) : null,
    borrower: j['borrower'] != null ? Borrower.fromJson(j['borrower']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_id': productId,
    'borrower_id': borrowerId,
    'lender_id': lenderId,
    'amount': amount,
    'status': status.name,
    if (product != null)
      'product': {
        'id': product!.id,
        'name': product!.name,
        'description': product!.description,
        'price': product!.price,
        'stock': product!.stock,
        'image_url': product!.imageUrl,
        'lender': {
          'id': product!.lender.id,
          'name': product!.lender.name,
          'email': product!.lender.email,
        },
      },
    if (borrower != null)
      'borrower': {
        'id': borrower!.id,
        'name': borrower!.name,
        'email': borrower!.email,
      },
  };
}
