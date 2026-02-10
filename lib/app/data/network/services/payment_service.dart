import 'package:dio/dio.dart';
import 'package:plug/app/data/models/transfer.dart';
import 'package:plug/app/data/models/wallet.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/utils/logger.dart';
import 'package:plug/app/utils/try_catcher.dart';
import 'package:plug/app/constants/app_enums.dart';

class PaymentService {
  final ApiClient api;
  PaymentService(this.api);

  Future<Wallet> balance() async {
    final Response? res = await tryOrNullAsync<Response>(() async {
      return await api.private.get('/payment/balance');
    }, tag: 'WalletBalance');

    if (res == null) throw Exception('Gagal memuat saldo.');

    final data = res.data['data'] as Map<String, dynamic>;

    logSuccess('Saldo dimuat', tag: 'WalletBalance');

    return Wallet.fromJson({'id': '', 'balance': data['balance']});
  }

  Future<Map<String, dynamic>> topup(num amount) async {
    final Response? res = await tryOrNullAsync<Response>(() async {
      return await api.private.post('/payment/topup', data: {'amount': amount});
    }, tag: 'TopupCreate');

    if (res == null) throw Exception('Gagal membuat topup.');

    final data = res.data['data'] as Map<String, dynamic>;

    logSuccess('Topup dibuat: ${data['orderId']}', tag: 'TopupCreate');

    return data;
  }

  Future<Transfer> pay(String loanId) async {
    final Response? res = await tryOrNullAsync<Response>(() async {
      return await api.private.post('/payment/pay', data: {'loanId': loanId});
    }, tag: 'PayBalance');

    if (res == null) throw Exception('Gagal membayar.');
    final data = res.data['data'] as Map<String, dynamic>;

    final amtRaw = data['amount'];
    final amt =
        amtRaw is num
            ? amtRaw.toDouble()
            : (amtRaw is String ? double.tryParse(amtRaw) ?? 0.0 : 0.0);

    logSuccess('Pembayaran berhasil: ${data['transferId']}', tag: 'PayBalance');

    return Transfer(
      id: data['transferId'] ?? '',
      fromCustomerId: '',
      toSellerId: '',
      amount: amt,
      status: TransferStatus.COMPLETED,
    );
  }
}
