import 'package:get/get.dart';

import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/product_view.dart';
import '../modules/subscription/subscription_create/bindings/subscription_create_binding.dart';
import '../modules/subscription/subscription_create/views/subscription_create_view.dart';
import '../modules/subscription/subscriptions/bindings/subscriptions_binding.dart';
import '../modules/subscription/subscriptions/views/subscriptions_view.dart';
import '../modules/warehouse/bindings/warehouse_binding.dart';
import '../modules/warehouse/views/warehouse_view.dart';

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
      name: _Paths.WAREHOUSE,
      page: () => const WarehouseView(),
      binding: WarehouseBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIPTION_CREATE,
      page: () => const SubscriptionCreateView(),
      binding: SubscriptionCreateBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIPTIONS,
      page: () => const SubscriptionsView(),
      binding: SubscriptionsBinding(),
    ),
  ];
}
