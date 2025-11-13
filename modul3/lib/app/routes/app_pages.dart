import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/laundry_http/bindings/http_laundry_binding.dart';
import '../modules/laundry_http/views/http_laundry_view.dart';
import '../modules/laundry.dio/bindings/dio_laundry_binding.dart';
import '../modules/laundry.dio/views/dio_laundry_view.dart';
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
      name: Routes.LAUNDRY_HTTP,
      page: () => const HttpLaundryView(),
      binding: HttpLaundryBinding(),
    ),
    GetPage(
      name: Routes.LAUNDRY_DIO,
      page: () => const DioLaundryView(),
      binding: DioLaundryBinding(),
    ),
  ];
}