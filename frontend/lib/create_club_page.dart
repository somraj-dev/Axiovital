import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'user_provider.dart';
import 'club_provider.dart';
import 'theme.dart';

class CreateClubPage extends StatefulWidget {
  const CreateClubPage({super.key});

  @override
  State<CreateClubPage> createState() => _CreateClubPageState();
}

class _CreateClubPageState extends State<CreateClubPage> {
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Form Data
  String? _selectedSport;
  final List<String> _selectedTags = [];
  XFile? _clubPhoto;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _privacy = 'Public';
  String _locationType = 'Global';
  String _manualLocation = 'Gwalior';

  // Constants
  final List<Map<String, dynamic>> _sports = [
    {'name': 'All Sports', 'icon': Icons.fitness_center},
    {'name': 'Cycling', 'icon': Icons.directions_bike, 'sub': 'Handcycle, E-Bike Ride, Gravel Ride...'},
    {'name': 'Running', 'icon': Icons.directions_run, 'sub': 'Run, Virtual Run, Trail Run'},
    {'name': 'Triathlon', 'icon': Icons.pool, 'sub': 'All Run, All Ride, Swim'},
    {'name': 'Alpine Skiing', 'icon': Icons.downhill_skiing},
    {'name': 'Backcountry Skiing', 'icon': Icons.downhill_skiing},
  ];

