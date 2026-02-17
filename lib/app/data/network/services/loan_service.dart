import 'package:dio/dio.dart';
import 'package:plug/app/data/models/loan.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/utils/logger.dart';
import 'package:plug/app/utils/try_catcher.dart';

class LoanService {
  final ApiClient api;
  LoanService(this.api);

  Future<Loan> createLoan(String productId) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.post('/loan', data: {'productId': productId});
    }, tag: 'LoanService.createLoan');
    if (res == null) throw Exception('Gagal membuat loan');
    final data = res.data['data'] as Map<String, dynamic>;
    return Loan.fromJson(data);
  }

  Future<Loan> confirmLoan(String id, String decision) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.patch(
        '/loan/$id/confirm',
        data: {'decision': decision},
      );
    }, tag: 'LoanService.confirmLoan');
    if (res == null) throw Exception('Gagal konfirmasi loan');
    final data = res.data['data'] as Map<String, dynamic>;
    return Loan.fromJson(data);
  }

  Future<List<Loan>> lenderLoans({String? status}) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.get(
        '/loan/lender',
        queryParameters: status != null ? {'status': status} : null,
      );
    }, tag: 'LoanService.lenderLoans');
    if (res == null) throw Exception('Gagal memuat pinjaman lender');
    final list = (res.data['data'] as List).cast<Map<String, dynamic>>();
    return list.map(Loan.fromJson).toList();
  }

  Future<List<Loan>> borrowerLoans({String? status}) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.get(
        '/loan',
        queryParameters: status != null ? {'status': status} : null,
      );
    }, tag: 'LoanService.borrowerLoans');
    if (res == null) throw Exception('Gagal memuat pinjaman borrower');
    final list = (res.data['data'] as List).cast<Map<String, dynamic>>();
    return list.map(Loan.fromJson).toList();
  }
}
