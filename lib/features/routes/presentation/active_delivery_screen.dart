import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/route_models.dart';

class ActiveDeliveryScreen extends StatelessWidget {
  const ActiveDeliveryScreen({super.key, required this.route});

  final OptimizedRoute route;

  @override
  Widget build(BuildContext context) {
    final currentStop = route.stops.isNotEmpty
        ? route.stops.firstWhere(
            (stop) => stop.status == DeliveryStatus.inProgress,
            orElse: () => route.stops.first,
          )
        : null;

    if (currentStop == null) {
      return const Scaffold(
        body: Center(child: Text('Belum ada tujuan aktif.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Aktif')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tujuan Saat Ini',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentStop.customerName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(currentStop.address),
                      const SizedBox(height: 14),
                      _InfoRow(
                        label: 'Jarak ke tujuan',
                        value: currentStop.distanceFromPreviousKm != null
                            ? '${currentStop.distanceFromPreviousKm!.toStringAsFixed(1)} km'
                            : 'Belum tersedia',
                      ),
                      _InfoRow(
                        label: 'Estimasi kedatangan',
                        value:
                            '${currentStop.estimatedArrival.hour.toString().padLeft(2, '0')}:${currentStop.estimatedArrival.minute.toString().padLeft(2, '0')}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Perhatian: berhenti di tempat aman sebelum mengoperasikan aplikasi.',
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Status kedatangan berhasil dicatat.'),
                  ),
                ),
                child: const Text('Saya Tiba'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          context.push('/route-sequence', extra: route),
                      child: const Text('Lihat Semua Tujuan'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push(
                        '/delivery/${currentStop.id}',
                        extra: currentStop,
                      ),
                      child: const Text('Laporkan Kendala'),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
      padding: const EdgeInsets.only(bottom: 8),
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
