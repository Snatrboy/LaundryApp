import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExperimentsMenuView extends StatelessWidget {
  const ExperimentsMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTTP Library Experiments'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Icon(
                  Icons.science,
                  size: 80,
                  color: Colors.purple,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Analisis HTTP Library',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Pilih eksperimen yang ingin dijalankan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),
                _buildExperimentCard(
                  title: '1. HTTP Library Performance',
                  subtitle: 'Test performa HTTP package',
                  icon: Icons.http,
                  color: Colors.orange,
                  onTap: () => Get.toNamed('/laundry-http'),
                ),
                const SizedBox(height: 16),
                _buildExperimentCard(
                  title: '2. Dio Library Performance',
                  subtitle: 'Test performa Dio package',
                  icon: Icons.flash_on,
                  color: Colors.blue,
                  onTap: () => Get.toNamed('/laundry-dio'),
                ),
                const SizedBox(height: 16),
                _buildExperimentCard(
                  title: '3. Async Handling',
                  subtitle: 'Compare async-await vs callback',
                  icon: Icons.code,
                  color: Colors.purple,
                  onTap: () => Get.toNamed('/async-demo'),
                ),
                const SizedBox(height: 16),
                _buildExperimentCard(
                  title: '4. Error Handling Demo',
                  subtitle: 'Test error handling mechanisms',
                  icon: Icons.error_outline,
                  color: Colors.red,
                  onTap: () {
                    Get.snackbar(
                      'Info',
                      'Error handling sudah integrated di HTTP & Dio test',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExperimentCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}