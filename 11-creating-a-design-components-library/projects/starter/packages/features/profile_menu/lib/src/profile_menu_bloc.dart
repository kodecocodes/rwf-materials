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
    add(
      const ProfileMenuStarted(),
    );
  }

  final UserRepository userRepository;
  final QuoteRepository quoteRepository;

  @override
  Stream<Transition<ProfileMenuEvent, ProfileMenuState>> transformEvents(
    Stream<ProfileMenuEvent> events,
    TransitionFunction<ProfileMenuEvent, ProfileMenuState> transitionFn,
  ) {
    return events.flatMap(transitionFn);
  }

  @override
  Stream<ProfileMenuState> mapEventToState(ProfileMenuEvent event) async* {
    final state = this.state;
    if (event is ProfileMenuStarted) {
      // yield* Rx.combineLatest<User?, ProfileMenuLoaded>(
      //   List.filled(1, userRepository.getUser()),
      //   (users) => ProfileMenuLoaded(
      //     username: users.first?.username,
      //   ),
      // );
      yield* Rx.combineLatest2<User?, DarkModePreference, ProfileMenuLoaded>(
        userRepository.getUser(),
        userRepository.getDarkModePreference(),
        (user, darkModePreference) => ProfileMenuLoaded(
          darkModePreference: darkModePreference,
          username: user?.username,
        ),
      );
    } else if (event is ProfileMenuSignedOut && state is ProfileMenuLoaded) {
      yield state.copyWith(
        isSignOutInProgress: true,
      );
      await userRepository.signOut();
      await quoteRepository.clearCache();
    } else if (event is ProfileMenuDarkModePreferenceChanged &&
        state is ProfileMenuLoaded) {
      await userRepository.upsertDarkModePreference(
        event.preference,
      );
    }
  }
}
