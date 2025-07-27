import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../domain/entities/transaction_entity.dart';
import '../../../core/utils.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../widgets/transaction/transaction_tile.dart';
import 'transactions_summary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String period = "Today";
  bool fabExpanded = false;

  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(LoadAllTransactionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFF5E1), Color(0xFFF4E3FF)],
              ),
            ),
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TransactionLoaded) {
                  final transactions = state.transactions;
                  final selectedMonth = state.selectedMonth;
                  final filteredList = filterTransactionsByPeriod(
                    transactions,
                    period,
                    selectedMonth,
                  );
                  final totalIncome = filteredList
                      .where((t) => t.type == TransactionType.income)
                      .fold<double>(0, (sum, t) => sum + t.amount);
                  final totalExpense = filteredList
                      .where((t) => t.type == TransactionType.expense)
                      .fold<double>(0, (sum, t) => sum + t.amount);
                  final balance = totalIncome - totalExpense;

                  final showList = filteredList.take(3).toList();
                  final showSeeAll = filteredList.length > 3;

                  return SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, selectedMonth),
                        SizedBox(height: 2),
                        Center(child: _buildBalanceCard(balance)),
                        SizedBox(height: 18),
                        _buildIncomeExpenseCards(totalIncome, totalExpense),
                        SizedBox(height: 28),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Spend Frequency",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        _buildLineChart(),
                        SizedBox(height: 12),
                        _buildPeriodTabs(),
                        SizedBox(height: 3),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Recent Transaction",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              if (showSeeAll)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => TransactionsSummaryScreen(
                                          transactions: filteredList,
                                          period: period,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "See All",
                                    style: TextStyle(
                                      color: Color(0xFF9263DD),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: showList.isEmpty
                              ? const Center(child: Text("No Transactions"))
                              : ListView.separated(
                                  // physics: BouncingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 2,
                                  ),
                                  itemCount: showList.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 10),
                                  itemBuilder: (context, index) =>
                                      TransactionTile(
                                        transaction: showList[index],
                                      ),
                                ),
                        ),
                      ],
                    ),
                  );
                } else if (state is TransactionError) {
                  return Center(child: Text(state.message));
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DateTime selectedMonth) {
    final List<DateTime> months = List.generate(
        12, (index) => DateTime(selectedMonth.year, index + 1));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile.jpg'),
            radius: 22,
          ),

          PopupMenuButton<DateTime>(
            initialValue: selectedMonth,
            onSelected: (DateTime newMonth) {
              context.read<TransactionBloc>().add(UpdateSelectedMonthEvent(newMonth));
            },
            itemBuilder: (context) {
              return months.map((DateTime month) {
                return PopupMenuItem<DateTime>(
                  value: month,
                  child: Text(DateFormat('MMMM').format(month)),
                );
              }).toList();
            },
            child: Row(
              children: [
                Text(
                  DateFormat('MMMM').format(selectedMonth),
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
                Icon(Icons.keyboard_arrow_down, size: 21),
              ],
            ),
          ),

          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Color(0xFF9263DD),
              size: 28,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(double balance) {
    return Column(
      children: [
        Text(
          "Account Balance",
          style: TextStyle(
            fontSize: 15,
            color: Colors.black.withOpacity(0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "₹${balance.toStringAsFixed(0)}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
        ),
      ],
    );
  }

  Widget _buildIncomeExpenseCards(double income, double expense) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _amountCard(
            'Income',
            income,
            Color(0xFF169B50),
            Icons.account_balance_wallet,
          ),
          SizedBox(width: 24),
          _amountCard(
            'Expenses',
            expense,
            Color(0xFFE0494A),
            Icons.account_balance_wallet,
          ),
        ],
      ),
    );
  }

  Widget _amountCard(String label, double amount, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "₹${amount.toStringAsFixed(0)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return SizedBox(
      height: 108,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 5,
          minY: 0,
          maxY: 5,
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 1.2),
                FlSpot(1, 2.8),
                FlSpot(2, 1.5),
                FlSpot(3, 6.0),
                FlSpot(4, 2.7),
                FlSpot(5, 3.3),
              ],
              isCurved: true,
              barWidth: 4,
              color: Color(0xFF9263DD),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodTabs() {
    final periods = ['Today', 'Week', 'Month', 'Year'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(periods.length, (i) {
          final isSelected = period == periods[i];
          return GestureDetector(
            onTap: () {
              setState(() {
                period = periods[i];
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFFFE4B8) : Colors.transparent,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                periods[i],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.orange : Colors.black54,
                  fontSize: 20,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
