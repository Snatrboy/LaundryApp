import 'package:flutter/material.dart';
import '../../../data/services/dio_service.dart';
import '../../../data/models/laundry_service_model.dart';

class AsyncDemoView extends StatefulWidget {
  const AsyncDemoView({Key? key}) : super(key: key);

  @override
  State<AsyncDemoView> createState() => _AsyncDemoViewState();
}

class _AsyncDemoViewState extends State<AsyncDemoView> {
  final DioService _dioService = DioService();
  
  bool isLoadingAsyncAwait = false;
  bool isLoadingCallback = false;
  
  String asyncAwaitResult = '';
  String callbackResult = '';
  
  int asyncAwaitTime = 0;
  int callbackTime = 0;

  // Async-await approach (Clean & Readable)
  Future<void> runAsyncAwait() async {
    setState(() {
      isLoadingAsyncAwait = true;
      asyncAwaitResult = '';
    });

    final stopwatch = Stopwatch()..start();
    
    try {
      // Step 1: Fetch all services
      final result1 = await _dioService.fetchServices();
      
      if (!result1['success']) {
        asyncAwaitResult = 'Error: ${result1['error']}';
        return;
      }
      
      final services = result1['data'] as List<LaundryService>;
      
      // Step 2: Get first service
      if (services.isEmpty) {
        asyncAwaitResult = 'No services found';
        return;
      }
      
      final firstService = services.first;
      
      // Step 3: Fetch detail of first service
      final result2 = await _dioService.fetchServiceById(firstService.id);
      
      stopwatch.stop();
      asyncAwaitTime = stopwatch.elapsedMilliseconds;
      
      if (result2['success']) {
        final service = result2['data'] as LaundryService;
        asyncAwaitResult = '''
✅ Success!

Step 1: Fetched ${services.length} services
Step 2: Selected "${firstService.name}"
Step 3: Got detail: ${service.price}

Time: ${asyncAwaitTime}ms
        ''';
      }
      
    } catch (e) {
      asyncAwaitResult = 'Error: $e';
    } finally {
      setState(() => isLoadingAsyncAwait = false);
    }
  }

  // Callback approach (Nested & Hard to read)
  void runCallback() {
    setState(() {
      isLoadingCallback = true;
      callbackResult = '';
    });

    final stopwatch = Stopwatch()..start();
    
    // Callback hell begins...
    _dioService.fetchServices().then((result1) {
      if (!result1['success']) {
        setState(() {
          callbackResult = 'Error: ${result1['error']}';
          isLoadingCallback = false;
        });
        return;
      }
      
      final services = result1['data'] as List<LaundryService>;
      
      if (services.isEmpty) {
        setState(() {
          callbackResult = 'No services found';
          isLoadingCallback = false;
        });
        return;
      }
      
      final firstService = services.first;
      
      // Nested callback
      _dioService.fetchServiceById(firstService.id).then((result2) {
        stopwatch.stop();
        callbackTime = stopwatch.elapsedMilliseconds;
        
        if (result2['success']) {
          final service = result2['data'] as LaundryService;
          setState(() {
            callbackResult = '''
✅ Success!

Step 1: Fetched ${services.length} services
Step 2: Selected "${firstService.name}"
Step 3: Got detail: ${service.price}

Time: ${callbackTime}ms
            ''';
            isLoadingCallback = false;
          });
        }
      }).catchError((error) {
        setState(() {
          callbackResult = 'Error in step 3: $error';
          isLoadingCallback = false;
        });
      });
    }).catchError((error) {
      setState(() {
        callbackResult = 'Error in step 1: $error';
        isLoadingCallback = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Async Handling Demo'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Chained Request Example:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Fetch all services\n'
              '2. Select first service\n'
              '3. Fetch detail of that service',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // Async-await section
            _buildMethodCard(
              title: '1. Async-Await (Recommended)',
              description: 'Clean, readable, easy to maintain',
              color: Colors.green,
              isLoading: isLoadingAsyncAwait,
              result: asyncAwaitResult,
              onRun: runAsyncAwait,
            ),
            
            const SizedBox(height: 16),
            
            // Callback section
            _buildMethodCard(
              title: '2. Callback Chaining',
              description: 'Nested, callback hell, hard to debug',
              color: Colors.red,
              isLoading: isLoadingCallback,
              result: callbackResult,
              onRun: runCallback,
            ),
            
            const SizedBox(height: 24),
            
            // Comparison
            if (asyncAwaitResult.isNotEmpty && callbackResult.isNotEmpty)
              _buildComparison(),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodCard({
    required String title,
    required String description,
    required Color color,
    required bool isLoading,
    required String result,
    required VoidCallback onRun,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  color: color,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isLoading ? null : onRun,
              icon: Icon(isLoading ? Icons.hourglass_empty : Icons.play_arrow),
              label: Text(isLoading ? 'Running...' : 'Run Test'),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            if (result.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  result,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildComparison() {
    final diff = asyncAwaitTime - callbackTime;
    final faster = diff > 0 ? 'Callback' : 'Async-await';
    
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '📊 Comparison Result',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildComparisonStat(
                    'Async-Await',
                    '${asyncAwaitTime}ms',
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildComparisonStat(
                    'Callback',
                    '${callbackTime}ms',
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$faster was ${diff.abs()}ms faster',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '✅ Readability: Async-await wins',
                    style: TextStyle(fontSize: 12),
                  ),
                  const Text(
                    '✅ Maintainability: Async-await wins',
                    style: TextStyle(fontSize: 12),
                  ),
                  const Text(
                    '✅ Debugging: Async-await wins',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}