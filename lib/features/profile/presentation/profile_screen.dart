import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../app_providers.dart';
import '../../routes/domain/route_models.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverAsync = ref.watch(driverProfileProvider);

    return driverAsync.when(
      data: (driver) => _ProfileContent(
        driver: driver,
        onLogout: () async {
          await ref.read(authStateProvider.notifier).signOut();
        },
      ),
      loading: () => const LoadingView(message: 'Memuat profil driver...'),
      error: (error, stackTrace) => ErrorView(message: error.toString()),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.driver, required this.onLogout});

  final DriverProfile driver;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: CircleAvatar(
                radius: 42,
                backgroundColor: AppTheme.navy,
                child: const Icon(Icons.person, size: 42, color: Colors.white),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                driver.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                driver.id,
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(label: 'Driver ID', value: driver.id),
                    _InfoRow(label: 'Kendaraan', value: driver.vehicleName),
                    _InfoRow(label: 'Nomor Telepon', value: driver.phone),
                    _InfoRow(label: 'Status', value: driver.status),
                    _InfoRow(
                      label: 'Sinkronisasi Terakhir',
                      value: DateFormat('dd MMM yyyy, HH:mm')
                          .format(driver.lastSyncAt),
                    ),
                    _InfoRow(label: 'Versi Aplikasi', value: '1.0.0'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () async {
                await onLogout();
                if (context.mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (route) => false);
                }
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Logout'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primaryRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          Expanded(flex: 3, child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
