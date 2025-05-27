import 'package:dhankuber/components/Header.dart';
import 'package:dhankuber/components/footer_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentIndex = 0;
  String _activeFilter = 'all';
  String _activeTab = 'home';

  final List<Map<String, dynamic>> _fdData = [
    {
      'id': 1,
      'bankName': 'Premium Finance',
      'interest': '8.5%',
      'color': const Color(0xFFFF6B6B),
      'tenure': '1-2 Years',
      'rating': 4.5,
      'category': 'high-return',
    },
    {
      'id': 2,
      'bankName': 'Safe Investments',
      'interest': '7.2%',
      'color': const Color(0xFF00BFFF),
      'tenure': '3-5 Years',
      'rating': 4.8,
      'category': 'safe',
    },
    {
      'id': 3,
      'bankName': 'Quick Returns',
      'interest': '9.1%',
      'color': const Color(0xFFADFF2F),
      'tenure': '6-12 Months',
      'rating': 4.2,
      'category': 'high-return',
    },
    {
      'id': 4,
      'bankName': 'Long Term Bank',
      'interest': '7.8%',
      'color': const Color(0xFFA569BD),
      'tenure': '5+ Years',
      'rating': 4.7,
      'category': 'safe',
    },
    {
      'id': 5,
      'bankName': 'Flexi Savings',
      'interest': '6.9%',
      'color': const Color(0xFF5DADE2),
      'tenure': 'Flexible',
      'rating': 4.3,
      'category': 'flexible',
    },
    {
      'id': 6,
      'bankName': 'Senior Citizen',
      'interest': '8.9%',
      'color': const Color(0xFFF4D03F),
      'tenure': '1-3 Years',
      'rating': 4.9,
      'category': 'senior',
    },
  ];

  final List<Map<String, dynamic>> _suggestions = [
    {'id': 1},
    {'id': 2},
    {'id': 3},
  ];

  List<Map<String, dynamic>> get _filteredData {
    if (_activeFilter == 'all') return _fdData;
    if (_activeFilter == 'high-return') {
      return _fdData
          .where(
            (item) => double.parse(item['interest'].replaceAll('%', '')) >= 8.0,
          )
          .toList();
    }
    if (_activeFilter == 'safe') {
      return _fdData.where((item) => item['rating'] >= 4.5).toList();
    }
    return _fdData.where((item) => item['category'] == _activeFilter).toList();
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Gradient Carousel
                  SizedBox(
                    height: 220,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        return const SuggestionCarousel();
                      },
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_suggestions.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _currentIndex == index ? 16 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF286D27),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  // FD Cards Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Our Top FD's",
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF333333),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'View All',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF286D27),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Filter Buttons
                        SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              const SizedBox(width: 8),
                              FilterButton(
                                active: _activeFilter == 'all',
                                label: 'All',
                                onPress: () {
                                  setState(() {
                                    _activeFilter = 'all';
                                  });
                                },
                              ),
                              FilterButton(
                                active: _activeFilter == 'high-return',
                                label: 'High Returns',
                                onPress: () {
                                  setState(() {
                                    _activeFilter = 'high-return';
                                  });
                                },
                              ),
                              FilterButton(
                                active: _activeFilter == 'safe',
                                label: 'Safe',
                                onPress: () {
                                  setState(() {
                                    _activeFilter = 'safe';
                                  });
                                },
                              ),
                              FilterButton(
                                active: _activeFilter == 'flexible',
                                label: 'Flexible',
                                onPress: () {
                                  setState(() {
                                    _activeFilter = 'flexible';
                                  });
                                },
                              ),
                              FilterButton(
                                active: _activeFilter == 'senior',
                                label: 'Senior Citizen',
                                onPress: () {
                                  setState(() {
                                    _activeFilter = 'senior';
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // FD Cards List
                        ..._filteredData.map(
                          (item) => FDCard(
                            item: item,
                            index: _filteredData.indexOf(item),
                          ),
                        ),
                        SizedBox(height: height * 0.12), // Space for footer
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Footer
          ],
        ),
      ),
    );
  }
}

class FDCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final int index;

  const FDCard({super.key, required this.item, required this.index});

  @override
  State<FDCard> createState() => _FDCardState();
}

class _FDCardState extends State<FDCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _rotateAnimation = Tween<double>(
      begin: -5.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Transform.rotate(
                  angle: _rotateAnimation.value * (3.1415926535 / 180),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: widget.item['color'],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      FontAwesomeIcons.building,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.item['bankName'],
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.item['tenure'],
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF666666),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${widget.item['rating']} ★',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF666666),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Interest %',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF555555),
                      ),
                    ),
                    Text(
                      'upto ${widget.item['interest']}',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CFF4C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/invest',
                          arguments: {
                            'bankName':
                                widget
                                    .item['bankName'], // Replace with your actual bank name
                            'interest':
                                widget
                                    .item['interest'], // Replace with actual interest
                            'color':
                                widget
                                    .item["color"], // Replace with actual color
                          },
                        );
                      },
                      child: Text(
                        'Invest now',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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

class FilterButton extends StatefulWidget {
  final bool active;
  final String label;
  final VoidCallback onPress;

  const FilterButton({
    super.key,
    required this.active,
    required this.label,
    required this.onPress,
  });

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPress();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    widget.active
                        ? const Color(0xFF286D27)
                        : const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.only(right: 8),
              child: Text(
                widget.label,
                style: GoogleFonts.inter(
                  color: widget.active ? Colors.white : const Color(0xFF333333),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FeatureCard extends StatefulWidget {
  final IconData? icon;
  final String label;
  final String? emoji;
  final VoidCallback onPress;

  const FeatureCard({
    super.key,
    this.icon,
    required this.label,
    this.emoji,
    required this.onPress,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 15.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPress();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotateAnimation.value * (3.1415926535 / 180),
              child: Container(
                width: 70,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null)
                      Icon(
                        widget.icon,
                        size: 24,
                        color: const Color(0xFF286D27),
                      )
                    else
                      Text(widget.emoji!, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 8),
                    Text(
                      widget.label,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: const Color(0xFF333333),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SuggestionCarousel extends StatefulWidget {
  const SuggestionCarousel({super.key});

  @override
  State<SuggestionCarousel> createState() => _SuggestionCarouselState();
}

class _SuggestionCarouselState extends State<SuggestionCarousel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 360.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: 220,
      width: width * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4FC3F7), Color(0xFF9C27B0), Color(0xFFE91E63)],
        ),
      ),
      padding: const EdgeInsets.only(),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotateAnimation.value * (3.1415926535 / 180),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Invest in safe high return FDs',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const Icon(
                      FontAwesomeIcons.ellipsisH,
                      size: 20,
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  'Bank FDs insured by RBI',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    text: 'upto ',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.87),
                    ),
                    children: [
                      TextSpan(
                        text: '5 Lakhs',
                        style: GoogleFonts.inter(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/invest',
                        arguments: {
                          'bankName':
                              'Premium Finance', // Replace with your actual bank name
                          'interest': '8.5%', // Replace with actual interest
                          'color': Colors.red, // Replace with actual color
                        },
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Invest Now',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          FontAwesomeIcons.arrowRight,
                          size: 14,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
