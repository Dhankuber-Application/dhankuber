import 'package:dhankuber/components/footer_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _refreshController;

  // Add these at the top of your _PortfolioPageState class
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _tenureController = TextEditingController();
  final TextEditingController _maturityDateController = TextEditingController();

  final List<Map<String, dynamic>> _portfolio = [
    {
      'id': '1',
      'bankName': 'Premium Finance',
      'amount': 50000,
      'interest': '7.5%',
      'tenure': '12 months',
      'maturityDate': '15/05/2024',
      'color': const Color(0xFFFF6B6B),
      'type': 'internal',
    },
    {
      'id': '2',
      'bankName': 'Safe Investments',
      'amount': 75000,
      'interest': '6.8%',
      'tenure': '24 months',
      'maturityDate': '22/11/2025',
      'color': const Color(0xFF5DADE2),
      'type': 'internal',
    },
    {
      'id': '3',
      'bankName': 'National Bank',
      'amount': 100000,
      'interest': '6.5%',
      'tenure': '36 months',
      'maturityDate': '10/08/2026',
      'color': const Color(0xFF58D68D),
      'type': 'external',
    },
  ];

  bool _showAddModal = false;
  final Map<String, String> _newFD = {
    'bankName': '',
    'amount': '',
    'interest': '',
    'tenure': '',
    'maturityDate': '',
  };
  String _activeTab = 'portfolio';

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _bankNameController.dispose();
    _amountController.dispose();
    _interestController.dispose();
    _tenureController.dispose();
    _maturityDateController.dispose();
    super.dispose();
  }

  double _calculateMaturityAmount(
    String amount,
    String interest,
    String tenure,
  ) {
    try {
      final principal = double.parse(amount);
      final rate = double.parse(interest.replaceAll('%', ''));
      final months = int.parse(tenure.replaceAll(RegExp(r'[^0-9]'), ''));

      // Simple interest calculation: P + (P * r * t)
      // Where t is in years (months / 12)
      final years = months / 12;
      final maturityAmount = principal + (principal * rate * years / 100);

      return maturityAmount;
    } catch (e) {
      return 0.0;
    }
  }

  // Calculate maturity date based on tenure
  String _calculateMaturityDate(String tenure) {
    try {
      final months = int.parse(tenure.replaceAll(RegExp(r'[^0-9]'), ''));
      final now = DateTime.now();
      final maturityDate = DateTime(now.year, now.month + months, now.day);
      return DateFormat('dd/MM/yyyy').format(maturityDate);
    } catch (e) {
      // Return a default date or handle the error appropriately
      final now = DateTime.now();
      return DateFormat(
        'dd/MM/yyyy',
      ).format(now.add(const Duration(days: 365)));
    }
  }

  void _handleAddFD() {
    // Validate all fields are filled
    final bankName = _bankNameController.text;
    final amount = _amountController.text;
    final interest = _interestController.text;
    final tenure = _tenureController.text;

    // Validate all fields are filled
    if (bankName.isEmpty ||
        amount.isEmpty ||
        interest.isEmpty ||
        tenure.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    // Validate amount is a number
    if (double.tryParse(_newFD['amount']!) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    // Validate interest rate is a number
    final interestRate = _newFD['interest']!.replaceAll('%', '');
    if (double.tryParse(interestRate) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid interest rate')),
      );
      return;
    }

    // Validate tenure contains numbers
    if (!RegExp(r'\d+').hasMatch(_newFD['tenure']!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid tenure')),
      );
      return;
    }

    // Calculate maturity amount and date
    final maturityAmount = _calculateMaturityAmount(amount, interest, tenure);
    final maturityDate = _calculateMaturityDate(tenure);

    setState(() {
      _portfolio.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'bankName': bankName,
        'amount': int.parse(amount),
        'interest': interest,
        'tenure': tenure,
        'maturityDate': maturityDate,
        'maturityAmount': maturityAmount,
        'color': Color(
          (DateTime.now().millisecondsSinceEpoch * 0xFFFFFF).toInt(),
        ).withOpacity(1.0),
        'type': 'external',
      });

      // Clear the form
      _bankNameController.clear();
      _amountController.clear();
      _interestController.clear();
      _tenureController.clear();
      _maturityDateController.clear();
      _showAddModal = false;
    });
  }

  // Calculate maturity amount based on principal, interest rate and tenure

  void _handleRefresh() {
    _refreshController.reset();
    _refreshController.forward();
  }

  Widget _buildFDCard(Map<String, dynamic> item, int index) {
    return Animate(
      effects: [
        SlideEffect(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
          delay: Duration(milliseconds: index * 100),
          duration: 600.ms,
          curve: Curves.easeOutQuad,
        ),
        FadeEffect(duration: 800.ms),
      ],
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: item['color'],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['bankName'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      item['type'] == 'internal'
                          ? 'Our Platform'
                          : 'External Bank',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFDDetailItem(
                          'Amount',
                          '₹${NumberFormat('#,##0').format(item['amount'])}',
                        ),
                        _buildFDDetailItem('Interest', item['interest']),
                        _buildFDDetailItem('Tenure', item['tenure']),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          'Matures on',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item['maturityDate'],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF286D27),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFDDetailItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalInvestment = _portfolio.fold<int>(
      0,
      (sum, item) => sum + (item['amount'] as int),
    );

    final chartData =
        _portfolio
            .map(
              (item) => _ChartData(
                item['bankName'],
                item['amount'],
                item['color'],
                '${(item['amount'] / totalInvestment * 100).toStringAsFixed(1)}%',
              ),
            )
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Portfolio',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: _handleRefresh,
                    icon: RotationTransition(
                      turns: _refreshController,
                      child: const Icon(Icons.sync, color: Color(0xFF286D27)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Summary Card
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF286D27),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Investment',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${NumberFormat('#,##0').format(totalInvestment)}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatItem(
                                'FDs',
                                _portfolio.length.toString(),
                              ),
                              _buildStatItem(
                                'Active',
                                _countActiveFDs().toString(),
                              ),
                              _buildStatItem(
                                'Matured',
                                _countMaturedFDs().toString(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Pie Chart
                    Animate(
                      effects: const [FadeEffect(), SlideEffect()],
                      delay: 300.ms,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Investment Distribution',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _portfolio.isEmpty
                                ? SizedBox(
                                  height: 200,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.pie_chart,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'No investments to display',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : Column(
                                  children: [
                                    SizedBox(
                                      height: 200,
                                      child: SfCircularChart(
                                        series: <CircularSeries>[
                                          PieSeries<_ChartData, String>(
                                            dataSource: chartData,
                                            xValueMapper:
                                                (_ChartData data, _) => data.x,
                                            yValueMapper:
                                                (_ChartData data, _) => data.y,
                                            pointColorMapper:
                                                (_ChartData data, _) =>
                                                    data.color,
                                            dataLabelMapper:
                                                (_ChartData data, _) =>
                                                    data.percentage,
                                            dataLabelSettings:
                                                const DataLabelSettings(
                                                  isVisible: true,
                                                  labelPosition:
                                                      ChartDataLabelPosition
                                                          .outside,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    ...chartData.map(
                                      (item) => _buildChartDataItem(item),
                                    ),
                                  ],
                                ),
                          ],
                        ),
                      ),
                    ),
                    // FD List
                    Animate(
                      effects: const [FadeEffect(), SlideEffect()],
                      delay: 500.ms,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Your Fixed Deposits',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed:
                                      () =>
                                          setState(() => _showAddModal = true),
                                  icon: const Icon(
                                    Icons.add,
                                    color: Color(0xFF286D27),
                                    size: 16,
                                  ),
                                  label: const Text(
                                    'Add FD',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF286D27),
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFF286D27,
                                    ).withOpacity(0.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _portfolio.isEmpty
                                ? Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.savings,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "You don't have any FDs yet",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed:
                                            () => setState(
                                              () => _showAddModal = true,
                                            ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF286D27,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Add Your First FD',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : Column(
                                  children:
                                      _portfolio
                                          .asMap()
                                          .entries
                                          .map(
                                            (entry) => _buildFDCard(
                                              entry.value,
                                              entry.key,
                                            ),
                                          )
                                          .toList(),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Add FD Modal
      floatingActionButton:
          _showAddModal
              ? Stack(
                children: [
                  ModalBarrier(
                    dismissible: true,
                    color: Colors.black.withOpacity(0.5),
                    onDismiss: () => setState(() => _showAddModal = false),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Animate(
                      effects: const [SlideEffect()],
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Add External FD',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed:
                                        () => setState(
                                          () => _showAddModal = false,
                                        ),
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  _buildInputField(
                                    'Bank Name',
                                    'Enter bank name',
                                    _bankNameController,
                                    (text) {
                                      _newFD['bankName'] = text;
                                    },
                                  ),
                                  _buildInputField(
                                    'Amount (₹)',
                                    'Enter amount',
                                    _amountController,
                                    (text) {
                                      _newFD['amount'] = text;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  _buildInputField(
                                    'Interest Rate (%)',
                                    'Enter interest rate',
                                    _interestController,
                                    (text) {
                                      _newFD['interest'] = text;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  _buildInputField(
                                    'Tenure',
                                    'e.g. 12 months',
                                    _tenureController,
                                    (text) {
                                      _newFD['tenure'] = text;
                                    },
                                  ),
                                  _buildInputField(
                                    'Maturity Date',
                                    'DD/MM/YYYY',
                                    _maturityDateController,
                                    (text) {
                                      _newFD['maturityDate'] = text;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed:
                                          () => setState(
                                            () => _showAddModal = false,
                                          ),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.all(16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _handleAddFD,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF286D27,
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Add FD',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
              : null,
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  int _countActiveFDs() {
    int count = 0;
    for (var fd in _portfolio) {
      try {
        final maturityDate = DateFormat('dd/MM/yyyy').parse(fd['maturityDate']);
        if (maturityDate.isAfter(DateTime.now())) {
          count++;
        }
      } catch (e) {
        // Handle invalid dates - you might want to log this
      }
    }
    return count;
  }

  int _countMaturedFDs() {
    int count = 0;
    for (var fd in _portfolio) {
      try {
        final maturityDate = DateFormat('dd/MM/yyyy').parse(fd['maturityDate']);
        if (!maturityDate.isAfter(DateTime.now())) {
          count++;
        }
      } catch (e) {
        // Handle invalid dates - you might want to log this
      }
    }
    return count;
  }

  Widget _buildChartDataItem(_ChartData item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.x,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '₹${NumberFormat('#,##0').format(item.y)}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              item.percentage,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller,
    Function(String) onChanged, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.color, this.percentage);

  final String x;
  final int y;
  final Color color;
  final String percentage;
}
