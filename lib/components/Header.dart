import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Header extends StatefulWidget {
  final int initialUnreadNotifications;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onLanguagePressed;
  final bool showLogo;
  final bool showNotifications;
  final bool showProfile;

  const Header({
    super.key,
    this.initialUnreadNotifications = 0,
    this.onNotificationPressed,
    this.onProfilePressed,
    this.onLanguagePressed,
    this.showLogo = true,
    this.showNotifications = true,
    this.showProfile = true,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late int _unreadNotifications;

  @override
  void initState() {
    super.initState();
    _unreadNotifications = widget.initialUnreadNotifications;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleNotificationPressed() {
    setState(() {
      _unreadNotifications = 0;
    });
    widget.onNotificationPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        return Opacity(
          opacity: _animationController.value,
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 25),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.showLogo)
                  Image.asset(
                    'assets/Dhan-Kuber-Logo.png',
                    height: 40,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                if (!widget.showLogo) const Spacer(),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.language),
                      onPressed: () {
                        _showLanguageDialog(context);
                        widget.onLanguagePressed?.call();
                      },
                    ),
                    if (widget.showNotifications)
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.bell),
                            onPressed: _handleNotificationPressed,
                          ),
                          if (_unreadNotifications > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  _unreadNotifications.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),

                    if (widget.showProfile)
                      GestureDetector(
                        onTap: widget.onProfilePressed,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF286D27),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.user,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

final List<Map<String, String>> _languages = [
  {'code': 'hi', 'name': 'Hindi', 'native': 'हिन्दी'},
  {'code': 'bn', 'name': 'Bengali', 'native': 'বাংলা'},
  {'code': 'te', 'name': 'Telugu', 'native': 'తెలుగు'},
  {'code': 'mr', 'name': 'Marathi', 'native': 'मराठी'},
  {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்'},
  {'code': 'ur', 'name': 'Urdu', 'native': 'اردو'},
  {'code': 'gu', 'name': 'Gujarati', 'native': 'ગુજરાતી'},
  {'code': 'kn', 'name': 'Kannada', 'native': 'ಕನ್ನಡ'},
  {'code': 'ml', 'name': 'Malayalam', 'native': 'മലയാളം'},
  {'code': 'or', 'name': 'Odia', 'native': 'ଓଡ଼ିଆ'},
  {'code': 'pa', 'name': 'Punjabi', 'native': 'ਪੰਜਾਬੀ'},
  {'code': 'as', 'name': 'Assamese', 'native': 'অসমীয়া'},
];

void _showLanguageDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
    return SimpleDialog(
        title: const Text('Choose Language'),
        children: _languages.map((language) {
      return SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
            // Handle language selection here
            print('Selected: ${language['code']}');
          },
          child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(language['name']!),
                const SizedBox(width: 12),
                Text(
                  language['native']!,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
      );
        }).toList(),
    );
      },
  );
}

