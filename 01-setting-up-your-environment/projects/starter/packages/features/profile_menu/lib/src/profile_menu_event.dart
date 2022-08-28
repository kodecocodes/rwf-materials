part of 'profile_menu_bloc.dart';

abstract class ProfileMenuEvent extends Equatable {
  const ProfileMenuEvent();

  @override
  List<Object?> get props => [];
}

class ProfileMenuStarted extends ProfileMenuEvent {
  const ProfileMenuStarted();
}

class ProfileMenuDarkModePreferenceChanged extends ProfileMenuEvent {
  const ProfileMenuDarkModePreferenceChanged(
    this.preference,
  );

  final DarkModePreference preference;

  @override
  List<Object?> get props => [
        preference,
      ];
}

class ProfileMenuSignedOut extends ProfileMenuEvent {
  const ProfileMenuSignedOut();
}
