import 'package:get/get.dart';
import '../controllers/http_laundry_controller.dart';

class HttpLaundryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HttpLaundryController>(() => HttpLaundryController());
  }
}