import 'package:dio/dio.dart';
import '../utils/app_logger.dart';
import 'http_client.dart';

class LaundryApiService {
  final HttpClient _httpClient = HttpClient();

  // Contoh: Get semua layanan laundry
  Future<List<dynamic>?> getAllServices() async {
    try {
      AppLogger.info(' Fetching all laundry services');

      final response = await _httpClient.get('/posts'); // Contoh endpoint

      if (response != null && response.statusCode == 200) {
        AppLogger.info(
          ' Successfully fetched ${response.data.length} services',
        );
        return response.data;
      } else {
        AppLogger.warning(
          ' Failed to fetch services: Status ${response?.statusCode}',
        );
        return null;
      }
    } catch (e, stackTrace) {
      AppLogger.error(' Error fetching services', e, stackTrace);
      return null;
    }
  }

  // Contoh: Get service by ID
  Future<Map<String, dynamic>?> getServiceById(int id) async {
    try {
      AppLogger.info(' Fetching service with ID: $id');

      final response = await _httpClient.get('/posts/$id');

      if (response != null && response.statusCode == 200) {
        AppLogger.info(
          ' Successfully fetched service: ${response.data['title']}',
        );
        return response.data;
      } else {
        AppLogger.warning(' Service not found: ID $id');
        return null;
      }
    } catch (e, stackTrace) {
      AppLogger.error(' Error fetching service by ID', e, stackTrace);
      return null;
    }
  }

  // Contoh: Create order
  Future<bool> createOrder(Map<String, dynamic> orderData) async {
    try {
      AppLogger.info(' Creating new order', orderData);

      final response = await _httpClient.post('/posts', data: orderData);

      if (response != null && response.statusCode == 201) {
        AppLogger.info(' Order created successfully: ${response.data['id']}');
        return true;
      } else {
        AppLogger.warning(' Failed to create order');
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.error(' Error creating order', e, stackTrace);
      return false;
    }
  }

  // Contoh: Update order
  Future<bool> updateOrder(int id, Map<String, dynamic> orderData) async {
    try {
      AppLogger.info(' Updating order ID: $id', orderData);

      final response = await _httpClient.put('/posts/$id', data: orderData);

      if (response != null && response.statusCode == 200) {
        AppLogger.info(' Order updated successfully');
        return true;
      } else {
        AppLogger.warning(' Failed to update order');
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.error(' Error updating order', e, stackTrace);
      return false;
    }
  }

  // Contoh: Delete order
  Future<bool> deleteOrder(int id) async {
    try {
      AppLogger.info(' Deleting order ID: $id');

      final response = await _httpClient.delete('/posts/$id');

      if (response != null && response.statusCode == 200) {
        AppLogger.info(' Order deleted successfully');
        return true;
      } else {
        AppLogger.warning(' Failed to delete order');
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.error(' Error deleting order', e, stackTrace);
      return false;
    }
  }

  // Simulasi error untuk testing
  Future<void> testErrorHandling() async {
    try {
      AppLogger.info('Testing error handling');

      // Test timeout
      await _httpClient.get('/posts/999999');

      // Test invalid endpoint
      await _httpClient.get('/invalid-endpoint');
    } catch (e, stackTrace) {
      AppLogger.error(' Test error occurred', e, stackTrace);
    }
  }
}
