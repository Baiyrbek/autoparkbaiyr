import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:flutter/foundation.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  static const String _nameKey = 'profile_name';
  static const String _emailKey = 'profile_email';
  static const String _phoneKey = 'profile_phone';
  static const String _languageKey = 'profile_lang';
  static const String _currencyKey = 'profile_cur';
  static const String _profileImageKey = 'profile_image';

  ProfileBloc() : super(ProfileLoading()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateNameEvent>(_onUpdateName);
    on<UpdateEmailEvent>(_onUpdateEmail);
    on<UpdatePhoneEvent>(_onUpdatePhone);
    on<UpdateLanguageEvent>(_onUpdateLanguage);
    on<UpdateCurrencyEvent>(_onUpdateCurrency);
    on<UpdatePasswordEvent>(_onUpdatePassword);
    on<UpdateProfileImageEvent>(_onUpdateProfileImage);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final name = prefs.getString('name') ?? 'John Doe';
      final email = prefs.getString('email') ?? 'john@example.com';
      final phone = prefs.getString('phone') ?? '+1234567890';
      final language = prefs.getString('language') ?? 'English';
      final currency = prefs.getString('currency') ?? 'USD';
      final profileImage = prefs.getString(_profileImageKey);

      emit(ProfileLoaded(
        name: name,
        email: email,
        phone: phone,
        language: language,
        currency: currency,
        profileImage: profileImage,
      ));
    } catch (e) {
      debugPrint('Error loading profile: $e');
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateName(
    UpdateNameEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      print(state.toString());
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_nameKey, event.name);
        
        final currentState = state as ProfileLoaded;
        emit(ProfileLoaded(
          name: event.name,
          email: currentState.email,
          phone: currentState.phone,
          language: currentState.language,
          currency: currentState.currency,
          profileImage: currentState.profileImage,
        ));
      } catch (e) {
      debugPrint('Error wqloading profile: $e');
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateEmail(
    UpdateEmailEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_emailKey, event.email);
        
        final currentState = state as ProfileLoaded;
        emit(ProfileLoaded(
          name: currentState.name,
          email: event.email,
          phone: currentState.phone,
          language: currentState.language,
          currency: currentState.currency,
          profileImage: currentState.profileImage,
        ));
      } catch (e) {
      debugPrint('Error wqdwq loading profile: $e');
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onUpdatePhone(
    UpdatePhoneEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_phoneKey, event.phone);
        
        final currentState = state as ProfileLoaded;
        emit(ProfileLoaded(
          name: currentState.name,
          email: currentState.email,
          phone: event.phone,
          language: currentState.language,
          currency: currentState.currency,
          profileImage: currentState.profileImage,
        ));
      } catch (e) {
      debugPrint('Error wqdwq loading profile: $e');
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateLanguage(
    UpdateLanguageEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_languageKey, event.language);
        
        final currentState = state as ProfileLoaded;
        emit(ProfileLoaded(
          name: currentState.name,
          email: currentState.email,
          phone: currentState.phone,
          language: event.language,
          currency: currentState.currency,
          profileImage: currentState.profileImage,
        ));
      } catch (e) {
      debugPrint('Errorwqd  loading profile: $e');
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateCurrency(
    UpdateCurrencyEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_currencyKey, event.currency);
        
        final currentState = state as ProfileLoaded;
        emit(ProfileLoaded(
          name: currentState.name,
          email: currentState.email,
          phone: currentState.phone,
          language: currentState.language,
          currency: event.currency,
          profileImage: currentState.profileImage,
        ));
      } catch (e) {
      debugPrint('Error21e2 loading profile: $e');
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onUpdatePassword(
    UpdatePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('password', event.password);
        
        // Don't emit new state for password as it's sensitive data
      } catch (e) {
      debugPrint('Errowqdqwdwdwr loading profile: $e');
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateProfileImage(UpdateProfileImageEvent event, Emitter<ProfileState> emit) async {
    print(event.imageBase64);
    if (state is ProfileLoaded) {
      try {
        final currentState = state as ProfileLoaded;
        
        // Save to SharedPreferences first
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_profileImageKey, event.imageBase64);
        
        // Then emit new state
        emit(ProfileLoaded(
          name: currentState.name,
          email: currentState.email,
          phone: currentState.phone,
          language: currentState.language,
          currency: currentState.currency,
          profileImage: event.imageBase64,
        ));
      } catch (e) {
        debugPrint('Error updating profile image: $e');
        emit(ProfileError(e.toString()));
      }
    }
    if (state is ProfileError) {
      print('Profile error: ${state.toString()}');
    }
  }
} 