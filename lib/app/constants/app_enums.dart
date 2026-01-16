enum UserRole { seller, customer }

extension UserRoleX on UserRole {
  String get apiValue {
    switch (this) {
      case UserRole.seller:
        return 'SELLER';
      case UserRole.customer:
        return 'CUSTOMER';
    }
  }

  String get display {
    switch (this) {
      case UserRole.seller:
        return 'Seller';
      case UserRole.customer:
        return 'Customer';
    }
  }
}
