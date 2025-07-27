import 'package:flutter/material.dart';
import 'package:sky_goal_task/presentation/pages/profile/profile_screen.dart';
import 'package:sky_goal_task/presentation/pages/home/add_transaction_screen.dart';
import 'package:sky_goal_task/presentation/pages/transaction/all_transaction_screen.dart';
import 'budget/budget_screen.dart';
import 'home/home.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    AllTransactionsScreen(),
    BudgetScreen(),
    ProfileScreen(),
  ];
  bool fabExpanded = false;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      fabExpanded = false;
    });
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 4,
      selectedItemColor: Color(0xFF9263DD),
      unselectedItemColor: Colors.grey[400],
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Transaction'),
        BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Budget'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _buildCustomFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildCustomFAB(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          if (fabExpanded)
            Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMiniButton(
                    icon: Icons.arrow_downward,
                    bgColor: Color(0xFF169B50),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddTransactionScreen(isExpense: false),
                        ),
                      );
                      setState(() => fabExpanded = false);
                    },
                  ),
                  const SizedBox(width: 50),
                  _buildMiniButton(
                    icon: Icons.arrow_upward,
                    bgColor: Color(0xFFE0494A),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddTransactionScreen(isExpense: true),
                        ),
                      );
                      setState(() => fabExpanded = false);
                    },
                  ),
                ],
              ),
            ),

          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: _buildMainButton(
                icon: fabExpanded ? Icons.close : Icons.add,
                bgColor: Color(0xFF9263DD),
                onTap: () => setState(() => fabExpanded = !fabExpanded),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton({
    required IconData icon,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 6,
      shape: CircleBorder(),
      color: bgColor,
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 60,
          height: 60,
          child: Center(
            child: Icon(Icons.add, color: Colors.white, size: 32),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniButton({
    required IconData icon,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 4,
      shape: CircleBorder(),
      color: bgColor,
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Center(
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }
}
