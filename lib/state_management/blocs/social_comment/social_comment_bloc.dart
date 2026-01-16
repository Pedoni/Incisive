import 'package:bloc/bloc.dart';
import 'package:incisive/log/main_logger.dart';
import 'package:incisive/repositories/social_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'social_comment_event.dart';

class SocialCommentBloc extends BaseBloc {
  final SocialRepository socialRepository;

  SocialCommentBloc({required this.socialRepository}) : super(Initial()) {
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
    Emitter<BaseState> emit,
  ) async {
    try {
      emit(Loading());

      final comments = await socialRepository.getCommentsForPost(
        postId: event.postId,
      );

      emit(
        comments.isEmpty ? Empty() : Success(comments),
      );
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      emit(Error(e.toString()));
    }
  }

  Future<void> _onCreateComment(
    CreateCommentEvent event,
    Emitter<BaseState> emit,
  ) async {
    try {
      emit(Loading());

      await socialRepository.createComment(
        postId: event.postId,
        content: event.content,
      );

      final comments = await socialRepository.getCommentsForPost(
        postId: event.postId,
      );

      emit(
        comments.isEmpty ? Empty() : Success(comments),
      );
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      emit(Error(e.toString()));
    }
  }

  Future<void> _onApproveComment(
    ApproveCommentEvent event,
    Emitter<BaseState> emit,
  ) async {
    try {
      emit(Loading());

      await socialRepository.approveComment(
        commentId: event.commentId,
      );

      final comments = await socialRepository.getCommentsForPost(
        postId: event.postId,
      );

      emit(
        comments.isEmpty ? Empty() : Success(comments),
      );
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      emit(Error(e.toString()));
    }
  }

  Future<void> _onRejectComment(
    RejectCommentEvent event,
    Emitter<BaseState> emit,
  ) async {
    try {
      emit(Loading());

      await socialRepository.rejectComment(commentId: event.commentId);

      final comments = await socialRepository.getCommentsForPost(postId: event.postId);

      emit(
        comments.isEmpty ? Empty() : Success(comments),
      );
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      emit(Error(e.toString()));
    }
  }

  Future<void> _onVoteComment(
    VoteCommentEvent event,
    Emitter<BaseState> emit,
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

      emit(Success(comments));
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      emit(Error(e.toString()));
    }
  }
}
