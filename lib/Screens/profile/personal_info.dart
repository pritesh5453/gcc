import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/edit_profile/edit_profile_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';
import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:gcc/prefs/app_preference.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  // Profile data fields from API
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
          // Name might not be in this response; keep empty or try to get from other source
          // For now we let the user provide it via the edit dialog.
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
      // Update local state with new values
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
    final TextEditingController nameCtrl = TextEditingController(text: _name);
    final TextEditingController phoneCtrl = TextEditingController(text: _phone);
    final TextEditingController dobCtrl = TextEditingController(
      text: _dateOfBirth,
    );
    final TextEditingController genderCtrl = TextEditingController(
      text: _gender,
    );
    final TextEditingController addressCtrl = TextEditingController(
      text: _address,
    );
    final TextEditingController cityCtrl = TextEditingController(text: _city);
    final TextEditingController stateCtrl = TextEditingController(text: _state);
    final TextEditingController postalCtrl = TextEditingController(
      text: _postalCode,
    );

    bool isSaving = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => StatefulBuilder(
            builder: (ctx, setDialogState) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.green[700]),
                    const SizedBox(width: 10),
                    const Text(
                      'Personal Information',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDialogField('Full Name', Icons.person, nameCtrl),
                      const SizedBox(height: 12),
                      _buildDialogField(
                        'Phone Number',
                        Icons.phone,
                        phoneCtrl,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      _buildDialogField(
                        'Date of Birth (YYYY-MM-DD)',
                        Icons.cake,
                        dobCtrl,
                        keyboardType: TextInputType.datetime,
                      ),
                      const SizedBox(height: 12),
                      _buildDialogField('Gender', Icons.people, genderCtrl),
                      const SizedBox(height: 12),
                      _buildDialogField('Address', Icons.home, addressCtrl),
                      const SizedBox(height: 12),
                      _buildDialogField('City', Icons.location_city, cityCtrl),
                      const SizedBox(height: 12),
                      _buildDialogField('State', Icons.map, stateCtrl),
                      const SizedBox(height: 12),
                      _buildDialogField(
                        'Postal Code',
                        Icons.pin_drop,
                        postalCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: isSaving ? null : () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed:
                        isSaving
                            ? null
                            : () async {
                              final updated = {
                                'name': nameCtrl.text.trim(),
                                'phone': phoneCtrl.text.trim(),
                                'date_of_birth': dobCtrl.text.trim(),
                                'gender': genderCtrl.text.trim(),
                                'address': addressCtrl.text.trim(),
                                'city': cityCtrl.text.trim(),
                                'state': stateCtrl.text.trim(),
                                'postal_code': postalCtrl.text.trim(),
                              };
                              setDialogState(() => isSaving = true);
                              try {
                                await _updateProfile(updated);
                                if (mounted) {
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Profile updated successfully!',
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                setDialogState(() => isSaving = false);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                }
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                    ),
                    child:
                        isSaving
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Text('Save Changes'),
                  ),
                ],
              );
            },
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
        prefixIcon: Icon(icon, color: Colors.green[600], size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
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
      body:
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
                            onTap: () => _showDeleteConfirmationDialog(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
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
