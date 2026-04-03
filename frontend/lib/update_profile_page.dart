import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'user_provider.dart';
import 'location_provider.dart';
import 'permission_service.dart';
import 'package:geocoding/geocoding.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  
  String _gender = 'Male';
  String _bloodGroup = 'O+';
  String _avatarUrl = '';

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(text: userProvider.name);
    _dobController = TextEditingController(text: userProvider.dob);
    _emailController = TextEditingController(text: userProvider.email);
    _phoneController = TextEditingController(text: userProvider.phone);
    _addressController = TextEditingController(text: userProvider.address);
    _heightController = TextEditingController(text: userProvider.height);
    _weightController = TextEditingController(text: userProvider.weight);
    _bloodGroup = userProvider.bloodGroup;
    _avatarUrl = userProvider.avatarUrl;

    // Listen to name changes to update the header in real-time
    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF344054), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Update Profile',
          style: TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            
            // Profile Header
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFD1E9FF), width: 8),
                      image: DecorationImage(
                        image: NetworkImage(_avatarUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      onTap: () async {
                        final permissionGranted = await PermissionService().requestFilePermission(context);
                        if (!permissionGranted) return;
                        
                        final picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            _avatarUrl = image.path;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E90FA),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
                          ],
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _nameController.text,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D2939)),
            ),
            Text(
              'PATIENT ID: ${Provider.of<UserProvider>(context, listen: false).clinicalId}',
              style: const TextStyle(fontSize: 14, color: Color(0xFF667085), fontWeight: FontWeight.w500),
            ),
            
            const SizedBox(height: 32),

            // Basic Details
            _buildSectionHeader(Icons.person, 'BASIC DETAILS'),
            _buildSectionCard([
              _buildTextField('Full Name', _nameController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Date of Birth', _dobController, icon: Icons.calendar_today_outlined)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDropdownField('Gender', _gender, ['Male', 'Female', 'Other'], (val) => setState(() => _gender = val!))),
                ],
              ),
            ]),

            const SizedBox(height: 24),

            // Contact Info
            _buildSectionHeader(Icons.contact_mail, 'CONTACT INFO'),
            _buildSectionCard([
              _buildTextField('Email Address', _emailController, icon: Icons.email_outlined),
              const SizedBox(height: 16),
              _buildTextField('Phone Number', _phoneController, icon: Icons.phone_outlined),
              const SizedBox(height: 16),
              _buildTextField(
                'Primary Address', 
                _addressController, 
                icon: Icons.location_on_outlined, 
                maxLines: 2,
                suffix: TextButton.icon(
                  onPressed: () async {
                    final lp = Provider.of<LocationProvider>(context, listen: false);
                    final permissionGranted = await PermissionService().requestLocationPermission(context);
                    if (!permissionGranted) return;

                    setState(() {
                      _addressController.text = "Detecting location...";
                    });
                    
                    await lp.updatePositionOnce();
                    
                    if (lp.currentPosition != null) {
                      try {
                        List<Placemark> placemarks = await placemarkFromCoordinates(
                          lp.currentPosition!.latitude, 
                          lp.currentPosition!.longitude
                        );
                        
                        if (placemarks.isNotEmpty) {
                          Placemark place = placemarks[0];
                          String formattedAddress = "${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}";
                          setState(() {
                            _addressController.text = formattedAddress;
                          });
                        } else {
                          setState(() {
                            _addressController.text = "${lp.currentPosition!.latitude.toStringAsFixed(4)}, ${lp.currentPosition!.longitude.toStringAsFixed(4)} (GPS)";
                          });
                        }
                      } catch (e) {
                        setState(() {
                          _addressController.text = "${lp.currentPosition!.latitude.toStringAsFixed(4)}, ${lp.currentPosition!.longitude.toStringAsFixed(4)} (GPS)";
                        });
                      }
                    } else {
                      setState(() {
                        _addressController.text = "Location access denied";
                      });
                    }
                  },
                  icon: const Icon(Icons.gps_fixed, size: 14),
                  label: const Text('Use GPS', style: TextStyle(fontSize: 10)),
                ),
              ),
            ]),

            const SizedBox(height: 24),

            // Biometrics
            _buildSectionHeader(Icons.bar_chart, 'BIOMETRICS'),
            _buildSectionCard([
              Row(
                children: [
                  Expanded(child: _buildTextField('Height (cm)', _heightController, icon: Icons.height)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Weight (kg)', _weightController, icon: Icons.monitor_weight_outlined)),
                ],
              ),
              const SizedBox(height: 16),
              _buildDropdownField('Blood Group', _bloodGroup, ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'], (val) => setState(() => _bloodGroup = val!), icon: Icons.opacity),
            ]),

            const SizedBox(height: 48),

            // Footer Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<UserProvider>(context, listen: false).updateProfile(
                          name: _nameController.text,
                          avatarUrl: _avatarUrl,
                          dob: _dobController.text,
                          gender: _gender,
                          email: _emailController.text,
                          phone: _phoneController.text,
                          address: _addressController.text,
                          height: _heightController.text,
                          weight: _weightController.text,
                          bloodGroup: _bloodGroup,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E90FA),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xFF667085), fontSize: 14),
                    ),
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

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2E90FA), size: 18),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2E90FA),
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF2F4F7)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {IconData? icon, int maxLines = 1, Widget? suffix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF667085), fontSize: 12, fontWeight: FontWeight.w500)),
            if (suffix != null) suffix,
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.w500, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF98A2B3), size: 20) : null,
            filled: true,
            fillColor: const Color(0xFFF8F9FE),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF667085), fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF98A2B3)),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: const Color(0xFF98A2B3), size: 18),
                        const SizedBox(width: 12),
                      ],
                      Text(item, style: const TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.w500, fontSize: 14)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
