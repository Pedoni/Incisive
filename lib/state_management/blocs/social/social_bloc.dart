import 'package:bloc/bloc.dart';
import 'package:incisive/log/main_logger.dart';
import 'package:incisive/repositories/social_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'social_event.dart';

class SocialBloc extends BaseBloc {
  final SocialRepository socialRepository;

  SocialBloc({required this.socialRepository}) : super(Initial()) {
    on<GetDailySocialPostsEvent>(_onGetDailyPosts);
  }

  void getDailyPosts(DateTime date) => add(GetDailySocialPostsEvent(date));

  Future<void> _onGetDailyPosts(
    GetDailySocialPostsEvent event,
    Emitter<BaseState> emit,
  ) async {
    try {
      emit(Loading());
      final posts = await socialRepository.getDailyPosts(event.date);
      posts.removeWhere((p) => !p.visible);
      emit(posts.isEmpty ? Empty() : Success(posts));
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      emit(Error(e.toString()));
    }
  }
}
