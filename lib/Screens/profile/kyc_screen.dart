import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gcc/Models_nServices/kyc/kyc_svc.dart';
import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/Screens/comman_appbar/comman_appbar.dart'; // adjust path

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  // Controllers for user‑fillable fields
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();

  // Selected image files
  File? _aadharFrontImage;
  File? _aadharBackImage;
  File? _panImage;

  // Personal details fetched from API
  String? _phone;
  String? _dob;
  String? _gender;
  String? _address;
  String? _city;
  String? _state;
  String? _postalCode;

  // KYC status fields
  String? _kycRequestStatus;
  int? _kycCompleted;
  String? _aadhaarVerified;
  String? _panVerified;
  String? _bankVerified;
  bool _isKycDetailsSubmitted = false;

  // Loading states
  bool _isLoadingDetails = true;
  String? _detailsError;
  bool _isSubmitting = false;

  final ImagePicker _picker = ImagePicker();
  final KycService _kycService = KycService();
  final AppPreference _appPref = AppPreference();

  @override
  void initState() {
    super.initState();
    _fetchKycDetails();
  }

  Future<String?> _getToken() async {
    return _appPref.getString(PreferencesKey.authToken);
  }

  Future<void> _fetchKycDetails() async {
    setState(() {
      _isLoadingDetails = true;
      _detailsError = null;
    });

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) throw Exception('Not authenticated');

      final response = await _kycService.fetchKycDetails(token);
      final data = response.data;

      setState(() {
        String? rawDob = data.dateOfBirth;
        if (rawDob != null && rawDob.isNotEmpty) {
          _dob = rawDob.split('T')[0];
        } else {
          _dob = null;
        }
        _phone = data.phone;
        _gender = data.gender;
        _address = data.address;
        _city = data.city;
        _state = data.state;
        _postalCode = data.postalCode;

        _kycRequestStatus = data.kycRequestStatus;
        _kycCompleted = data.kycCompleted;
        _aadhaarVerified = data.aadhaarVerified;
        _panVerified = data.panVerified;
        _bankVerified = data.bankVerified;
        _isKycDetailsSubmitted = data.isKycDetailsSubmitted == 1;

        _aadharController.text = data.aadhaarNumber ?? '';
        _panController.text = data.panNumber ?? '';
        _bankNameController.text = data.bankName ?? '';
        _accountHolderController.text = data.accountHolderName ?? '';
        _accountNumberController.text = data.accountNumber ?? '';
        _ifscController.text = data.ifscCode ?? '';
        _branchController.text = data.bankBranch ?? '';

        _isLoadingDetails = false;
      });
    } catch (e) {
      setState(() {
        _detailsError = e.toString();
        _isLoadingDetails = false;
      });
    }
  }

  // ---------- Image picking (unchanged) ----------
  Future<void> _pickImage(
    ImageSource source,
    Function(File?) onImagePicked,
  ) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        int fileSize = await imageFile.length();
        double sizeInMB = fileSize / (1024 * 1024);
        if (sizeInMB > 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Image size must be less than 3 MB"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        onImagePicked(imageFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  void _showImageSourceDialog(Function(File?) onImagePicked) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery, onImagePicked);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera, onImagePicked);
                  },
                ),
              ],
            ),
          ),
    );
  }

  // ---------- Full KYC submission ----------
  Future<void> _submitFullKyc() async {
    final aadharNumber = _aadharController.text.trim();
    final panNumber = _panController.text.trim().toUpperCase();
    final bankName = _bankNameController.text.trim();
    final accountHolder = _accountHolderController.text.trim();
    final accountNumber = _accountNumberController.text.trim();
    final ifsc = _ifscController.text.trim().toUpperCase();
    final branch = _branchController.text.trim();

    if (aadharNumber.length != 12) {
      _showError("Enter a valid 12-digit Aadhar number");
      return;
    }
    if (panNumber.length != 10) {
      _showError("Enter a valid 10-character PAN");
      return;
    }
    if (_aadharFrontImage == null ||
        _aadharBackImage == null ||
        _panImage == null) {
      _showError("Please upload all required images");
      return;
    }
    if (bankName.isEmpty ||
        accountHolder.isEmpty ||
        accountNumber.isEmpty ||
        ifsc.isEmpty ||
        branch.isEmpty) {
      _showError("Please fill all bank details");
      return;
    }
    if (_phone == null ||
        _dob == null ||
        _gender == null ||
        _address == null ||
        _city == null ||
        _state == null ||
        _postalCode == null) {
      _showError(
        "Your profile is incomplete. Please complete your profile before KYC submission.",
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) throw Exception('Not authenticated');

      final fields = {
        'phone': _phone!,
        'date_of_birth': _dob!,
        'gender': _gender!,
        'address': _address!,
        'city': _city!,
        'state': _state!,
        'postal_code': _postalCode!,
        'aadhaar_number': aadharNumber,
        'pan_number': panNumber,
        'bank_name': bankName,
        'account_holder_name': accountHolder,
        'account_number': accountNumber,
        'ifsc_code': ifsc,
        'bank_branch': branch,
      };

      final files = {
        'aadhaar_front_image': await MultipartFile.fromFile(
          _aadharFrontImage!.path,
        ),
        'aadhaar_back_image': await MultipartFile.fromFile(
          _aadharBackImage!.path,
        ),
        'pan_card_image': await MultipartFile.fromFile(_panImage!.path),
      };

      final response = await _kycService.submitFullKyc(
        token: token,
        fields: fields,
        files: files,
      );

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('KYC submitted successfully!')),
        );
        await _fetchKycDetails();
        if (mounted) Navigator.pop(context);
      } else {
        _showError(response.message);
      }
    } catch (e) {
      _showError('Submission failed: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  // ---------- Section‑wise submission ----------
  Future<void> _submitAadhaar() async {
    final aadharNumber = _aadharController.text.trim();
    if (aadharNumber.length != 12) {
      _showError("Enter a valid 12-digit Aadhar number");
      return;
    }
    if (_aadharFrontImage == null || _aadharBackImage == null) {
      _showError("Please upload both Aadhar front and back images");
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) throw Exception('Not authenticated');

      final frontImage = await MultipartFile.fromFile(_aadharFrontImage!.path);
      final backImage = await MultipartFile.fromFile(_aadharBackImage!.path);

      final response = await _kycService.submitAadhaar(
        token: token,
        aadhaarNumber: aadharNumber,
        frontImage: frontImage,
        backImage: backImage,
      );

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aadhaar details submitted successfully!'),
          ),
        );
        await _fetchKycDetails();
      } else {
        _showError(response.message);
      }
    } catch (e) {
      _showError('Aadhaar submission failed: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _submitPan() async {
    final panNumber = _panController.text.trim().toUpperCase();
    if (panNumber.length != 10) {
      _showError("Enter a valid 10-character PAN");
      return;
    }
    if (_panImage == null) {
      _showError("Please upload PAN card image");
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) throw Exception('Not authenticated');

      final panImage = await MultipartFile.fromFile(_panImage!.path);
      final response = await _kycService.submitPan(
        token: token,
        panNumber: panNumber,
        panImage: panImage,
      );

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PAN details submitted successfully!')),
        );
        await _fetchKycDetails();
      } else {
        _showError(response.message);
      }
    } catch (e) {
      _showError('PAN submission failed: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _submitBank() async {
    final bankName = _bankNameController.text.trim();
    final accountHolder = _accountHolderController.text.trim();
    final accountNumber = _accountNumberController.text.trim();
    final ifsc = _ifscController.text.trim().toUpperCase();
    final branch = _branchController.text.trim();

    if (bankName.isEmpty ||
        accountHolder.isEmpty ||
        accountNumber.isEmpty ||
        ifsc.isEmpty ||
        branch.isEmpty) {
      _showError("Please fill all bank details");
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) throw Exception('Not authenticated');

      final bankData = {
        'bank_name': bankName,
        'account_holder_name': accountHolder,
        'account_number': accountNumber,
        'ifsc_code': ifsc,
        'bank_branch': branch,
      };
      final response = await _kycService.submitBank(
        token: token,
        bankData: bankData,
      );

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bank details submitted successfully!')),
        );
        await _fetchKycDetails();
      } else {
        _showError(response.message);
      }
    } catch (e) {
      _showError('Bank submission failed: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ---------- UI Builders ----------
  @override
  Widget build(BuildContext context) {
    if (_isLoadingDetails) {
      return _buildLoading();
    }
    if (_detailsError != null) {
      return _buildError();
    }

    if (!_isKycDetailsSubmitted) {
      return _buildFullForm();
    }

    final aadhaar = _aadhaarVerified;
    final pan = _panVerified;
    final bank = _bankVerified;

    final allVerified =
        aadhaar == 'verified' && pan == 'verified' && bank == 'verified';
    final anyRejected =
        aadhaar == 'rejected' || pan == 'rejected' || bank == 'rejected';
    final anyPending =
        aadhaar == 'pending' || pan == 'pending' || bank == 'pending';

    if (allVerified) {
      return _buildStatusScreen(
        'KYC Completed',
        Icons.check_circle,
        Colors.green,
      );
    } else if (anyRejected) {
      return _buildRejectedScreen();
    } else if (anyPending) {
      return _buildStatusScreen(
        'KYC Approval Pending',
        Icons.hourglass_empty,
        Colors.orange,
      );
    } else {
      return _buildStatusScreen(
        'KYC Under Review',
        Icons.hourglass_empty,
        Colors.orange,
      );
    }
  }

  // Scaffold builder with CommonAppBar
  Widget _buildScaffoldWithAppBar(Widget body) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF2F7),
      body: SafeArea(
        child: Column(
          children: [
            const CommonAppBar(title: 'KYC Verification', showHelp: false),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return _buildScaffoldWithAppBar(
      const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError() {
    return _buildScaffoldWithAppBar(
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_detailsError!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchKycDetails,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusScreen(String message, IconData icon, Color color) {
    return _buildScaffoldWithAppBar(
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: color),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRejectedScreen() {
    final showAadhaar = _aadhaarVerified == 'rejected';
    final showPan = _panVerified == 'rejected';
    final showBank = _bankVerified == 'rejected';

    return _buildScaffoldWithAppBar(
      SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showAadhaar) ...[
                _buildAadhaarSection(),
                const SizedBox(height: 24),
              ],
              if (showPan) ...[_buildPanSection(), const SizedBox(height: 24)],
              if (showBank) ...[
                _buildBankSection(),
                const SizedBox(height: 24),
              ],
              if (!showAadhaar && !showPan && !showBank)
                const Center(
                  child: Text(
                    'No rejected sections found.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullForm() {
    bool arePersonalDetailsMissing =
        _phone == null ||
        _dob == null ||
        _gender == null ||
        _address == null ||
        _city == null ||
        _state == null ||
        _postalCode == null;

    return _buildScaffoldWithAppBar(
      SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (arePersonalDetailsMissing) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.orange),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your profile is incomplete. Please update your profile before KYC submission.',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              const Text(
                "Aadhar Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                "Aadhar Number",
                "12-digit Aadhar number",
                _aadharController,
                keyboardType: TextInputType.number,
                maxLength: 12,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildUploadBox(
                      label: "Aadhar Front",
                      icon: Icons.credit_card,
                      image: _aadharFrontImage,
                      onTap:
                          () => _showImageSourceDialog(
                            (file) => setState(() => _aadharFrontImage = file),
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildUploadBox(
                      label: "Aadhar Back",
                      icon: Icons.credit_card,
                      image: _aadharBackImage,
                      onTap:
                          () => _showImageSourceDialog(
                            (file) => setState(() => _aadharBackImage = file),
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(thickness: 1),
              const SizedBox(height: 16),
              const Text(
                "PAN Card Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                "PAN Number",
                "10-character PAN",
                _panController,
                textCapitalization: TextCapitalization.characters,
                maxLength: 10,
              ),
              const SizedBox(height: 16),
              _buildUploadBox(
                label: "Upload PAN Card",
                icon: Icons.image,
                fullWidth: true,
                image: _panImage,
                onTap:
                    () => _showImageSourceDialog(
                      (file) => setState(() => _panImage = file),
                    ),
              ),
              const SizedBox(height: 24),
              const Divider(thickness: 1),
              const SizedBox(height: 16),
              const Text(
                "Bank Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                "Bank Name",
                "e.g., State Bank of India",
                _bankNameController,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                "Account Holder Name",
                "As per bank records",
                _accountHolderController,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                "Account Number",
                "Enter account number",
                _accountNumberController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                "IFSC Code",
                "e.g., SBIN0001234",
                _ifscController,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                "Bank Branch",
                "e.g., Connaught Place",
                _branchController,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      arePersonalDetailsMissing
                          ? null
                          : (_isSubmitting ? null : _submitFullKyc),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F6BFF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child:
                      _isSubmitting
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            "Submit KYC",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- All helper widgets (unchanged) ----------
  Widget _buildAadhaarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Aadhar Details (Rejected)",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          "Aadhar Number",
          "12-digit Aadhar number",
          _aadharController,
          keyboardType: TextInputType.number,
          maxLength: 12,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildUploadBox(
                label: "Aadhar Front",
                icon: Icons.credit_card,
                image: _aadharFrontImage,
                onTap:
                    () => _showImageSourceDialog(
                      (file) => setState(() => _aadharFrontImage = file),
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildUploadBox(
                label: "Aadhar Back",
                icon: Icons.credit_card,
                image: _aadharBackImage,
                onTap:
                    () => _showImageSourceDialog(
                      (file) => setState(() => _aadharBackImage = file),
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitAadhaar,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child:
                _isSubmitting
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      "Submit Aadhaar",
                      style: TextStyle(color: Colors.white),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildPanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "PAN Details (Rejected)",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          "PAN Number",
          "10-character PAN",
          _panController,
          textCapitalization: TextCapitalization.characters,
          maxLength: 10,
        ),
        const SizedBox(height: 16),
        _buildUploadBox(
          label: "Upload PAN Card",
          icon: Icons.image,
          fullWidth: true,
          image: _panImage,
          onTap:
              () => _showImageSourceDialog(
                (file) => setState(() => _panImage = file),
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitPan,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child:
                _isSubmitting
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      "Submit PAN",
                      style: TextStyle(color: Colors.white),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildBankSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Bank Details (Rejected)",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          "Bank Name",
          "e.g., State Bank of India",
          _bankNameController,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          "Account Holder Name",
          "As per bank records",
          _accountHolderController,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          "Account Number",
          "Enter account number",
          _accountNumberController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          "IFSC Code",
          "e.g., SBIN0001234",
          _ifscController,
          textCapitalization: TextCapitalization.characters,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          "Bank Branch",
          "e.g., Connaught Place",
          _branchController,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitBank,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child:
                _isSubmitting
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      "Submit Bank Details",
                      style: TextStyle(color: Colors.white),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            counterText: maxLength != null ? "" : null,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadBox({
    required String label,
    required IconData icon,
    bool fullWidth = false,
    File? image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        height: 120,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child:
            image == null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 32,
                      color: const Color.fromARGB(255, 60, 223, 10),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Tap to upload",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                )
                : Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(image, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: onTap,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  @override
  void dispose() {
    _aadharController.dispose();
    _panController.dispose();
    _bankNameController.dispose();
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    _branchController.dispose();
    super.dispose();
  }
}
