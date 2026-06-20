import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B5E20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildFaqSection(),
            const SizedBox(height: 20),
            _buildContactSection(context),
            const SizedBox(height: 20),
            _buildReportIssueCard(context),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for help...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onSubmitted: (value) {
          // Search logic can be added here
        },
      ),
    );
  }

  Widget _buildFaqSection() {
    final List<FaqItem> faqs = [
      FaqItem(
        question: 'How do I earn EcoPoints?',
        answer:
            'You can earn EcoPoints by recycling waste, participating in green challenges, referring friends, and completing eco-friendly tasks.',
      ),
      FaqItem(
        question: 'How to redeem rewards?',
        answer:
            'Go to Rewards section, select a reward you like, and click "Redeem". Points will be deducted and reward will be processed within 3-5 business days.',
      ),
      FaqItem(
        question: 'What is GreenChain?',
        answer:
            'GreenChain is a blockchain-based platform that rewards users for sustainable actions like recycling, planting trees, and reducing carbon footprint.',
      ),
      FaqItem(
        question: 'Is my data secure?',
        answer:
            'Yes, we use industry-standard encryption and never share your personal data without consent.',
      ),
      FaqItem(
        question: 'How to delete my account?',
        answer:
            'Go to Account & Security → Danger Zone → Delete Account. This action is permanent.',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Frequently Asked Questions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          ...faqs.map((faq) => _buildFaqTile(faq)),
        ],
      ),
    );
  }

  Widget _buildFaqTile(FaqItem faq) {
    return ExpansionTile(
      leading: const Icon(
        Icons.help_outline,
        color: Color(0xFF2E7D32),
        size: 20,
      ),
      title: Text(
        faq.question,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            faq.answer,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Contact Us',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          _buildContactTile(
            icon: Icons.email_outlined,
            title: 'Email Support',
            subtitle: 'support@greenchain.com',
            onTap: () => _launchEmail('support@greenchain.com'),
          ),
          _buildContactTile(
            icon: Icons.phone_outlined,
            title: 'Call Us',
            subtitle: '+91 1800 123 4567 (Toll Free)',
            onTap: () => _launchPhone('+9118001234567'),
          ),
          _buildContactTile(
            icon: Icons.chat_outlined,
            title: 'Live Chat',
            subtitle: 'Mon-Fri, 10 AM - 6 PM',
            onTap: () {
              // Show live chat dialog or navigate
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Live chat feature coming soon!')),
              );
            },
          ),
          _buildContactTile(
            icon: Icons.message,
            title: 'WhatsApp',
            subtitle: '+91 98765 01234',
            onTap: () => _launchWhatsApp('+919876501234'),
            iconColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: (iconColor ?? const Color(0xFF2E7D32)).withOpacity(
          0.1,
        ),
        child: Icon(
          icon,
          color: iconColor ?? const Color(0xFF2E7D32),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildReportIssueCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.red[50],
            child: const Icon(Icons.bug_report, color: Colors.red, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Report an Issue',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Found a bug or problem? Let us know',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showReportIssueDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Report',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportIssueDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Report an Issue'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Issue Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Issue reported! We\'ll get back to you.'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
    );
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      debugPrint('Could not launch email');
    }
  }

  void _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _launchWhatsApp(String number) async {
    final Uri whatsappUri = Uri(scheme: 'https', path: 'wa.me/$number');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    }
  }
}

class FaqItem {
  final String question;
  final String answer;
  FaqItem({required this.question, required this.answer});
}
