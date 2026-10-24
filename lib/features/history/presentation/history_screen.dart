import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../app_providers.dart';
import '../../routes/domain/route_models.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return historyAsync.when(
      data: (history) => _HistoryContent(history: history),
      loading: () => const LoadingView(message: 'Memuat riwayat pengiriman...'),
      error: (error, stackTrace) => ErrorView(message: error.toString()),
    );
  }
}

class _HistoryContent extends StatelessWidget {
  const _HistoryContent({required this.history});

  final List<DeliveryHistoryEntry> history;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Riwayat Pengiriman',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 18),
            if (history.isEmpty)
              const Center(child: Text('Belum ada riwayat'))
            else
              ...history.map(
                (entry) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                entry.routeId,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1DBA73)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                entry.status,
                                style: const TextStyle(
                                  color: Color(0xFF1DBA73),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(DateFormat('dd MMM yyyy').format(entry.date)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text('Total: ${entry.totalDeliveries}'),
                            ),
                            Expanded(
                              child: Text('Selesai: ${entry.completed}'),
                            ),
                            Expanded(child: Text('Gagal: ${entry.failed}')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
