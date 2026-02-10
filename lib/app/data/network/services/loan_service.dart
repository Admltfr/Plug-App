import 'package:dio/dio.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/utils/logger.dart';
import 'package:plug/app/utils/try_catcher.dart';

class LoanService {
  final ApiClient api;
  LoanService(this.api);

  Future<Map<String, dynamic>> createLoan(String productId) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.post('/loan', data: {'productId': productId});
    }, tag: 'LoanCreate');
    if (res == null) throw Exception('Gagal membuat loan.');
    final data = Map<String, dynamic>.from(res.data['data']);
    logSuccess('Loan dibuat: ${data['id']}', tag: 'LoanCreate');
    return data;
  }

  Future<Map<String, dynamic>> confirmLoan(String id, String decision) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.patch(
        '/loan/$id/confirm',
        data: {
          'decision': decision, // "ACCEPT" | "REJECT"
        },
      );
    }, tag: 'LoanConfirm');
    if (res == null) throw Exception('Gagal konfirmasi loan.');
    final data = Map<String, dynamic>.from(res.data['data']);
    logSuccess('Loan dikonfirmasi: $decision', tag: 'LoanConfirm');
    return data;
  }

  Future<List<Map<String, dynamic>>> lenderLoans({String? status}) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.get(
        '/loan/lender',
        queryParameters: {if (status != null) 'status': status},
      );
    }, tag: 'LenderLoans');
    if (res == null) throw Exception('Gagal memuat peminjaman lender.');
    final list = List<Map<String, dynamic>>.from(res.data['data']);
    logSuccess('Lender loans: ${list.length}', tag: 'LenderLoans');
    return list;
  }

  Future<List<Map<String, dynamic>>> borrowerLoans({String? status}) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.get(
        '/loan',
        queryParameters: {if (status != null) 'status': status},
      );
    }, tag: 'BorrowerLoans');
    if (res == null) throw Exception('Gagal memuat peminjaman saya.');
    final list = List<Map<String, dynamic>>.from(res.data['data']);
    logSuccess('Borrower loans: ${list.length}', tag: 'BorrowerLoans');
    return list;
  }
}
