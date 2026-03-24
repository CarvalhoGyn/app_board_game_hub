import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:geolocator/geolocator.dart';
import 'game_catalog.dart';
import '../providers/user_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nicknameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _enableLocation = false;
  String? _selectedCountry;

  final List<String> _countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Germany',
    'France',
    'Japan',
    'Brazil',
  ];

  final Map<String, String> _countryCodes = {
    'United States': '+1',
    'Canada': '+1',
    'United Kingdom': '+44',
    'Germany': '+49',
    'France': '+33',
    'Japan': '+81',
    'Brazil': '+55',
  };

  DateTime? _selectedBirthDate;
  Position? _currentPosition;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) _showError('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) _showError('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) _showError('Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location acquired!')));
    } catch (e) {
      if (mounted) _showError('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha:0.95),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme.colorScheme.onSurface),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Join the table. Track plays, find local groups, and discover your next favorite board game.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: mutedColor,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildFieldLabel('Nickname *', theme),
            _buildTextField(
              controller: _nicknameController,
              hintText: 'MeepleMaster99',
              icon: Icons.smart_toy_outlined,
              theme: theme, mutedColor: mutedColor,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('First Name *', theme),
                      _buildTextField(
                        controller: _firstNameController,
                        hintText: 'Jane',
                        theme: theme, mutedColor: mutedColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Last Name *', theme),
                      _buildTextField(
                        controller: _lastNameController,
                        hintText: 'Doe',
                        theme: theme, mutedColor: mutedColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFieldLabel('Email Address *', theme),
            _buildTextField(
              controller: _emailController,
              hintText: 'jane@example.com',
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              theme: theme, mutedColor: mutedColor,
            ),
            const SizedBox(height: 20),
            _buildFieldLabel('Date of Birth *', theme),
            _buildDatePickerField(theme, mutedColor),
            const SizedBox(height: 20),
            _buildFieldLabel('Country *', theme),
            _buildDropdownField(theme, mutedColor),
            const SizedBox(height: 20),
            _buildFieldLabel('Phone Number *', theme),
            _buildTextField(
              controller: _phoneController,
              hintText: '+1 (555) 000-0000',
              icon: Icons.call_outlined,
              keyboardType: TextInputType.phone,
              theme: theme, mutedColor: mutedColor,
            ),
            const SizedBox(height: 20),
            _buildLocationToggle(theme, mutedColor),
            const SizedBox(height: 20),
            _buildFieldLabel('Password', theme),
            _buildTextField(
              controller: _passwordController,
              hintText: '••••••••',
              icon: Icons.lock_outline,
              isPassword: true,
              isPasswordVisible: _isPasswordVisible,
              onToggleVisibility: () {
                setState(() => _isPasswordVisible = !_isPasswordVisible);
              },
              theme: theme, mutedColor: mutedColor,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Text(
                'Must be at least 8 characters long.',
                style: TextStyle(color: mutedColor, fontSize: 12),
              ),
            ),
            const SizedBox(height: 40),
            _buildCreateAccountButton(theme),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(color: mutedColor, fontSize: 14),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerField(ThemeData theme, Color mutedColor) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedBirthDate ?? DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(
                  primary: theme.primaryColor,
                  onPrimary: theme.colorScheme.onPrimary,
                  surface: theme.cardTheme.color,
                  onSurface: theme.colorScheme.onSurface,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null && picked != _selectedBirthDate) {
          setState(() {
            _selectedBirthDate = picked;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: mutedColor, size: 20),
            const SizedBox(width: 12),
            Text(
              _selectedBirthDate == null
                  ? 'Select your birthday'
                  : '${_selectedBirthDate!.day}/${_selectedBirthDate!.month}/${_selectedBirthDate!.year}',
              style: TextStyle(
                color: _selectedBirthDate == null ? mutedColor : theme.colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, ThemeData theme) {
    final bool isRequired = label.endsWith(' *');
    final String cleanLabel = isRequired ? label.substring(0, label.length - 2) : label;

    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text.rich(
        TextSpan(
          text: cleanLabel,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          children: [
            if (isRequired)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.redAccent),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required ThemeData theme,
    required Color mutedColor,
    IconData? icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        style: TextStyle(color: theme.colorScheme.onSurface),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: mutedColor),
          prefixIcon: icon != null ? Icon(icon, color: mutedColor) : null,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: mutedColor,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDropdownField(ThemeData theme, Color mutedColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCountry,
          hint: Text('Select your country', style: TextStyle(color: mutedColor)),
          isExpanded: true,
          dropdownColor: theme.cardTheme.color,
          icon: Icon(Icons.expand_more, color: mutedColor),
          items: _countries.map((String country) {
            return DropdownMenuItem<String>(
              value: country,
              child: Text(country, style: TextStyle(color: theme.colorScheme.onSurface)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCountry = newValue;
              if (newValue != null && _countryCodes.containsKey(newValue)) {
                _phoneController.text = _countryCodes[newValue]!;
                // Move cursor to end
                _phoneController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _phoneController.text.length),
                );
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildLocationToggle(ThemeData theme, Color mutedColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enable Location',
                style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                'Find local game nights nearby',
                style: TextStyle(color: mutedColor, fontSize: 14),
              ),
            ],
          ),
          CupertinoSwitch(
            value: _enableLocation,
            activeTrackColor: theme.primaryColor,
            onChanged: (value) {
              setState(() => _enableLocation = value);
              if (value) {
                _getCurrentLocation();
              } else {
                 setState(() => _currentPosition = null);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAccountButton(ThemeData theme) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
          // Validation
          if (_nicknameController.text.trim().isEmpty) {
            _showError('Nickname is required');
            return;
          }
          if (_firstNameController.text.trim().isEmpty) {
            _showError('First Name is required');
            return;
          }
          if (_lastNameController.text.trim().isEmpty) {
            _showError('Last Name is required');
            return;
          }
          if (_emailController.text.trim().isEmpty) {
            _showError('Email is required');
            return;
          }
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(_emailController.text.trim())) {
            _showError('Please enter a valid email address');
            return;
          }
          if (_selectedBirthDate == null) {
            _showError('Date of birth is required');
            return;
          }
          if (_phoneController.text.trim().isEmpty) {
            _showError('Phone number is required');
            return;
          }
          final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
          if (!phoneRegex.hasMatch(_phoneController.text.trim().replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
            _showError('Please enter a valid phone number');
            return;
          }
          if (_selectedCountry == null) {
            _showError('Please select your country');
            return;
          }
          if (_passwordController.text.length < 8) {
            _showError('Password must be at least 8 characters long');
            return;
          }

          final usersDao = context.read<UsersDao>();
          final messenger = ScaffoldMessenger.of(context);
          final navigator = Navigator.of(context);
          
          try {
            // 1. Create User in Supabase Auth
            final response = await supabase.Supabase.instance.client.auth.signUp(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              data: {
                'username': _nicknameController.text.trim(),
                'first_name': _firstNameController.text.trim(),
                'last_name': _lastNameController.text.trim(),
                'country': _selectedCountry,
                'phone': _phoneController.text.trim(),
                'birth_date': _selectedBirthDate?.toIso8601String(),
                'latitude': _currentPosition?.latitude,
                'longitude': _currentPosition?.longitude,
                // Add other metadata as needed by handle_new_user or just for record
              },
            );

            if (response.user == null) {
              throw Exception('Registration failed: No user returned');
            }
            
            final userId = response.user!.id;

            // 2. Insert into Local DB (Drift) using the Supabase UUID
            await usersDao.createUser(UsersCompanion(
              id: drift.Value(userId),
              username: drift.Value(_nicknameController.text.trim()),
              email: drift.Value(_emailController.text.trim()),
              password: drift.Value(''), // Do not store password locally if using Auth
              firstName: drift.Value(_firstNameController.text.trim()),
              lastName: drift.Value(_lastNameController.text.trim()),
              phone: drift.Value(_phoneController.text.trim()),
              country: drift.Value(_selectedCountry),
              birthDate: drift.Value(_selectedBirthDate),
              latitude: drift.Value(_currentPosition?.latitude),
              longitude: drift.Value(_currentPosition?.longitude),
            ));
            
            // 3. Login Session
            final createdUser = await usersDao.getUserById(userId);
            if (createdUser != null) {
              if (!mounted) return;
              context.read<UserSession>().login(createdUser);
            }
            
            messenger.showSnackBar(
              const SnackBar(
                content: Text('Account created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            
            navigator.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const GameCatalog()),
              (route) => false,
            );
          } on supabase.AuthException catch (e) {
             if (mounted) _showError(e.message);
          } catch (e) {
            if (mounted) _showError('Error creating account: ${e.toString()}');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(
          'Create Account',
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
