enum UserRole { lender, borrower }

enum AppRole { LENDER, BORROWER }

enum TransferStatus { PENDING, COMPLETED, FAILED }

enum LoanStatus {
  PENDING,
  ACCEPTED,
  REJECTED,
  PAID,
  MEETING,
  WAITING_FOR_RETURN,
  COMPLETED,
}

enum MeetingStatus { PENDING, ACCEPTED, REJECTED, COMPLETED }

extension UserRoleX on UserRole {
  String get apiValue => this == UserRole.lender ? 'LENDER' : 'BORROWER';
  String get display => this == UserRole.lender ? 'Lender' : 'Borrower';
}
