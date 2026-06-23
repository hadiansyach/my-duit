import 'package:flutter/material.dart';
import '../widgets/home_top_app_bar.dart';
import '../widgets/summary_hero_card.dart';
import '../widgets/period_filter_chips.dart';
import '../widgets/category_expense_card.dart';
import '../widgets/cash_flow_card.dart';
import '../widgets/recent_transactions_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeTopAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 8.0,
            bottom: 100.0, // Space for BottomNavBar clearance
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SummaryHeroCard(),
              SizedBox(height: 24.0),
              PeriodFilterChips(),
              SizedBox(height: 24.0),
              CategoryExpenseCard(),
              SizedBox(height: 24.0),
              CashFlowCard(),
              SizedBox(height: 24.0),
              RecentTransactionsList(),
            ],
          ),
        ),
      ),
    );
  }
}
