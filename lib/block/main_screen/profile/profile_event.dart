abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class UpdateNameEvent extends ProfileEvent {
  final String name;
  UpdateNameEvent(this.name);
}

class UpdateEmailEvent extends ProfileEvent {
  final String email;
  UpdateEmailEvent(this.email);
}

class UpdatePhoneEvent extends ProfileEvent {
  final String phone;
  UpdatePhoneEvent(this.phone);
}

class UpdateLanguageEvent extends ProfileEvent {
  final String language;
  UpdateLanguageEvent(this.language);
}

class UpdateCurrencyEvent extends ProfileEvent {
  final String currency;
  UpdateCurrencyEvent(this.currency);
}

class UpdatePasswordEvent extends ProfileEvent {
  final String password;
  UpdatePasswordEvent(this.password);
}

class UpdateProfileImageEvent extends ProfileEvent {
  final String imageBase64;
  UpdateProfileImageEvent(this.imageBase64);
} 