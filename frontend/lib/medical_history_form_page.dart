import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'user_provider.dart';

class MedicalHistoryFormPage extends StatefulWidget {
  const MedicalHistoryFormPage({super.key});

  @override
  State<MedicalHistoryFormPage> createState() => _MedicalHistoryFormPageState();
}

class _MedicalHistoryFormPageState extends State<MedicalHistoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000'));
  bool _isSubmitting = false;
  bool _isAutosaving = false;
  Timer? _debounceTimer;

  // Form Fields
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();
  final TextEditingController _emergencyRelationshipController = TextEditingController();
  final TextEditingController _emergencyPhoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _physicianNameController = TextEditingController();
  final TextEditingController _physicianSpecialtyController = TextEditingController();
  final TextEditingController _physicianAddressController = TextEditingController();
  final TextEditingController _physicianPhoneController = TextEditingController();
  final TextEditingController _doctorCareExplanation = TextEditingController();
  final TextEditingController _lastPhysicalExam = TextEditingController();
  final TextEditingController _medicationsList = TextEditingController();
  final TextEditingController _hospitalizationExplanation = TextEditingController();

  bool _underDoctorCare = false;
  String _hadExerciseTest = 'No'; 
  String _exerciseTestResults = 'Normal'; 
  bool _takesMedications = false;
  bool _recentlyHospitalized = false;
  bool _smokes = false;
  bool _isPregnant = false;
  bool _alcoholHeavy = false;
  bool _stressHigh = false;
  bool _activeModerately = false;
  bool _hasHighBP = false;
  bool _hasHighCholesterol = false;
  bool _hasDiabetes = false;
  bool _familyHeartAttack = false;
  bool _familyStroke = false;
  bool _familyHighBP = false;

  @override
  void initState() {
    super.initState();
    // Add listeners for autosave
    for (var controller in [
      _phoneController, _dobController, _ageController, _heightController,
      _weightController, _emergencyContactController, _emergencyRelationshipController,
      _emergencyPhoneController, _addressController, _physicianNameController,
      _physicianSpecialtyController, _physicianAddressController, _physicianPhoneController,
      _doctorCareExplanation, _lastPhysicalExam, _medicationsList, _hospitalizationExplanation
    ]) {
      controller.addListener(_onFieldChanged);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    for (var controller in [
      _phoneController, _dobController, _ageController, _heightController,
      _weightController, _emergencyContactController, _emergencyRelationshipController,
      _emergencyPhoneController, _addressController, _physicianNameController,
      _physicianSpecialtyController, _physicianAddressController, _physicianPhoneController,
      _doctorCareExplanation, _lastPhysicalExam, _medicationsList, _hospitalizationExplanation
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onFieldChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(seconds: 3), () {
      _autosave();
    });
  }

  Future<void> _autosave() async {
    if (_isSubmitting || !mounted) return;
    setState(() => _isAutosaving = true);
    try {
      await _performSave();
    } catch (e) {
      // Background error ignored
    } finally {
      if (mounted) setState(() => _isAutosaving = false);
    }
  }

  Future<void> _performSave() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await _dio.post('/api/v1/medical-history', data: {
      'user_id': userProvider.clinicalId,
      'phone': _phoneController.text,
      'dob': _dobController.text,
      'age': int.tryParse(_ageController.text),
      'height': _heightController.text,
      'weight': _weightController.text,
      'emergency_contact': _emergencyContactController.text,
      'emergency_relationship': _emergencyRelationshipController.text,
      'address': _addressController.text,
      'emergency_phone': _emergencyPhoneController.text,
      'physician_name': _physicianNameController.text,
      'physician_specialty': _physicianSpecialtyController.text,
      'physician_address': _physicianAddressController.text,
      'physician_phone': _physicianPhoneController.text,
      'under_doctor_care': _underDoctorCare,
      'doctor_care_explanation': _doctorCareExplanation.text,
      'last_physical_exam': _lastPhysicalExam.text,
      'had_exercise_test': _hadExerciseTest,
      'exercise_test_results': _exerciseTestResults,
      'takes_medications': _takesMedications,
      'medications_list': _medicationsList.text,
      'recently_hospitalized': _recentlyHospitalized,
      'hospitalization_explanation': _hospitalizationExplanation.text,
      'smokes': _smokes,
      'is_pregnant': _isPregnant,
      'alcohol_heavy': _alcoholHeavy,
      'stress_high': _stressHigh,
      'active_moderately': _activeModerately,
      'has_high_bp': _hasHighBP,
      'has_high_cholesterol': _hasHighCholesterol,
      'has_diabetes': _hasDiabetes,
      'family_heart_attack': _familyHeartAttack,
      'family_stroke': _familyStroke,
      'family_high_bp': _familyHighBP,
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await _performSave();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medical history saved successfully!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving medical history: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Text('Medical History Review', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
            const Spacer(),
            if (_isAutosaving)
              const Row(
                children: [
                  SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0F52FF))),
                  SizedBox(width: 8),
                  Text('Autosaving...', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                ],
              ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isSubmitting 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Please fill out this form accurately. This data is critical for your clinical profile.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  _sectionTitle('PERSONAL INFORMATION'),
                  _buildTextField('Full Name', initialValue: userProvider.name, enabled: false),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Telephone', controller: _phoneController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('Date of Birth', controller: _dobController, hint: 'MM/DD/YYYY')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Age', controller: _ageController, keyboardType: TextInputType.number)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('Height', controller: _heightController)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('Weight', controller: _weightController)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('Address', controller: _addressController, maxLines: 2),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Emergency Contact', controller: _emergencyContactController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('Relationship', controller: _emergencyRelationshipController)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('Emergency Phone', controller: _emergencyPhoneController),

                  const SizedBox(height: 32),
                  _sectionTitle('PHYSICIAN INFORMATION'),
                  _buildTextField('Primary Physician', controller: _physicianNameController),
                  const SizedBox(height: 16),
                  _buildTextField('Specialty', controller: _physicianSpecialtyController),
                  const SizedBox(height: 16),
                  _buildTextField('Physician Address', controller: _physicianAddressController, maxLines: 2),
                  const SizedBox(height: 16),
                  _buildTextField('Physician Phone', controller: _physicianPhoneController),

                  const SizedBox(height: 32),
                  _sectionTitle('HEALTH QUESTIONS'),
                  _buildSwitchTile('Are you currently under a doctor\'s care?', _underDoctorCare, (v) {
                    setState(() => _underDoctorCare = v);
                    _onFieldChanged();
                  }),
                  if (_underDoctorCare)
                    _buildTextField('If yes, explain', controller: _doctorCareExplanation, maxLines: 2),
                  const SizedBox(height: 16),
                  _buildTextField('When was the last time you had a physical examination?', controller: _lastPhysicalExam),
                  const SizedBox(height: 16),
                  
                  const Text('Have you ever had an exercise stress test?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildRadio('Yes', 'Yes', _hadExerciseTest, (v) {
                        setState(() => _hadExerciseTest = v!);
                        _onFieldChanged();
                      }),
                      const SizedBox(width: 12),
                      _buildRadio('No', 'No', _hadExerciseTest, (v) {
                        setState(() => _hadExerciseTest = v!);
                        _onFieldChanged();
                      }),
                      const SizedBox(width: 12),
                      _buildRadio('Don\'t Know', 'Don\'t Know', _hadExerciseTest, (v) {
                        setState(() => _hadExerciseTest = v!);
                        _onFieldChanged();
                      }),
                    ],
                  ),
                  if (_hadExerciseTest == 'Yes') ...[
                    const SizedBox(height: 16),
                    const Text('If yes, were the results:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildRadio('Normal', 'Normal', _exerciseTestResults, (v) {
                          setState(() => _exerciseTestResults = v!);
                          _onFieldChanged();
                        }),
                        const SizedBox(width: 12),
                        _buildRadio('Abnormal', 'Abnormal', _exerciseTestResults, (v) {
                          setState(() => _exerciseTestResults = v!);
                          _onFieldChanged();
                        }),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),
                  _buildSwitchTile('Do you take any medications on a regular basis?', _takesMedications, (v) {
                    setState(() => _takesMedications = v);
                    _onFieldChanged();
                  }),
                  if (_takesMedications)
                    _buildTextField('List medications and reasons for taking', controller: _medicationsList, maxLines: 3),
                  
                  const SizedBox(height: 16),
                  _buildSwitchTile('Have you been recently hospitalized?', _recentlyHospitalized, (v) {
                    setState(() => _recentlyHospitalized = v);
                    _onFieldChanged();
                  }),
                  if (_recentlyHospitalized)
                    _buildTextField('If yes, explain', controller: _hospitalizationExplanation, maxLines: 2),

                  const SizedBox(height: 32),
                  _sectionTitle('LIFESTYLE & RISKS'),
                  _buildCheckboxTile('Do you smoke?', _smokes, (v) {
                    setState(() => _smokes = v!);
                    _onFieldChanged();
                  }),
                  _buildCheckboxTile('Are you pregnant?', _isPregnant, (v) {
                    setState(() => _isPregnant = v!);
                    _onFieldChanged();
                  }),
                  _buildCheckboxTile('Do you drink alcohol more than 3 times/week?', _alcoholHeavy, (v) {
                    setState(() => _alcoholHeavy = v!);
                    _onFieldChanged();
                  }),
                  _buildCheckboxTile('Is your stress level high?', _stressHigh, (v) {
                    setState(() => _stressHigh = v!);
                    _onFieldChanged();
                  }),
                  _buildCheckboxTile('Are you active on most days of the week?', _activeModerately, (v) {
                    setState(() => _activeModerately = v!);
                    _onFieldChanged();
                  }),

                  const SizedBox(height: 32),
                  _sectionTitle('CHRONIC CONDITIONS (DO YOU HAVE?)'),
                  _buildCheckboxTile('High blood pressure?', _hasHighBP, (v) {
                    setState(() => _hasHighBP = v!);
                    _onFieldChanged();
                  }),
                  _buildCheckboxTile('High cholesterol?', _hasHighCholesterol, (v) {
                    setState(() => _hasHighCholesterol = v!);
                    _onFieldChanged();
                  }),
                  _buildCheckboxTile('Diabetes?', _hasDiabetes, (v) {
                    setState(() => _hasDiabetes = v!);
                    _onFieldChanged();
                  }),

                  const SizedBox(height: 32),
                  _sectionTitle('FAMILY HISTORY (PRIOR TO AGE 55)'),
                  _buildCheckboxTile('Heart Attack?', _familyHeartAttack, (v) {
                    setState(() => _familyHeartAttack = v!);
                    _onFieldChanged();
                  }),
                  _buildCheckboxTile('Stroke?', _familyStroke, (v) {
                    setState(() => _familyStroke = v!);
                    _onFieldChanged();
                  }),
                  _buildCheckboxTile('High Blood Pressure?', _familyHighBP, (v) {
                    setState(() => _familyHighBP = v!);
                    _onFieldChanged();
                  }),

                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F52FF),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text('Complete & Finalize', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 11, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildTextField(String label, {TextEditingController? controller, String? initialValue, bool enabled = true, String? hint, int maxLines = 1, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            initialValue: initialValue,
            enabled: enabled,
            maxLines: maxLines,
            keyboardType: keyboardType,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
              filled: true,
              fillColor: enabled ? Colors.white : const Color(0xFFF1F5F9),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF0F52FF), width: 2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
        subtitle: Text(value ? 'YES' : 'NO', style: TextStyle(color: value ? const Color(0xFF0F52FF) : const Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
        value: value,
        onChanged: onChanged,
        contentPadding: EdgeInsets.zero,
        activeColor: const Color(0xFF0F52FF),
      ),
    );
  }

  Widget _buildCheckboxTile(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: const Color(0xFF0F52FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildRadio(String label, String value, String groupValue, Function(String?) onChanged) {
    final bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F52FF).withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF0F52FF) : const Color(0xFFE2E8F0), width: isSelected ? 2 : 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.check_circle, color: Color(0xFF0F52FF), size: 16),
              ),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF0F52FF) : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
