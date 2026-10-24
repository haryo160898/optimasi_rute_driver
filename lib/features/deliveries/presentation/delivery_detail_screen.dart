import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../routes/domain/route_models.dart';

class DeliveryDetailScreen extends ConsumerWidget {
  const DeliveryDetailScreen({super.key, required this.delivery});

  final DeliveryStop delivery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = delivery.status == DeliveryStatus.completed
        ? const Color(0xFF1DBA73)
        : delivery.status == DeliveryStatus.failed
        ? const Color(0xFFE11D48)
        : delivery.status == DeliveryStatus.inProgress
        ? const Color(0xFFF59E0B)
        : const Color(0xFF112B46);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pengiriman')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      delivery.customerName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    StatusBadge(
                      label: delivery.status.label,
                      color: statusColor,
                    ),
                    const SizedBox(height: 18),
                    _InfoRow(label: 'Delivery ID', value: delivery.id),
                    _InfoRow(label: 'Urutan', value: '${delivery.sequence}'),
                    _InfoRow(label: 'Alamat', value: delivery.address),
                    _InfoRow(
                      label: 'Estimasi Kedatangan',
                      value: DateFormat('dd MMM yyyy, HH:mm')
                          .format(delivery.estimatedArrival),
                    ),
                    _InfoRow(
                      label: 'Time Window',
                      value:
                          delivery.timeWindowStart != null &&
                              delivery.timeWindowEnd != null
                          ? '${delivery.timeWindowStart} - ${delivery.timeWindowEnd}'
                          : 'Belum tersedia',
                    ),
                    _InfoRow(label: 'Instruksi', value: delivery.instructions),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            AppButton(label: 'Navigasi ke Lokasi', onPressed: () {}),
            const SizedBox(height: 10),
            AppButton(
              label: 'Tandai Terkirim',
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: const Text('Konfirmasi'),
                      content: const Text(
                        'Apakah Anda yakin ingin menandai pengiriman ini sebagai selesai?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: const Text('Batal'),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Status berhasil diperbarui.'),
                              ),
                            );
                          },
                          child: const Text('Konfirmasi'),
                        ),
                      ],
                    );
                  },
                );
              },
              isSecondary: false,
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Laporkan Kendala',
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Laporkan Kendala'),
                    content: const TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Tuliskan alasan kendala pengiriman...',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Batal'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Kirim'),
                      ),
                    ],
                  ),
                );
              },
              isSecondary: true,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF54677A))),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}
