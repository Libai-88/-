import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../screens/home_screen.dart';
import '../screens/moment_screen.dart';
import '../screens/wishlist_screen.dart';
import '../screens/whisper_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  static const List<_NavTab> _tabs = [
    _NavTab(
      activeIcon: Icons.cottage_rounded,
      inactiveIcon: Icons.cottage_outlined,
      label: '小屋',
    ),
    _NavTab(
      activeIcon: Icons.auto_awesome_rounded,
      inactiveIcon: Icons.auto_awesome_outlined,
      label: '瞬间',
    ),
    _NavTab(
      activeIcon: Icons.favorite_rounded,
      inactiveIcon: Icons.favorite_border_rounded,
      label: '愿望',
    ),
    _NavTab(
      activeIcon: Icons.mail_rounded,
      inactiveIcon: Icons.mail_outline_rounded,
      label: '悄悄话',
    ),
  ];

  final List<Widget> _screens = const [
    HomeScreen(),
    MomentScreen(),
    WishlistScreen(),
    WhisperScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildNavBar(context),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabs.length, (index) {
              final tab = _tabs[index];
              final isSelected = _currentIndex == index;

              return _NavBarItem(
                tab: tab,
                isSelected: isSelected,
                onTap: () => setState(() => _currentIndex = index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;

  const _NavTab({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}

class _NavBarItem extends StatelessWidget {
  final _NavTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.deepRose : AppColors.warmBrown.withOpacity(0.4);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.softPink.withOpacity(0.5) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? tab.activeIcon : tab.inactiveIcon,
                key: ValueKey(isSelected),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: color,
              ),
              child: Text(tab.label),
            ),
          ],
        ),
      ),
    );
  }
}
