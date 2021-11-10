import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quote_repository/quote_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/user_repository.dart';

part 'profile_menu_event.dart';

part 'profile_menu_state.dart';

class ProfileMenuBloc extends Bloc<ProfileMenuEvent, ProfileMenuState> {
  ProfileMenuBloc({
    required this.userRepository,
    required this.quoteRepository,
  }) : super(
          const ProfileMenuInProgress(),
        ) {
    on<ProfileMenuStarted>(
      (_, emit) async {
        await emit.onEach(
          Rx.combineLatest2<User?, DarkModePreference, ProfileMenuLoaded>(
            userRepository.getUser(),
            userRepository.getDarkModePreference(),
            (user, darkModePreference) => ProfileMenuLoaded(
              darkModePreference: darkModePreference,
              username: user?.username,
            ),
          ),
          onData: emit,
        );
      },
      transformer: (events, mapper) => events.flatMap(
        mapper,
      ),
    );

    on<ProfileMenuSignedOut>((_, emit) async {
      final currentState = state as ProfileMenuLoaded;
      final newState = currentState.copyWith(
        isSignOutInProgress: true,
      );

      emit(newState);

      await userRepository.signOut();
      await quoteRepository.clearCache();
    });

    on<ProfileMenuDarkModePreferenceChanged>((event, _) async {
      await userRepository.upsertDarkModePreference(
        event.preference,
      );
    });

    add(
      const ProfileMenuStarted(),
    );
  }

  final UserRepository userRepository;
  final QuoteRepository quoteRepository;
}
