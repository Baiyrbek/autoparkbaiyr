abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String phone;
  final String language;
  final String currency;
  final String? profileImage;

  ProfileLoaded({
    required this.name,
    required this.email,
    required this.phone,
    required this.language,
    required this.currency,
    this.profileImage,
  });

  ProfileLoaded copyWith({
    String? name,
    String? email,
    String? phone,
    String? language,
    String? currency,
    String? profileImage,
  }) {
    return ProfileLoaded(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
} 