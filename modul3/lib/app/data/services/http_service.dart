import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/laundry_service_model.dart';

class HttpService {
  static const String baseUrl =
      'https://6915596b84e8bd126af996e3.mockapi.io';

  // Fetch all services with manual error handling
  Future<Map<String, dynamic>> fetchServices() async {
    final stopwatch = Stopwatch()..start();

    try {
      print('🟢 [HTTP] Starting request...');
      print('🟢 [HTTP] URL: $baseUrl/services');

      final response = await http.get(
        Uri.parse('$baseUrl/services'),
        headers: {'Content-Type': 'application/json'},
      );

      stopwatch.stop();
      final duration = stopwatch.elapsedMilliseconds;

      print('🟢 [HTTP] Status Code: ${response.statusCode}');
      print('🟢 [HTTP] Response Time: ${duration}ms');
      print('🟢 [HTTP] Response Size: ${response.body.length} bytes');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final services = jsonData
            .map((json) => LaundryService.fromJson(json))
            .toList();

        print('🟢 [HTTP] Success: ${services.length} services loaded');

        return {
          'success': true,
          'data': services,
          'duration': duration,
          'statusCode': response.statusCode,
          'error': null,
        };
      } else {
        print('🔴 [HTTP] Error: ${response.statusCode}');
        return {
          'success': false,
          'data': null,
          'duration': duration,
          'statusCode': response.statusCode,
          'error': 'HTTP Error ${response.statusCode}',
        };
      }
    } catch (e) {
      stopwatch.stop();
      print('🔴 [HTTP] Exception: $e');

      return {
        'success': false,
        'data': null,
        'duration': stopwatch.elapsedMilliseconds,
        'statusCode': 0,
        'error': e.toString(),
      };
    }
  }

  // Simulate error scenario
  Future<Map<String, dynamic>> fetchWithError() async {
    final stopwatch = Stopwatch()..start();

    try {
      print('🟢 [HTTP] Testing error handling...');

      final response = await http.get(Uri.parse('$baseUrl/invalid-endpoint'));

      stopwatch.stop();

      return {
        'success': false,
        'data': null,
        'duration': stopwatch.elapsedMilliseconds,
        'statusCode': response.statusCode,
        'error': 'Endpoint not found',
      };
    } catch (e) {
      stopwatch.stop();
      print('🔴 [HTTP] Caught error: $e');

      return {
        'success': false,
        'data': null,
        'duration': stopwatch.elapsedMilliseconds,
        'statusCode': 0,
        'error': 'Manual Try-Catch: $e',
      };
    }
  }
}
