import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_duit/features/savings/presentation/viewmodel/savings_providers.dart';
import 'package:my_duit/features/savings/domain/models/savings_goal_model.dart';

class SavingsDetailPage extends ConsumerWidget {
  final String savingsId;

  const SavingsDetailPage({
    super.key,
    required this.savingsId,
  });

  IconData _getIconData(String name) {
    switch (name) {
      case 'flight':
        return Icons.flight_takeoff;
      case 'laptop':
        return Icons.laptop_chromebook;
      default:
        return Icons.star;
    }
  }

  void _showAddContributionDialog(BuildContext context, WidgetRef ref, SavingsGoalModel goal) {
    final controller = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          title: Text(
            'Tambah Tabungan',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              prefixText: 'Rp ',
              prefixStyle: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              hintText: 'Masukkan jumlah tabungan',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: TextStyle(color: theme.colorScheme.outline),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(controller.text) ?? 0.0;
                if (amount > 0) {
                  ref.read(savingsGoalsNotifierProvider.notifier).addContribution(goal.id, amount);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Berhasil menambah Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(amount)} ke tabungan'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final savingsGoals = ref.watch(savingsGoalsNotifierProvider);

    // Find savings by ID
    final goalIndex = savingsGoals.indexWhere((g) => g.id == savingsId);
    if (goalIndex == -1) {
      return const Scaffold(
        body: Center(child: Text('Target tabungan tidak ditemukan')),
      );
    }
    final goal = savingsGoals[goalIndex];

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final percent = goal.percentSaved;
    final remaining = goal.targetAmount - goal.savedAmount;
    final formattedPercent = '${(percent * 100).toInt()}%';

    // Mock contribution history
    final mockContributions = [
      {'title': 'Tabungan Bulan Ini', 'date': '12 Okt 2023', 'amount': 1000000.0, 'icon': Icons.savings_outlined},
      {'title': 'Bonus Tahunan', 'date': '28 Sep 2023', 'amount': 1500000.0, 'icon': Icons.account_balance_wallet_outlined},
      {'title': 'Tabungan Bulan Lalu', 'date': '12 Sep 2023', 'amount': 500000.0, 'icon': Icons.savings_outlined},
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Atur Tabungan',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  const SizedBox(height: 8.0),

                  // Header Image Card (Mount Fuji header style from HTML mockup)
                  Container(
                    height: 128.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Stack(
                        children: [
                          // Network image with premium travel/Japan aesthetics
                          Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuC3q8d_3KPv7IPiuSpa5DMoYszDBhzfwjkbGkCpKYLLU61rqY82p-5Z8QpxHqiBGpSP6gwUHoH2RxqaZFn0Bvgpf7VZ14_m719rrXe7BGdbwstUnHqOPlUu-R10pSNsFcYohOp1713zRCD5FQf0YjUyhMcf30jbUPnaftviM4cH5cXg8yGP4AHvbX98bDe8eLtYlRn2xr76SmB5NlD85ef0nenHKlVEcJPf-nx6qeZGQ0z_5ELbEWiN',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback beautiful gradient if offline or image fails to load
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.primary.withValues(alpha: 0.7),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              );
                            },
                          ),
                          // Dark gradient overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withValues(alpha: 0.6),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          // Banner Title & Icon
                          Positioned(
                            bottom: 16.0,
                            left: 16.0,
                            right: 16.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  goal.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _getIconData(goal.iconName),
                                    color: Colors.white,
                                    size: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // Progress Ring Section
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Base track circle
                          SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: CircularProgressIndicator(
                              value: 1.0,
                              strokeWidth: 14.0,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.surfaceContainerHighest,
                              ),
                            ),
                          ),
                          // Active progress circle
                          SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: CircularProgressIndicator(
                              value: percent,
                              strokeWidth: 14.0,
                              strokeCap: StrokeCap.round,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          // Percentage text in the middle
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formattedPercent,
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36.0,
                                ),
                              ),
                              Text(
                                'Terkumpul',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      // Rounded balance display badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(99.0),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x02000000),
                              blurRadius: 8.0,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              currencyFormatter.format(goal.savedAmount),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'dari target ${currencyFormatter.format(goal.targetAmount)}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28.0),

                  // Bento Grid Stats Card
                  Row(
                    children: [
                      // Remaining Target Card
                      Expanded(
                        child: Container(
                          height: 96.0,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x02000000),
                                blurRadius: 8.0,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.track_changes,
                                    color: theme.colorScheme.onSurfaceVariant,
                                    size: 16.0,
                                  ),
                                  const SizedBox(width: 6.0),
                                  Text(
                                    'Sisa Target',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                remaining <= 0 ? 'Tercapai' : currencyFormatter.format(remaining),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      // Target Date Card
                      Expanded(
                        child: Container(
                          height: 96.0,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x02000000),
                                blurRadius: 8.0,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.event_available,
                                    color: theme.colorScheme.onSurfaceVariant,
                                    size: 16.0,
                                  ),
                                  const SizedBox(width: 6.0),
                                  Text(
                                    'Target Selesai',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goal.targetDate,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.0),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(99.0),
                                    ),
                                    child: Text(
                                      'Aktif',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.onSecondaryContainer,
                                        fontSize: 8.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28.0),

                  // Contribution History Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Riwayat Tabungan',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Lihat Semua',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x02000000),
                          blurRadius: 12.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        for (int i = 0; i < mockContributions.length; i++) ...[
                          ListTile(
                            leading: Container(
                              width: 36.0,
                              height: 36.0,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                mockContributions[i]['icon'] as IconData,
                                color: theme.colorScheme.primary,
                                size: 18.0,
                              ),
                            ),
                            title: Text(
                              mockContributions[i]['title'] as String,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              mockContributions[i]['date'] as String,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            trailing: Text(
                              '+${currencyFormatter.format(mockContributions[i]['amount'] as double)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (i < mockContributions.length - 1)
                            Divider(
                              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                              height: 1.0,
                              indent: 56.0,
                            ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 32.0),
                ],
              ),
            ),

            // Fixed Bottom Button Area
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52.0,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddContributionDialog(context, ref, goal),
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Tabungan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99.0),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      // Delete Target Tabungan
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: theme.colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            title: const Text('Hapus Target Tabungan?'),
                            content: Text('Apakah Anda yakin ingin menghapus target tabungan "${goal.name}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Batal', style: TextStyle(color: theme.colorScheme.outline)),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref.read(savingsGoalsNotifierProvider.notifier).deleteSavingsGoal(goal.id);
                                  Navigator.pop(context); // Pop dialog
                                  Navigator.pop(context); // Pop DetailPage
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Target tabungan "${goal.name}" berhasil dihapus'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: Text('Hapus', style: TextStyle(color: theme.colorScheme.error)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Hapus Target Tabungan',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
