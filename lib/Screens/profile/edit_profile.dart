import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gcc/Models_nServices/profile/profile_model.dart';
import 'package:gcc/Models_nServices/profile/profile_svc.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';
import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/Screens/comman_appbar/comman_appbar.dart'; // adjust path if needed

// -------------------------------------------------------------------------
// 👇 These classes are already in your file – keep them as they are
class KycUpdateRequest {
  final String name;
  final String phone;
  final String dateOfBirth;
  final String gender;
  final String address;
  final String city;
  final String state;
  final String postalCode;

  KycUpdateRequest({
    required this.name,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'date_of_birth': dateOfBirth,
    'gender': gender,
    'address': address,
    'city': city,
    'state': state,
    'postal_code': postalCode,
  };
}

class KycUpdateResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  KycUpdateResponse({required this.success, required this.message, this.data});

  factory KycUpdateResponse.fromJson(Map<String, dynamic> json) {
    return KycUpdateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}
// -------------------------------------------------------------------------

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final AppPreference _appPreference = AppPreference();

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postalCodeController;

  String _selectedGender = 'male';
  final List<String> _genderOptions = ['male', 'female', 'other'];

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
      final token = _appPreference.getString(PreferencesKey.authToken);
      if (token.isEmpty)
        throw Exception('Not authenticated. Please login again.');

      final response = await DioClient.dio.get(
        ApiEndpoints.kycDetails,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        final String name = data['name'] ?? '';
        final String email = data['email'] ?? '';
        final String phone = data['phone'] ?? '';
        final String dob = data['date_of_birth'] ?? '';
        final String gender = data['gender'] ?? 'male';
        final String address = data['address'] ?? '';
        final String city = data['city'] ?? '';
        final String state = data['state'] ?? '';
        final String postalCode = data['postal_code'] ?? '';

        _fullNameController = TextEditingController(text: name);
        _emailController = TextEditingController(text: email);
        _phoneController = TextEditingController(text: phone);
        _dobController = TextEditingController(text: dob);
        _addressController = TextEditingController(text: address);
        _cityController = TextEditingController(text: city);
        _stateController = TextEditingController(text: state);
        _postalCodeController = TextEditingController(text: postalCode);

        setState(() {
          _selectedGender = _genderOptions.contains(gender) ? gender : 'male';
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

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        final token = _appPreference.getString(PreferencesKey.authToken);
        if (token.isEmpty) throw Exception('Token missing');

        final request = KycUpdateRequest(
          name: _fullNameController.text.trim(),
          phone: _phoneController.text.trim(),
          dateOfBirth: _dobController.text.trim(),
          gender: _selectedGender,
          address: _addressController.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim(),
          postalCode: _postalCodeController.text.trim(),
        );

        final response = await DioClient.dio.post(
          ApiEndpoints.updateProfile,
          data: request.toJson(),
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        final apiResponse = KycUpdateResponse.fromJson(response.data);

        if (apiResponse.success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully! 🌿'),
                backgroundColor: Color(0xFF2E7D32),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          }
        } else {
          throw Exception(apiResponse.message);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Update failed: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F0),
      body: SafeArea(
        child: Column(
          children: [
            // ✅ CommonAppBar – no trailing, just title + back
            const CommonAppBar(title: 'Edit Profile', showHelp: false),
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
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar section
                              Center(
                                child: Stack(
                                  children: [
                                    const CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Color(0xFFC8E6C9),
                                      child: Icon(
                                        Icons.person,
                                        size: 55,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF2E7D32),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),

                              // All your existing fields
                              _buildTextField(
                                controller: _fullNameController,
                                label: 'Full Name',
                                icon: Icons.person_outline,
                                validator:
                                    (v) =>
                                        v!.trim().isEmpty
                                            ? 'Name required'
                                            : null,
                              ),
                              const SizedBox(height: 20),

                              _buildTextField(
                                controller: _emailController,
                                label: 'Email Address',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v!.trim().isEmpty)
                                    return 'Email required';
                                  if (!v.contains('@'))
                                    return 'Enter valid email';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              _buildTextField(
                                controller: _phoneController,
                                label: 'Phone Number',
                                icon: Icons.phone_android_outlined,
                                keyboardType: TextInputType.phone,
                                validator:
                                    (v) =>
                                        v!.trim().isEmpty
                                            ? 'Phone required'
                                            : null,
                              ),
                              const SizedBox(height: 20),

                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: AbsorbPointer(
                                  child: _buildTextField(
                                    controller: _dobController,
                                    label: 'Date of Birth',
                                    icon: Icons.cake_outlined,
                                    validator:
                                        (v) =>
                                            v!.trim().isEmpty
                                                ? 'DOB required'
                                                : null,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              DropdownButtonFormField<String>(
                                value: _selectedGender,
                                decoration: InputDecoration(
                                  labelText: 'Gender',
                                  prefixIcon: const Icon(
                                    Icons.person_outline,
                                    color: Color(0xFF558B2F),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 16,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF66BB6A),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                items:
                                    _genderOptions.map((gender) {
                                      return DropdownMenuItem<String>(
                                        value: gender,
                                        child: Text(gender.toUpperCase()),
                                      );
                                    }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedGender = newValue!;
                                  });
                                },
                                validator:
                                    (value) =>
                                        value == null
                                            ? 'Gender required'
                                            : null,
                              ),
                              const SizedBox(height: 20),

                              _buildTextField(
                                controller: _addressController,
                                label: 'Address',
                                icon: Icons.home_outlined,
                                validator:
                                    (v) =>
                                        v!.trim().isEmpty
                                            ? 'Address required'
                                            : null,
                              ),
                              const SizedBox(height: 20),

                              _buildTextField(
                                controller: _cityController,
                                label: 'City',
                                icon: Icons.location_city_outlined,
                                validator:
                                    (v) =>
                                        v!.trim().isEmpty
                                            ? 'City required'
                                            : null,
                              ),
                              const SizedBox(height: 20),

                              _buildTextField(
                                controller: _stateController,
                                label: 'State',
                                icon: Icons.map_outlined,
                                validator:
                                    (v) =>
                                        v!.trim().isEmpty
                                            ? 'State required'
                                            : null,
                              ),
                              const SizedBox(height: 20),

                              _buildTextField(
                                controller: _postalCodeController,
                                label: 'Postal Code',
                                icon: Icons.mail_outline,
                                keyboardType: TextInputType.number,
                                validator:
                                    (v) =>
                                        v!.trim().isEmpty
                                            ? 'Postal code required'
                                            : null,
                              ),
                              const SizedBox(height: 32),

                              // ✅ SAVE BUTTON – full width, green, at the bottom
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _saveChanges,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2E7D32),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF558B2F)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF66BB6A), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }
}
