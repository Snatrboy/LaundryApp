import 'package:get/get.dart';
import '../controllers/dio_laundry_controller.dart';

class DioLaundryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DioLaundryController>(() => DioLaundryController());
  }
}