  final List<String> _tags = [
    'Just for fun',
    'Brand or organization',
    'Team',
    'Employee group',
    'Coach-led',
  ];

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      _finishCreation();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _finishCreation() {
    final clubProvider = Provider.of<ClubProvider>(context, listen: false);
    
    final newClub = {
      'title': _nameController.text,
      'members': 1,
      'image': _clubPhoto?.path != null && !kIsWeb 
          ? _clubPhoto!.path 
          : 'https://images.unsplash.com/photo-1517649763962-0c623066013b?q=80&w=2070&auto=format&fit=crop',
      'description': _descriptionController.text,
      'categories': _selectedTags,
      'about': _descriptionController.text,
    };

    clubProvider.addClub(newClub);

    // Show success and pop
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Club "${_nameController.text}" created successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  bool _isStepValid() {
    switch (_currentStep) {
      case 0: return _selectedSport != null;
      case 1: return _selectedTags.isNotEmpty;
      case 2: return _nameController.text.isNotEmpty && _descriptionController.text.isNotEmpty;
      case 3: return true; // Privacy always has a default
      case 4: return true; // Location always has a default
      default: return false;
    }
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0: return 'Sport';
      case 1: return 'Club Type';
      case 2: return 'Club Name';
      case 3: return 'Privacy';
      case 4: return 'Location';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _prevStep,
        ),
        title: Text(_getStepTitle()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CLOSE',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: _buildProgressBar(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildCurrentStep(),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: List.generate(_totalSteps, (index) {
        return Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: index <= _currentStep 
                  ? const Color(0xFF8DC63F) // Lime green from screenshot
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBottomBar() {
    final isValid = _isStepValid();
    final isLast = _currentStep == _totalSteps - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: isValid ? _nextStep : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isValid ? const Color(0xFFBF360C) : Colors.grey.withOpacity(0.3), // Burnt orange from screenshot
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          child: Text(
            isLast ? 'Create Club' : (isValid ? 'Next' : _getValidationText()),
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  String _getValidationText() {
    if (_currentStep == 1 && _selectedTags.isEmpty) return 'Select at least 1';
    return 'Next';
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildSportStep();
      case 1: return _buildTypeStep();
      case 2: return _buildIdentityStep();
      case 3: return _buildPrivacyStep();
      case 4: return _buildLocationStep();
      default: return const SizedBox();
    }
  }

  // --- STEP 1: SPORT ---
  Widget _buildSportStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your club\'s sport',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Go broad with "All Sports" or be specific with one sport type.',
          style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 32),
        ..._sports.map((sport) => _buildSportOption(sport)).toList(),
      ],
    );
  }

  Widget _buildSportOption(Map<String, dynamic> sport) {
    final isSelected = _selectedSport == sport['name'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: InkWell(
        onTap: () => setState(() => _selectedSport = sport['name']),
        child: Row(
          children: [
            Icon(sport['icon'], size: 28, color: isSelected ? Colors.white : Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sport['name'],
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (sport.containsKey('sub'))
                    Text(
                      sport['sub'],
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                    ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFBF360C) : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected 
                  ? Center(child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFBF360C), shape: BoxShape.circle)))
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // --- STEP 2: CLUB TYPE ---
  Widget _buildTypeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How would you describe your club?',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Pick up to 3 tags that fit best. Let others know what you\'re all about.',
          style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 32),
        ..._tags.map((tag) => _buildTagOption(tag)).toList(),
        const SizedBox(height: 20),
        Center(
          child: Text(
            'You can always change this later',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildTagOption(String tag) {
    final isSelected = _selectedTags.contains(tag);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedTags.remove(tag);
            } else if (_selectedTags.length < 3) {
              _selectedTags.add(tag);
            }
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFBF360C) : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Text(
            tag,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // --- STEP 3: IDENTITY ---
  Widget _buildIdentityStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customize Your Club',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Choose a club name, add a photo and write a description.',
          style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 40),
        Center(
          child: Stack(
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: _clubPhoto == null 
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text('Upload Photo', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.file(File(_clubPhoto!.path), fit: BoxFit.cover),
                    ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Color(0xFF2C2C2C), shape: BoxShape.circle),
                    child: const Icon(Icons.edit, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        _buildTextField('Club Name', _nameController),
        const SizedBox(height: 24),
        _buildTextField('Description', _descriptionController, maxLines: 4),
        const SizedBox(height: 24),
        Row(
          children: [
            const Icon(Icons.info_outline, size: 20, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.grey, height: 1.4),
                  children: [
                    const TextSpan(text: 'Help us keep Axiovital safe and fun. Your club\'s name and description must follow our '),
                    TextSpan(text: 'Community Standards', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFBF360C))),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _clubPhoto = image);
    }
  }

  // --- STEP 4: PRIVACY ---
  Widget _buildPrivacyStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Private or public?',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 48),
        Text('PRIVACY', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        const SizedBox(height: 24),
        _buildPrivacyOption(
          'Public',
          'Anyone on Axiovital can join your club and view recent activity and content.',
        ),
        const SizedBox(height: 32),
        _buildPrivacyOption(
          'Private',
          'People must request permission to join your club. Only admins can approve new members.',
        ),
      ],
    );
  }

  Widget _buildPrivacyOption(String title, String sub) {
    final isSelected = _privacy == title;
    return InkWell(
      onTap: () => setState(() => _privacy = title),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(sub, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFFBF360C) : Colors.grey,
                width: 2,
              ),
            ),
            child: isSelected 
                ? Center(child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFBF360C), shape: BoxShape.circle)))
                : null,
          ),
        ],
      ),
    );
  }

  // --- STEP 5: LOCATION ---
  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Where is your club located?',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Pick "Global" if your club isn\'t tied to one spot.',
          style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 48),
        _buildLocationOption('Global', Icons.public),
        const SizedBox(height: 16),
        _buildLocationOption(_manualLocation, Icons.my_location, isChangeable: true),
      ],
    );
  }

  Widget _buildLocationOption(String title, IconData icon, {bool isChangeable = false}) {
    final isSelected = _locationType == (isChangeable ? 'Local' : 'Global');
    return InkWell(
      onTap: () => setState(() => _locationType = isChangeable ? 'Local' : 'Global'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.white.withOpacity(0.3) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: isSelected ? Colors.white : Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                  if (isChangeable)
                    Text('Your Location', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            if (isChangeable)
              TextButton(
                onPressed: () {}, // Manual location pick
                child: Text('Change', style: TextStyle(color: isSelected ? Colors.white : Colors.grey)),
              ),
          ],
        ),
      ),
    );
  }
}
