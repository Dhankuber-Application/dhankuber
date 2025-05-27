import 'package:flutter/material.dart';
import 'editProfile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // <--- Makes entire page scrollable
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey,
                    // backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  const SizedBox(height: 0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      _navigateTo(context, const EditProfilePage());
                    },
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Disable inner scrolling
              children: [
                sectionHeader('Finance'),
                profileTile(context, 'Investments', const InvestmentsPage()),
                profileTile(context, 'Transactions', const TransactionsPage()),
                profileTile(context, 'Add Balance', const AddBalancePage()),
                const Divider(),
                sectionHeader('Help'),
                profileTile(context, 'Contact US', const ContactUsPage(), icon: Icons.phone),
                profileTile(context, 'FAQs', const FAQsPage(), icon: Icons.question_mark),
                profileTile(context, 'Terms & Conditions', const TermsPage(), icon: Icons.description),
                const Divider(),
                sectionHeader('Preferences'),
                profileTile(context, 'Language', const LanguagePage(), icon: Icons.language),
                profileTile(context, 'Privacy Policy', const PrivacyPolicyPage(), icon: Icons.privacy_tip),
                profileTile(context, 'Referral', const ReferralPage(), icon: Icons.add_circle_outline),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout', style: TextStyle(fontSize: 16)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Implement logout logic
                  },
                ),
                const SizedBox(height: 60),
                const Padding(
                  padding: EdgeInsets.only(bottom: 50.0),
                  child: Center(
                    child: Text(
                      'Thank you for using Dhankuber\nEmail: support@dhankuber.com',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionHeader(String title) {
    return Container(
      color: const Color(0xFFF6F6F6),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      width: double.infinity,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget profileTile(BuildContext context, String title, Widget page, {IconData? icon}) {
    return ListTile(
      dense: true,
      leading: icon != null ? Icon(icon) : null,
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _navigateTo(context, page),
    );
  }
}

// Dummy page classes for navigation (replace with your actual pages)
class InvestmentsPage extends StatelessWidget { const InvestmentsPage({Key? key}) : super(key: key); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Investments')), body: const Center(child: Text('Investments Page')));}
class TransactionsPage extends StatelessWidget { const TransactionsPage({Key? key}) : super(key: key); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Transactions')), body: const Center(child: Text('Transactions Page')));}
class AddBalancePage extends StatelessWidget { const AddBalancePage({Key? key}) : super(key: key); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Add Balance')), body: const Center(child: Text('Add Balance Page')));}
class ContactUsPage extends StatelessWidget { const ContactUsPage({Key? key}) : super(key: key); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Contact US')), body: const Center(child: Text('Contact US Page')));}
class FAQsPage extends StatelessWidget { const FAQsPage({Key? key}) : super(key: key); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('FAQs')), body: const Center(child: Text('FAQs Page')));}
class TermsPage extends StatelessWidget { const TermsPage({Key? key}) : super(key: key); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Terms & Conditions')), body: const Center(child: Text('Terms & Conditions Page')));}
class LanguagePage extends StatelessWidget { const LanguagePage({Key? key}) : super(key: key); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Language')), body: const Center(child: Text('Language Page')));}
class PrivacyPolicyPage extends StatelessWidget { const PrivacyPolicyPage({Key? key}) : super(key: key); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Privacy Policy')), body: const Center(child: Text('Privacy Policy Page')));}
class ReferralPage extends StatelessWidget { const ReferralPage({Key? key}) : super(key: key); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Referral')), body: const Center(child: Text('Referral Page')));}
