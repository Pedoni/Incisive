import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:incisive/log/main_logger.dart';
import 'package:incisive/models/social_comment_model.dart';
import 'package:incisive/repositories/social_repository.dart';

part 'social_comment_event.dart';
part 'social_comment_state.dart';

class SocialCommentBloc extends Bloc<SocialCommentEvent, SocialCommentState> {
  final SocialRepository socialRepository;

  SocialCommentBloc({required this.socialRepository}) : super(InitSocialCommentState()) {
    on<GetCommentsForPostEvent>(_onGetCommentsForPost);
    on<CreateCommentEvent>(_onCreateComment);
    on<ApproveCommentEvent>(_onApproveComment);
    on<VoteCommentEvent>(_onVoteComment);
    on<RejectCommentEvent>(_onRejectComment);
  }

  void getComments(String postId) => add(GetCommentsForPostEvent(postId));

  void createComment(String postId, String content) => add(CreateCommentEvent(postId, content));

  void approveComment(String commentId, String postId) => add(ApproveCommentEvent(commentId, postId));

  void rejectComment(String commentId, String postId) => add(RejectCommentEvent(commentId, postId));

  void voteComment(String commentId, String postId, bool isUpvote) => add(VoteCommentEvent(commentId, postId, isUpvote));

  Future<void> _onGetCommentsForPost(
    GetCommentsForPostEvent event,
    Emitter<SocialCommentState> emit,
  ) async {
    try {
      emit(LoadingSocialCommentState());

      final comments = await socialRepository.getCommentsForPost(
        postId: event.postId,
      );

      emit(
        comments.isEmpty ? EmptySocialCommentState() : ResultSocialCommentState(comments),
      );
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      emit(ErrorSocialCommentState(e.toString()));
    }
  }

  Future<void> _onCreateComment(
    CreateCommentEvent event,
    Emitter<SocialCommentState> emit,
  ) async {
    try {
      emit(LoadingSocialCommentState());

      await socialRepository.createComment(
        postId: event.postId,
        content: event.content,
      );

      final comments = await socialRepository.getCommentsForPost(
        postId: event.postId,
      );

      emit(
        comments.isEmpty ? EmptySocialCommentState() : ResultSocialCommentState(comments),
      );
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      emit(ErrorSocialCommentState(e.toString()));
    }
  }

  Future<void> _onApproveComment(
    ApproveCommentEvent event,
    Emitter<SocialCommentState> emit,
  ) async {
    try {
      emit(LoadingSocialCommentState());

      await socialRepository.approveComment(
        commentId: event.commentId,
      );

      final comments = await socialRepository.getCommentsForPost(
        postId: event.postId,
      );

      emit(
        comments.isEmpty ? EmptySocialCommentState() : ResultSocialCommentState(comments),
      );
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      emit(ErrorSocialCommentState(e.toString()));
    }
  }

  Future<void> _onRejectComment(
    RejectCommentEvent event,
    Emitter<SocialCommentState> emit,
  ) async {
    try {
      emit(LoadingSocialCommentState());

      await socialRepository.rejectComment(
        commentId: event.commentId,
      );

      final comments = await socialRepository.getCommentsForPost(
        postId: event.postId,
      );

      emit(
        comments.isEmpty ? EmptySocialCommentState() : ResultSocialCommentState(comments),
      );
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      emit(ErrorSocialCommentState(e.toString()));
    }
  }

  Future<void> _onVoteComment(
    VoteCommentEvent event,
    Emitter<SocialCommentState> emit,
  ) async {
    try {
      // niente loading full-screen per il voto
      await socialRepository.voteComment(
        commentId: event.commentId,
        isUpvote: event.isUpvote,
      );

      final comments = await socialRepository.getCommentsForPost(
        postId: event.postId,
      );

      emit(ResultSocialCommentState(comments));
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      emit(ErrorSocialCommentState(e.toString()));
    }
  }
}
