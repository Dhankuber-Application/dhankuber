import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FooterNavbar extends StatefulWidget {
  final String activeTab;
  final Function(String) onTabChanged;

  const FooterNavbar({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  State<FooterNavbar> createState() => _FooterNavbarState();
}

class _FooterNavbarState extends State<FooterNavbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 100 * (1 - _animationController.value)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFooterTab(Icons.home, 'Home', 'home'),
                _buildFooterTab(Icons.show_chart, 'Portfolio', 'portfolio'),
                _buildFooterTab(Icons.savings, 'FDs', 'fds'),
                _buildFooterTab(Icons.person, 'Profile', 'profile'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooterTab(IconData icon, String label, String tab) {
    final isActive = widget.activeTab == tab;
    return GestureDetector(
      onTap: () {
        widget.onTabChanged(tab);
        _animateTab();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isActive ? const Color(0xFF286D27) : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF286D27) : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _animateTab() {
    _animationController.reset();
    _animationController.forward();
  }
}
