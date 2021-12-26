part of 'profile_menu_bloc.dart';

abstract class ProfileMenuState extends Equatable {
  const ProfileMenuState();

  @override
  List<Object?> get props => [];
}

class ProfileMenuLoaded extends ProfileMenuState {
  const ProfileMenuLoaded({
    this.darkModePreference = DarkModePreference.useSystemSettings,
    this.isSignOutInProgress = false,
    this.username,
  });

  final DarkModePreference darkModePreference;
  final String? username;
  final bool isSignOutInProgress;

  bool get isUserAuthenticated => username != null;

  ProfileMenuLoaded copyWith({
    DarkModePreference? darkModePreference,
    String? username,
    bool? isSignOutInProgress,
  }) {
    return ProfileMenuLoaded(
      darkModePreference: darkModePreference ?? this.darkModePreference,
      username: username ?? this.username,
      isSignOutInProgress: isSignOutInProgress ?? this.isSignOutInProgress,
    );
  }

  @override
  List<Object?> get props => [
        darkModePreference,
        username,
        isSignOutInProgress,
      ];
}

class ProfileMenuInProgress extends ProfileMenuState {
  const ProfileMenuInProgress();
}
