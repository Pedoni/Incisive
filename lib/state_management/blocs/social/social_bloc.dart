import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:incisive/log/main_logger.dart';
import 'package:incisive/models/social_post_model.dart';
import 'package:incisive/repositories/social_repository.dart';

part 'social_event.dart';
part 'social_state.dart';

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  final SocialRepository socialRepository;

  SocialBloc({required this.socialRepository}) : super(InitSocialState()) {
    on<GetDailySocialPostsEvent>(_onGetDailyPosts);
  }

  void getDailyPosts(DateTime date) => add(GetDailySocialPostsEvent(date));

  Future<void> _onGetDailyPosts(
    GetDailySocialPostsEvent event,
    Emitter<SocialState> emit,
  ) async {
    try {
      emit(LoadingSocialState());
      final posts = await socialRepository.getDailyPosts(event.date);
      emit(posts.isEmpty ? EmptySocialState() : ResultSocialState(posts));
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      emit(ErrorSocialState(e.toString()));
    }
  }
}
