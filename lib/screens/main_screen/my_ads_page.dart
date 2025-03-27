import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dodoshautopark/block/main_screen/profile/profile_bloc.dart';
import 'package:dodoshautopark/block/main_screen/profile/profile_event.dart';
import 'package:dodoshautopark/block/main_screen/profile/profile_state.dart';
import 'package:dodoshautopark/constants/lang_strings.dart';
import 'dart:convert';
import 'dart:io';

class MyAdsPage extends StatefulWidget {
  const MyAdsPage({super.key});

  @override
  State<MyAdsPage> createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
  try {
    final navigator = Navigator.of(context); // Store before async
    final messenger = ScaffoldMessenger.of(context); // Store before async
    final profileBloc = context.read<ProfileBloc>(); // Store before async

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 70,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      profileBloc.add(UpdateProfileImageEvent(base64Image)); // Use stored bloc
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController(text: '********');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildProfileImage(ProfileLoaded state) {
    if (state.profileImage != null && state.profileImage!.isNotEmpty) {
      try {
        final bytes = base64Decode(state.profileImage!);
        return CircleAvatar(
          radius: 50,
          backgroundImage: MemoryImage(bytes),
          child: null,
        );
      } catch (e) {
        debugPrint('Error decoding profile image: $e');
        return CircleAvatar(
          radius: 50,
          child: const Icon(Icons.person, size: 50, color: Colors.grey),
        );
      }
    }
    return CircleAvatar(
      radius: 50,
      child: const Icon(Icons.person, size: 50, color: Colors.grey),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileLoaded state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              _buildProfileImage(state),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: () => _pickImage(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            state.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            state.email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfileEvent()),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded) {
            // Update controllers with state values
            _nameController.text = state.name;
            _emailController.text = state.email;
            _phoneController.text = state.phone;

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(context, state),
                  _buildProfileContent(context, state),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: STRINGS[LANG]?['personal_info'] ?? 'Personal Information',
            children: [
              _buildEditableField(
                context,
                label: STRINGS[LANG]?['name'] ?? 'Name',
                value: state.name,
                onChanged: (value) {
                  context.read<ProfileBloc>().add(UpdateNameEvent(value));
                },
              ),
              _buildEditableField(
                context,
                label: STRINGS[LANG]?['email'] ?? 'Email',
                value: state.email,
                onChanged: (value) {
                  context.read<ProfileBloc>().add(UpdateEmailEvent(value));
                },
              ),
              _buildEditableField(
                context,
                label: STRINGS[LANG]?['phone'] ?? 'Phone',
                value: state.phone,
                onChanged: (value) {
                  context.read<ProfileBloc>().add(UpdatePhoneEvent(value));
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: STRINGS[LANG]?['preferences'] ?? 'Preferences',
            children: [
              _buildDropdownField(
                context,
                label: STRINGS[LANG]?['language'] ?? 'Language',
                value: state.language,
                items: ['Русский', 'Кыргызча', 'English'],
                onChanged: (value) {
                  context.read<ProfileBloc>().add(UpdateLanguageEvent(value));
                },
              ),
              _buildDropdownField(
                context,
                label: STRINGS[LANG]?['currency'] ?? 'Currency',
                value: state.currency,
                items: ['USD', 'KGS'],
                onChanged: (value) {
                  context.read<ProfileBloc>().add(UpdateCurrencyEvent(value));
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildEditableField(
    BuildContext context, {
    required String label,
    required String value,
    required Function(String) onChanged,
    bool isPassword = false,
  }) {
    TextEditingController getController() {
      if (label == (STRINGS[LANG]?['name'] ?? 'Name')) {
        return _nameController;
      } else if (label == (STRINGS[LANG]?['email'] ?? 'Email')) {
        return _emailController;
      } else if (label == (STRINGS[LANG]?['phone'] ?? 'Phone')) {
        return _phoneController;
      } else {
        return _passwordController;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        controller: getController(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownField(
    BuildContext context, {
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    print(value);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
