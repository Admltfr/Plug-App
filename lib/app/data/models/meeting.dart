import 'package:plug/app/constants/app_enums.dart';

MeetingStatus meetingStatusOf(dynamic s) {
  final v = (s ?? '').toString().toUpperCase();
  return MeetingStatus.values.firstWhere(
    (e) => e.name == v,
    orElse: () => MeetingStatus.PENDING,
  );
}

class Meeting {
  final String loanId;
  final double lat;
  final double lon;
  final String address;
  final MeetingStatus status;
  final String? qrToken;
  final DateTime? qrExpires;

  Meeting({
    required this.loanId,
    required this.lat,
    required this.lon,
    required this.address,
    required this.status,
    this.qrToken,
    this.qrExpires,
  });

  factory Meeting.fromJson(Map<String, dynamic> j) => Meeting(
    loanId: j['loan_id'] ?? '',
    lat:
        (j['lat'] is num)
            ? (j['lat'] as num).toDouble()
            : double.tryParse('${j['lat']}') ?? 0.0,
    lon:
        (j['lon'] is num)
            ? (j['lon'] as num).toDouble()
            : double.tryParse('${j['lon']}') ?? 0.0,
    address: j['address'] ?? '',
    status: meetingStatusOf(j['status']),
    qrToken: j['qr_token'],
    qrExpires:
        (j['qr_expires'] is String)
            ? DateTime.tryParse(j['qr_expires'])
            : (j['qr_expires'] as DateTime?),
  );

  Map<String, dynamic> toJson() => {
    'loan_id': loanId,
    'lat': lat,
    'lon': lon,
    'address': address,
    'status': status.name,
    'qr_token': qrToken,
    'qr_expires': qrExpires?.toIso8601String(),
  };
}
