import 'package:flutter/material.dart';
import 'package:my_duit/features/home/presentation/pages/home_page.dart';
import 'package:my_duit/features/transactions/presentation/view/transactions_page.dart';
import 'package:my_duit/features/budget/presentation/view/budget_page.dart';

import 'package:my_duit/features/more/presentation/view/more_page.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const TransactionsPage(),
    const BudgetPage(),
    const MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildNavItem(int index, IconData iconData, String label) {
      final isSelected = _currentIndex == index;
      final color = isSelected ? theme.colorScheme.primary : theme.colorScheme.outline;

      return Expanded(
        child: InkWell(
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: color,
                size: 24.0,
              ),
              const SizedBox(height: 4.0),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for adding transaction
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        shape: const CircleBorder(),
        elevation: 4.0,
        child: const Icon(Icons.add, size: 28.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: theme.colorScheme.surface,
        elevation: 8.0,
        child: Container(
          height: 60.0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildNavItem(0, Icons.home_filled, 'Home'),
              buildNavItem(1, Icons.list_alt, 'Transactions'),
              const SizedBox(width: 48.0), // Spacer for Floating Action Button
              buildNavItem(2, Icons.pie_chart, 'Budget'),
              buildNavItem(3, Icons.more_horiz, 'More'),
            ],
          ),
        ),
      ),
    );
  }
}
