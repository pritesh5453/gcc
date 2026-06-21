import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/edit_profile/edit_profile_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';
import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/Screens/comman_appbar/comman_appbar.dart'; // adjust path

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  // Profile data fields
  String _name = '';
  String _phone = '';
  String _dateOfBirth = '';
  String _gender = '';
  String _address = '';
  String _city = '';
  String _state = '';
  String _postalCode = '';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final token = AppPreference().getString(PreferencesKey.authToken);
      if (token.isEmpty)
        throw Exception('Not authenticated. Please login again.');

      final response = await DioClient.dio.get(
        ApiEndpoints.kycDetails,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        setState(() {
          _name = data['name'] ?? '';
          _phone = data['phone'] ?? '';
          _dateOfBirth = data['date_of_birth'] ?? '';
          _gender = data['gender'] ?? '';
          _address = data['address'] ?? '';
          _city = data['city'] ?? '';
          _state = data['state'] ?? '';
          _postalCode = data['postal_code'] ?? '';
          _isLoading = false;
        });
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load profile');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile(Map<String, String> updatedData) async {
    final token = AppPreference().getString(PreferencesKey.authToken);
    if (token.isEmpty) throw Exception('Not authenticated');

    final request = ProfileUpdateRequest(
      name: updatedData['name']!,
      phone: updatedData['phone']!,
      dateOfBirth: updatedData['date_of_birth']!,
      gender: updatedData['gender']!,
      address: updatedData['address']!,
      city: updatedData['city']!,
      state: updatedData['state']!,
      postalCode: updatedData['postal_code']!,
    );

    final response = await DioClient.dio.post(
      ApiEndpoints.updateProfile,
      data: request.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      setState(() {
        _name = updatedData['name']!;
        _phone = updatedData['phone']!;
        _dateOfBirth = updatedData['date_of_birth']!;
        _gender = updatedData['gender']!;
        _address = updatedData['address']!;
        _city = updatedData['city']!;
        _state = updatedData['state']!;
        _postalCode = updatedData['postal_code']!;
      });
    } else {
      throw Exception(response.data['message'] ?? 'Update failed');
    }
  }

  Future<void> _showPersonalInfoDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (ctx) => Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: Container(
              width: MediaQuery.of(ctx).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.green[700],
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Read-only fields
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildReadOnlyField('Full Name', _name, Icons.person),
                          const SizedBox(height: 16),
                          _buildReadOnlyField(
                            'Phone Number',
                            _phone,
                            Icons.phone,
                          ),
                          const SizedBox(height: 16),
                          _buildReadOnlyField(
                            'Date of Birth',
                            _dateOfBirth,
                            Icons.cake,
                          ),
                          const SizedBox(height: 16),
                          _buildReadOnlyField('Gender', _gender, Icons.people),
                          const SizedBox(height: 16),
                          _buildReadOnlyField('Address', _address, Icons.home),
                          const SizedBox(height: 16),
                          _buildReadOnlyField(
                            'City',
                            _city,
                            Icons.location_city,
                          ),
                          const SizedBox(height: 16),
                          _buildReadOnlyField('State', _state, Icons.map),
                          const SizedBox(height: 16),
                          _buildReadOnlyField(
                            'Postal Code',
                            _postalCode,
                            Icons.pin_drop,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.green[50],
                      ),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.green[600], size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value.isEmpty ? 'Not provided' : value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogField(
    String label,
    IconData icon,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.green[600], size: 22),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.green[700]!, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.red),
            ),
            content: const Text(
              'This action is permanent. All your data, points, and rewards will be lost forever. Are you sure?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account deletion requested (demo)'),
                    ),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete Forever'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      body: SafeArea(
        child: Column(
          children: [
            const CommonAppBar(title: 'Account & Security', showHelp: false),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text('Error: $_error', textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchProfileData,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                      : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  _buildMenuTile(
                                    icon: Icons.person_outline,
                                    title: 'Personal Information',
                                    subtitle: 'View and edit your profile',
                                    onTap: _showPersonalInfoDialog,
                                  ),
                                  const Divider(height: 1, thickness: 1),
                                  _buildMenuTile(
                                    icon: Icons.delete_outline,
                                    title: 'Delete Account',
                                    subtitle: 'Permanently remove your account',
                                    isDestructive: true,
                                    onTap:
                                        () => _showDeleteConfirmationDialog(
                                          context,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
            ),
          ],
        ),
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
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : Colors.green[700],
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: isDestructive ? Colors.red : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }
}
