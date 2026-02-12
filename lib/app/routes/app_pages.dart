import 'package:get/get.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/loan/loan_confirm/bindings/loan_confirm_binding.dart';
import '../modules/loan/loan_confirm/views/loan_confirm_view.dart';
import '../modules/loan/loan_detail/bindings/loan_detail_binding.dart';
import '../modules/loan/loan_detail/views/loan_detail_view.dart';
import '../modules/loan/loan_list/bindings/loan_list_binding.dart';
import '../modules/loan/loan_list/views/loan_list_view.dart';
import '../modules/loan/loan_lender_list/views/loan_lender_list_view.dart';
import '../modules/loan/loan_lender_list/bindings/loan_lender_list_binding.dart';
import '../modules/location/bindings/location_binding.dart';
import '../modules/location/views/location_view.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/product_view.dart';
import '../modules/qr/views/qr_scan_view.dart';
import '../modules/qr/views/qr_view.dart';
import '../modules/wallet/topup/bindings/topup_binding.dart';
import '../modules/wallet/topup/views/topup_view.dart';
import '../modules/wallet/wallet_home/bindings/wallet_home_binding.dart';
import '../modules/wallet/wallet_home/views/wallet_home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT,
      page: () => const ProductView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.WALLET_HOME,
      page: () => const WalletHomeView(),
      binding: WalletHomeBinding(),
    ),
    GetPage(
      name: _Paths.TOPUP,
      page: () => const TopupView(),
      binding: TopupBinding(),
    ),
    GetPage(
      name: _Paths.LOAN_DETAIL,
      page: () => const LoanDetailView(),
      binding: LoanDetailBinding(),
    ),
    GetPage(
      name: _Paths.LOAN_CONFIRM,
      page: () => const LoanConfirmView(),
      binding: LoanConfirmBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.LOAN_LIST,
      page: () => const LoanListView(),
      binding: LoanListBinding(),
    ),
    GetPage(
      name: _Paths.LOCATION,
      page: () => const LocationView(),
      binding: LocationBinding(),
    ),
    GetPage(name: _Paths.QR, page: () => const QrView()),
    GetPage(name: _Paths.QR_SCAN, page: () => const QrScanView()),
    GetPage(
      name: _Paths.LOAN_LENDER_LIST,
      page: () => const LoanLenderListView(),
      binding: LoanLenderListBinding(),
    ),
  ];
}
