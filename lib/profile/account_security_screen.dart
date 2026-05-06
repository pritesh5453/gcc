import 'package:flutter/material.dart';
class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool _twoFactorEnabled = false;
  bool _loginAlertsEnabled = true;

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
          'Account & Security',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSecuritySection(),
            const SizedBox(height: 20),
            _buildAccountSection(),
            const SizedBox(height: 20),
            _buildDangerZone(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySection() {
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
              'Security',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          _buildMenuTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Last changed 3 months ago',
            onTap: () => _showChangePasswordDialog(context),
          ),
          _buildSwitchTile(
            icon: Icons.smartphone,
            title: 'Two-Factor Authentication',
            subtitle: 'Add an extra layer of security',
            value: _twoFactorEnabled,
            onChanged: (val) => setState(() => _twoFactorEnabled = val),
          ),
          _buildSwitchTile(
            icon: Icons.email_outlined,
            title: 'Login Alerts',
            subtitle: 'Get email when new device logs in',
            value: _loginAlertsEnabled,
            onChanged: (val) => setState(() => _loginAlertsEnabled = val),
          ),
          _buildMenuTile(
            icon: Icons.devices,
            title: 'Manage Devices',
            subtitle: '2 active sessions · Windows, Android',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
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
              'Account Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          _buildMenuTile(
            icon: Icons.person_outline,
            title: 'Personal Information',
            subtitle: 'Name, email, phone number',
            onTap: () {
              // Navigate to Edit Profile screen (if available)
              // Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to Edit Profile')),
              );
            },
          ),
          _buildMenuTile(
            icon: Icons.notifications_active_outlined,
            title: 'Notification Preferences',
            subtitle: 'Email & push alerts',
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Icons.download_outlined,
            title: 'Download My Data',
            subtitle: 'Request a copy of your data',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZone() {
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
              'Danger Zone',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          _buildMenuTile(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            subtitle: 'Permanently remove your account and data',
            isDestructive: true,
            onTap: () => _showDeleteConfirmationDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isDestructive ? Colors.red[50] : Colors.green[50],
        child: Icon(icon, color: isDestructive ? Colors.red : Colors.green[700], size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: isDestructive ? Colors.red : Colors.black87,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green[50],
        child: Icon(icon, color: Colors.green[700], size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green[700],
      ),
      onTap: () => onChanged(!value),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldPwdCtrl = TextEditingController();
    final newPwdCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPwdCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPwdCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              // Validation logic here
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
        content: const Text(
          'This action is permanent. All your data, points, and rewards will be lost forever. Are you sure?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion requested (demo)')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Forever'),
          ),
        ],
      ),
    );
  }
}