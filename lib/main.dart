import 'package:dhankuber/components/Header.dart';
import 'package:dhankuber/components/footer_navbar.dart';
import 'package:dhankuber/pages/InvestPage.dart';
import 'package:dhankuber/pages/HomePage.dart';
import 'package:dhankuber/pages/portfolio_page.dart';
import 'package:flutter/material.dart';
import 'package:dhankuber/pages/authentication/welcome_screen.dart';
import 'package:dhankuber/pages/ConfirmationPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dhankuber",
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/main':
            (context) =>
                const MainAppWrapper(initialTab: 'home'), // New main route
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/invest':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (context) => InvestPage(
                    bankName: args['bankName'],
                    interest: args['interest'],
                    color: args['color'],
                  ),
            );
          case '/confirmation':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (context) => ConfirmationPage(
                    bankName: args['bankName'],
                    amount: args['amount'],
                    tenure: args['tenure'],
                    interest: args['interest'],
                    maturityAmount: args['maturityAmount'],
                    maturityDate: args['maturityDate'],
                    color: args['color'],
                  ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const WelcomeScreen(),
            );
        }
      },
    );
  }
}

class MainAppWrapper extends StatefulWidget {
  final String initialTab;

  const MainAppWrapper({super.key, required this.initialTab});

  @override
  State<MainAppWrapper> createState() => _MainAppWrapperState();
}

class _MainAppWrapperState extends State<MainAppWrapper> {
  late String _currentTab;
  int _unreadNotifications = 3;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
  }

  void _changeTab(String tab) {
    setState(() {
      _currentTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Header(
          initialUnreadNotifications: _unreadNotifications,
          onNotificationPressed: () {
            setState(() => _unreadNotifications = 0);
          },
          onProfilePressed: () => _changeTab('profile'),
        ),
      ),
      body: _getCurrentPage(),
      bottomNavigationBar: FooterNavbar(
        activeTab: _currentTab,
        onTabChanged: _changeTab,
      ),
    );
  }

  Widget _getCurrentPage() {
    switch (_currentTab) {
      case 'home':
        return const HomePage(); // Make sure HomePage is a simple widget without its own Scaffold
      case 'portfolio':
        return const PortfolioPage();
      case 'fds':
        return Container(child: const Center(child: Text('FDs Page')));
      case 'profile':
        return Container(child: const Center(child: Text('Profile Page')));
      default:
        return const HomePage();
    }
  }
}
