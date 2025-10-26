import 'package:get/get.dart';
import '../../../data/models/laundry_service_model.dart';
import '../../../data/services/http_service.dart';

class HttpLaundryController extends GetxController {
  final HttpService _httpService = HttpService();

  final isLoading = false.obs;
  final services = <LaundryService>[].obs;
  final responseTime = 0.obs;
  final statusCode = 0.obs;
  final errorMessage = ''.obs;
  final testResults = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    print('🟢 HTTP Controller initialized');
  }

  Future<void> fetchServices() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final result = await _httpService.fetchServices();
      
      responseTime.value = result['duration'];
      statusCode.value = result['statusCode'];
      
      if (result['success']) {
        services.value = result['data'];
        errorMessage.value = '';
      } else {
        services.value = [];
        errorMessage.value = result['error'];
      }
      
      testResults.add({
        'timestamp': DateTime.now(),
        'duration': result['duration'],
        'success': result['success'],
        'error': result['error'],
      });
    } catch (e) {
      errorMessage.value = 'Unexpected error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> testErrorHandling() async {
    isLoading.value = true;
    
    try {
      final result = await _httpService.fetchWithError();
      
      responseTime.value = result['duration'];
      statusCode.value = result['statusCode'];
      errorMessage.value = result['error'];
      
      Get.snackbar(
        'Error Test',
        'Error handling: ${result['error']}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void runMultipleTests() async {
    testResults.clear();
    
    for (int i = 0; i < 5; i++) {
      print('🟢 Running test ${i + 1}/5');
      await fetchServices();
      await Future.delayed(const Duration(milliseconds: 500));
    }
    
    final avgTime = testResults.fold<int>(
      0, 
      (sum, result) => sum + (result['duration'] as int)
    ) / testResults.length;
    
    Get.snackbar(
      'Test Complete',
      'Average response time: ${avgTime.toStringAsFixed(0)}ms',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  double get averageResponseTime {
    if (testResults.isEmpty) return 0.0;
    
    final total = testResults.fold<int>(
      0,
      (sum, result) => sum + (result['duration'] as int),
    );
    
    return total / testResults.length;
  }

  int get successCount {
    return testResults.where((r) => r['success'] == true).length;
  }

  int get failureCount {
    return testResults.where((r) => r['success'] == false).length;
  }
}