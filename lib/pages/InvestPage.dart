import 'dart:math';
import 'package:intl/intl.dart';
import 'package:dhankuber/pages/ConfirmationPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InvestPage extends StatefulWidget {
  final String bankName;
  final String interest;
  final Color color;

  const InvestPage({
    Key? key,
    required this.bankName,
    required this.interest,
    required this.color,
  }) : super(key: key);

  @override
  _InvestPageState createState() => _InvestPageState();
}

class _InvestPageState extends State<InvestPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _buttonController;
  late AnimationController _cardController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<double> _cardAnimation;

  String amount = '10000';
  String tenure = '12';
  int step = 1;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _slideAnimation = Tween<double>(begin: 0.1, end: 0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );
    _buttonAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );
    _cardAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _buttonController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _handleInvestNow() async {
    await _buttonController.forward();
    await _buttonController.reverse();

    if (step == 1) {
      await _cardController.forward();
      setState(() {
        step = 2;
        _cardController.reset();
      });
    } else {
      // Navigate to portfolio page
      Navigator.pushNamed(context, '/portfolio');
    }
  }

  double _calculateMaturityAmount() {
    double principal = double.parse(amount);
    double rate = double.parse(widget.interest.replaceAll('%', '')) / 100;
    int months = int.parse(tenure);

    // Compound interest formula for monthly compounding
    return principal * pow(1 + rate / 12, months);
  }

  DateTime _calculateMaturityDate() {
    return DateTime.now().add(Duration(days: 30 * int.parse(tenure)));
  }

  List<ChartData> _getChartData() {
    double principal = double.parse(amount);
    double rate = double.parse(widget.interest.replaceAll('%', '')) / 100;
    int months = int.parse(tenure);

    List<ChartData> data = [];
    for (int i = 0; i <= months; i++) {
      double amount = principal * pow(1 + rate / 12, i);
      data.add(ChartData(i, amount));
    }
    return data;
  }

  Widget _buildFrontCard() {
    return AnimatedBuilder(
      animation: _cardAnimation,
      builder: (context, child) {
        return Transform(
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_cardAnimation.value * 3.1415926535),
          alignment: Alignment.center,
          child: Opacity(opacity: 1 - _cardAnimation.value, child: child),
        );
      },
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 5),
                  blurRadius: 10,
                ),
              ],
            ),
            padding: EdgeInsets.all(24),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.bankName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.interest,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fixed Deposit',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'RBI Insured',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  right: 24,
                  top: 100 - 30,
                  child: Icon(
                    FontAwesomeIcons.building,
                    size: 60,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(
                    0,
                    _slideAnimation.value * MediaQuery.of(context).size.height,
                  ),
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Investment Amount',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '₹',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: amount),
                            onChanged: (value) {
                              setState(() {
                                amount = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '10,000',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => amount = '500000'),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'MAX',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Tenure (Months)',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        ['6', '12', '24', '36'].map((item) {
                          bool isSelected = tenure == item;
                          return GestureDetector(
                            onTap:
                                () => setState(() {
                                  tenure = item;
                                }),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Color(0xFF286D27)
                                        : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.grey[800],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  SizedBox(height: 24),
                  Container(
                    height: 200,
                    child: SfCartesianChart(
                      primaryXAxis: NumericAxis(
                        title: AxisTitle(text: 'Months'),
                        interval: (int.parse(tenure) ~/ 4).toDouble(),
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: 'Amount (₹)'),
                        numberFormat: NumberFormat.compact(),
                      ),
                      series: <CartesianSeries<ChartData, int>>[
                        LineSeries<ChartData, int>(
                          dataSource: _getChartData(),
                          xValueMapper: (ChartData data, _) => data.month,
                          yValueMapper: (ChartData data, _) => data.amount,
                          markerSettings: MarkerSettings(isVisible: true),
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            labelAlignment: ChartDataLabelAlignment.top,
                          ),
                        ),
                      ],
                      tooltipBehavior: TooltipBehavior(enable: true),
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('Interest Rate', widget.interest),
                        SizedBox(height: 12),
                        _buildDetailRow(
                          'Maturity Amount',
                          '₹${_calculateMaturityAmount().toStringAsFixed(0)}',
                        ),
                        SizedBox(height: 12),
                        _buildDetailRow(
                          'Maturity Date',
                          '${_calculateMaturityDate().day}/${_calculateMaturityDate().month}/${_calculateMaturityDate().year}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildInvestButton() {
    return AnimatedBuilder(
      animation: _buttonAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _buttonAnimation.value, child: child);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          elevation: 4,
          child: InkWell(
            onTap: _handleInvestNow,

            borderRadius: BorderRadius.circular(12),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF286D27), Color(0xFF3E8C40)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    step == 1 ? 'CONFIRM INVESTMENT' : 'VIEW PORTFOLIO',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    step == 1
                        ? FontAwesomeIcons.lock
                        : FontAwesomeIcons.chartLine,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNote() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(
              0,
              _slideAnimation.value * MediaQuery.of(context).size.height,
            ),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.infoCircle,
              size: 16,
              color: Colors.grey[600],
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Your investment is secured with RBI insurance up to ₹5,00,000',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F9FC), Color(0xFFEEF2F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(
                        0,
                        _slideAnimation.value *
                            MediaQuery.of(context).size.height,
                      ),
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(FontAwesomeIcons.arrowLeft),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Invest in ${widget.bankName}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      step == 1
                          ? _buildFrontCard()
                          : ConfirmationPage(
                            bankName: widget.bankName,
                            amount: amount,
                            tenure: tenure,
                            interest: widget.interest,
                            maturityAmount: _calculateMaturityAmount()
                                .toStringAsFixed(0),
                            maturityDate: _calculateMaturityDate(),
                            color: widget.color,
                          ),
                      SizedBox(height: 30),
                      _buildInvestButton(),
                      if (step == 1) SizedBox(height: 20),
                      if (step == 1) _buildNote(),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final int month;
  final double amount;

  ChartData(this.month, this.amount);
}
