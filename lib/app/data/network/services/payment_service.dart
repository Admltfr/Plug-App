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

    if (data.containsKey('balance') && !data.containsKey('id')) {
      return Wallet(id: '', balance: (data['balance'] as num).toDouble());
    }

    return Wallet.fromJson(data);
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

  Future<Transfer> pay(String lenderId, num amount) async {
    final Response? res = await tryOrNullAsync<Response>(() async {
      return await api.private.post(
        '/payment/pay',
        data: {'lenderId': lenderId, 'amount': amount},
      );
    }, tag: 'PayBalance');

    if (res == null) throw Exception('Gagal membayar.');

    final data = res.data['data'] as Map<String, dynamic>;

    logSuccess('Pembayaran berhasil: ${data['transferId']}', tag: 'PayBalance');

    return Transfer(
      id: data['transferId'] ?? '',
      fromCustomerId: '',
      toSellerId: lenderId,
      amount: (data['amount'] as num).toDouble(),
      status: TransferStatus.COMPLETED,
    );
  }
}
