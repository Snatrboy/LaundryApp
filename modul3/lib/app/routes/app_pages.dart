import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/experiments_menu/views/experiments_menu_view.dart';
import '../modules/laundry_http/bindings/http_laundry_binding.dart';
import '../modules/laundry_http/views/http_laundry_view.dart';
import '../modules/laundry.dio/bindings/dio_laundry_binding.dart';
import '../modules/laundry.dio/views/dio_laundry_view.dart';
import '../modules/async_demo/views/async_demo_view.dart';
import '../modules/login_demo/views/login_demo_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.EXPERIMENTS_MENU,
      page: () => const ExperimentsMenuView(),
    ),
    GetPage(
      name: Routes.LAUNDRY_HTTP,
      page: () => const HttpLaundryView(),
      binding: HttpLaundryBinding(),
    ),
    GetPage(
      name: Routes.LAUNDRY_DIO,
      page: () => const DioLaundryView(),
      binding: DioLaundryBinding(),
    ),
    GetPage(
      name: Routes.ASYNC_DEMO,
      page: () => const AsyncDemoView(),
    ),
    GetPage(
      name: Routes.LOGIN_DEMO,
      page: () => const LoginDemoView(),
    ),
  ];
}