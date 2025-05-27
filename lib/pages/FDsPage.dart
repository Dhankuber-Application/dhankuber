import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'profilePage.dart'; // Uncomment if using ProfilePage

class FDPage extends StatefulWidget {
  @override
  State<FDPage> createState() => _FDPageState();
}

class _FDPageState extends State<FDPage> {
  int _selectedFDTab = 1;

  final List<String> fdTabs = [
    'upto 2 yrs',
    '2 to 3 yrs',
    'over 3 yrs',
  ];

  final List<List<Map<String, String>>> fdRates = [
    [
      {'bank': 'xyz Finance bank', 'rate': '6.5%'},
      {'bank': 'xyz Finance bank', 'rate': '8.8%'},
      {'bank': 'xyz Finance bank', 'rate': '9.0%'},
    ],
    [
      {'bank': 'xyz Finance bank', 'rate': '7%'},
      {'bank': 'xyz Finance bank', 'rate': '9.1%'},
      {'bank': 'xyz Finance bank', 'rate': '9.2%'},
    ],
    [
      {'bank': 'xyz Finance bank', 'rate': '7.5%'},
      {'bank': 'xyz Finance bank', 'rate': '8.5%'},
      {'bank': 'xyz Finance bank', 'rate': '9.0%'},
    ],
  ];

  final List<Map<String, dynamic>> bestForYouTabs = [
    {
      'title': 'Highest Interest FDs',
      'icon': Icons.trending_up,
      'colors': [Color(0xFF846AFF), Color(0xFF755EE8)],
    },
    {
      'title': 'Save Monthly with RDs',
      'icon': Icons.savings,
      'colors': [Color(0xFFFFA726), Color(0xFFFF7043)],
    },
    {
      'title': 'Tax Saver FDs',
      'icon': Icons.account_balance_wallet,
      'colors': [Color(0xFF43CEA2), Color(0xFF185A9D)],
    },
    {
      'title': 'Senior Citizen FDs',
      'icon': Icons.verified_user,
      'colors': [Color(0xFFf7971e), Color(0xFFffd200)],
    },
    {
      'title': 'Short Term FDs',
      'icon': Icons.timer,
      'colors': [Color(0xFF00c6ff), Color(0xFF0072ff)],
    },
    {
      'title': 'Flexible FDs',
      'icon': Icons.autorenew,
      'colors': [Color(0xFFfe8c00), Color(0xFFf83600)],
    },
  ];

  int _mcqIndex = 0;
  final List<Map<String, dynamic>> mcqQuestions = [
    {
      'question': 'What is your investment goal?',
      'options': ['High returns', 'Safety', 'Tax saving', 'Liquidity'],
    },
    {
      'question': 'Preferred tenure?',
      'options': ['<1 year', '1-2 years', '2-3 years', '>3 years'],
    },
    {
      'question': 'Investment amount range?',
      'options': ['<50k', '50k-2L', '2L-5L', '>5L'],
    },
    {
      'question': 'Are you a senior citizen?',
      'options': ['Yes', 'No'],
    },
  ];
  List<int> mcqAnswers = [];

  void _nextMcq(int selected) {
    setState(() {
      if (mcqAnswers.length > _mcqIndex) {
        mcqAnswers[_mcqIndex] = selected;
      } else {
        mcqAnswers.add(selected);
      }
      if (_mcqIndex < mcqQuestions.length - 1) {
        _mcqIndex++;
      }
    });
  }

  void _prevMcq() {
    if (_mcqIndex > 0) {
      setState(() {
        _mcqIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          SizedBox(height: 16),
          Text(
            'Best for you',
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[800], fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 18),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: bestForYouTabs.length,
              separatorBuilder: (_, __) => SizedBox(width: 16),
              itemBuilder: (context, idx) {
                final tab = bestForYouTabs[idx];
                return Container(
                  width: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: tab['colors'],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: tab['colors'][0].withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(tab['icon'], color: Colors.white, size: 38),
                        SizedBox(height: 18),
                        Text(
                          tab['title'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 18),
          Text('FD rates at a glance', style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700])),
          SizedBox(height: 10),
          ToggleButtons(
            borderRadius: BorderRadius.circular(12),
            isSelected: List.generate(3, (i) => i == _selectedFDTab),
            onPressed: (idx) {
              setState(() {
                _selectedFDTab = idx;
              });
            },
            children: fdTabs.map((e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(e, style: GoogleFonts.poppins(fontSize: 14)),
            )).toList(),
          ),
          SizedBox(height: 12),
          Column(
            children: fdRates[_selectedFDTab].asMap().entries.map((entry) {
              final idx = entry.key;
              final data = entry.value;
              Color bgColor;
              if (idx == 0) bgColor = Colors.blue.shade100;
              else if (idx == 1) bgColor = Colors.yellow.shade100;
              else bgColor = Colors.pink.shade100;
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.apartment, color: Colors.deepOrange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(data['bank']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(data['rate']!, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 18),
          Text('Personalize your perfect FD', style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700])),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  mcqQuestions[_mcqIndex]['question'],
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                SizedBox(height: 14),
                ...List.generate(
                  mcqQuestions[_mcqIndex]['options'].length,
                      (optIdx) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (mcqAnswers.length > _mcqIndex && mcqAnswers[_mcqIndex] == optIdx)
                            ? Colors.orange
                            : Colors.white,
                        foregroundColor: (mcqAnswers.length > _mcqIndex && mcqAnswers[_mcqIndex] == optIdx)
                            ? Colors.white
                            : Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: Colors.orange.shade200),
                      ),
                      onPressed: () => _nextMcq(optIdx),
                      child: Text(mcqQuestions[_mcqIndex]['options'][optIdx], style: GoogleFonts.poppins()),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_mcqIndex > 0)
                      TextButton(
                        onPressed: _prevMcq,
                        child: Text('Back', style: GoogleFonts.poppins()),
                      ),
                    if (_mcqIndex < mcqQuestions.length - 1)
                      TextButton(
                        onPressed: () {
                          if (mcqAnswers.length > _mcqIndex) {
                            _nextMcq(mcqAnswers[_mcqIndex]);
                          }
                        },
                        child: Text('Next', style: GoogleFonts.poppins()),
                      ),
                    if (_mcqIndex == mcqQuestions.length - 1)
                      TextButton(
                        onPressed: () {
                          // Submit logic here
                        },
                        child: Text('Submit', style: GoogleFonts.poppins()),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
