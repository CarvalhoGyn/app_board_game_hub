import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:geolocator/geolocator.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import '../providers/user_session.dart';
import '../providers/theme_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../services/supabase_storage_service.dart';
import 'package:app_board_game_hub/l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _countryController;
  DateTime? _selectedBirthDate;
  File? _pickedImageFile;
  bool _isLoading = false;
  Position? _currentPosition;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _phoneController = TextEditingController(text: widget.user.phone);
    _countryController = TextEditingController(text: widget.user.country);
    _selectedBirthDate = widget.user.birthDate;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      final usersDao = context.read<UsersDao>();
      
      final updatedUser = UsersCompanion(
        firstName: drift.Value(_firstNameController.text.isNotEmpty ? _firstNameController.text : null),
        lastName: drift.Value(_lastNameController.text.isNotEmpty ? _lastNameController.text : null),
        phone: drift.Value(_phoneController.text.isNotEmpty ? _phoneController.text : null),
        country: drift.Value(_countryController.text.isNotEmpty ? _countryController.text : null),
        birthDate: drift.Value(_selectedBirthDate),

        latitude: drift.Value(_currentPosition?.latitude ?? widget.user.latitude),
        longitude: drift.Value(_currentPosition?.longitude ?? widget.user.longitude),
        avatarUrl: drift.Value(_avatarUrl ?? widget.user.avatarUrl),
      );

      await usersDao.updateUser(widget.user.id, updatedUser);

      // fetch updated user again to update session
      final newUser = await usersDao.getUserById(widget.user.id);
      
      if (mounted && newUser != null) {
        context.read<UserSession>().updateUser(newUser);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text(AppLocalizations.of(context)!.profileUpdatedSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.profileUpdatedError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        // We can just rely on the main AppTheme dark/light modes now
        // But the picker might need specific overrides if the theme isn't perfect
        return child!;
      },
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }


  Future<void> _updateLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.locationDisabled)));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.locationDenied)));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.locationPermDenied)));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.locationUpdateSuccess)));
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.locationUpdateError(e.toString()))));
    }
    }
  

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    
    if (pickedFile != null) {
       setState(() {
         _pickedImageFile = File(pickedFile.path);
         _isLoading = true;
       });

       try {
         final storageService = context.read<SupabaseStorageService>();
         final url = await storageService.uploadAvatar(_pickedImageFile!, widget.user.id);
         
         if (mounted && url != null) {
             setState(() {
               _avatarUrl = url;
               _isLoading = false;
             });
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.imageUploaded)));
         }
       } catch (e) {
          setState(() {
             _pickedImageFile = null; 
             _isLoading = false;
          });
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.imageUploadFailed(e.toString()))));
       }
    }
  }
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editProfile, style: TextStyle(color: theme.colorScheme.onSurface)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Theme Selector
            Container(
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
               ),
               child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(AppLocalizations.of(context)!.appearanceLabel, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                     const SizedBox(height: 12),
                     SegmentedButton<ThemeMode>(
                        segments: [
                           ButtonSegment(
                              value: ThemeMode.system, 
                              label: FittedBox(fit: BoxFit.scaleDown, child: Text(AppLocalizations.of(context)!.themeSystem)), 
                              icon: const Icon(Icons.settings_brightness)
                           ),
                           ButtonSegment(
                              value: ThemeMode.light, 
                              label: FittedBox(fit: BoxFit.scaleDown, child: Text(AppLocalizations.of(context)!.themeLight)), 
                              icon: const Icon(Icons.light_mode)
                           ),
                           ButtonSegment(
                              value: ThemeMode.dark, 
                              label: FittedBox(fit: BoxFit.scaleDown, child: Text(AppLocalizations.of(context)!.themeDark)), 
                              icon: const Icon(Icons.dark_mode)
                           ),
                        ],
                        selected: {themeProvider.themeMode},
                        onSelectionChanged: (Set<ThemeMode> newSelection) {
                           themeProvider.setTheme(newSelection.first);
                        },
                        style: ButtonStyle(
                           side: WidgetStateProperty.all(BorderSide(color: theme.primaryColor.withOpacity(0.5))),
                           foregroundColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) return theme.colorScheme.onPrimary;
                              return theme.colorScheme.onSurface;
                           }),
                           backgroundColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) return theme.colorScheme.primary; 
                              return Colors.transparent;
                           }),
                        ),
                     ),
                  ],
               ),
               ),

            const SizedBox(height: 24),
            
            // Avatar Picker
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                      backgroundImage: _pickedImageFile != null 
                          ? FileImage(_pickedImageFile!)
                          : (_avatarUrl != null || widget.user.avatarUrl != null)
                              ? NetworkImage(_avatarUrl ?? widget.user.avatarUrl!) as ImageProvider
                              : null,
                      child: (_pickedImageFile == null && _avatarUrl == null && widget.user.avatarUrl == null)
                          ? Icon(Icons.person, size: 60, color: theme.primaryColor)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.scaffoldBackgroundColor, width: 2),
                        ),
                        child: Icon(Icons.camera_alt, color: theme.colorScheme.onPrimary, size: 20),
                      ),
                    ),
                    if (_isLoading)
                       const Positioned.fill(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildTextField(
              controller: _firstNameController,
              label: AppLocalizations.of(context)!.firstNameLabel,
              icon: Icons.person_outline,
              theme: theme,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _lastNameController,
              label: AppLocalizations.of(context)!.lastNameLabel,
              icon: Icons.person_outline,
              theme: theme,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: AppLocalizations.of(context)!.phoneNumberLabel,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              theme: theme,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _countryController,
              label: AppLocalizations.of(context)!.countryLabel,
              icon: Icons.public,
              theme: theme,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: theme.primaryColor),
                    const SizedBox(width: 12),
                    Text(
                      _selectedBirthDate != null
                          ? '${_selectedBirthDate!.day}/${_selectedBirthDate!.month}/${_selectedBirthDate!.year}'
                          : AppLocalizations.of(context)!.selectBirthDateLabel,
                      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _updateLocation,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: theme.primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _currentPosition != null
                            ? AppLocalizations.of(context)!.locationUpdated(_currentPosition!.latitude.toStringAsFixed(4), _currentPosition!.longitude.toStringAsFixed(4))
                            : (widget.user.latitude != null 
                                ? AppLocalizations.of(context)!.locationCurrent(widget.user.latitude!.toStringAsFixed(4), widget.user.longitude!.toStringAsFixed(4)) 
                                : AppLocalizations.of(context)!.updateLocationLabel),
                        style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16),
                      ),
                    ),
                    if (_isLoading && _currentPosition == null) 
                       const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _isLoading 
                  ? CircularProgressIndicator(color: theme.colorScheme.onPrimary)
                  : Text(
                      AppLocalizations.of(context)!.saveChangesButton,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    required ThemeData theme,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: theme.colorScheme.onSurface),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: mutedColor), 
          prefixIcon: Icon(icon, color: theme.primaryColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
