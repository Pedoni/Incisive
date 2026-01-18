import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/mappers/diary_mapper.dart';
import 'package:incisive/mappers/dto/diary_dto.dart';
import 'package:incisive/models/diary_model.dart';
import 'package:incisive/repositories/breathing_repository.dart';
import 'package:incisive/repositories/diary_repository.dart';
import 'package:incisive/repositories/gratitude_repository.dart';
import 'package:incisive/repositories/login_repository.dart';
import 'package:incisive/repositories/social_repository.dart';
import 'package:incisive/repositories/user_repository.dart';
import 'package:incisive/source/remote/breathing_service.dart';
import 'package:incisive/source/remote/diary_service.dart';
import 'package:incisive/source/remote/gratitude_service.dart';
import 'package:incisive/source/remote/login_service.dart';
import 'package:incisive/source/remote/social_service.dart';
import 'package:incisive/source/remote/user_service.dart';
import 'package:incisive/state_management/blocs/breathing/breathing_bloc.dart';
import 'package:incisive/state_management/blocs/comment_post/comment_post_bloc.dart';
import 'package:incisive/state_management/blocs/create_post/create_post_bloc.dart';
import 'package:incisive/state_management/blocs/diary_page/diary_page_bloc.dart';
import 'package:incisive/state_management/blocs/gratitude_page/gratitude_page_bloc.dart';
import 'package:incisive/state_management/blocs/gratitude_upsert/gratitude_upsert_bloc.dart';
import 'package:incisive/state_management/blocs/login/login_bloc.dart';
import 'package:incisive/state_management/blocs/mood_tracker/mood_tracker_bloc.dart';
import 'package:incisive/state_management/blocs/profile/profile_bloc.dart';
import 'package:incisive/state_management/blocs/register/register_bloc.dart';
import 'package:incisive/state_management/blocs/social/social_bloc.dart';
import 'package:incisive/state_management/blocs/social_comment/social_comment_bloc.dart';
import 'package:incisive/state_management/blocs/upsert_page/upsert_page_bloc.dart';
import 'package:pine/di/dependency_injector_helper.dart';
import 'package:pine/utils/dto_mapper.dart';
import 'package:provider/provider.dart';

import 'package:provider/single_child_widget.dart';

part 'blocs.dart';
part 'mappers.dart';
part 'providers.dart';
part 'repositories.dart';

class DependencyInjector extends StatelessWidget {
  final Widget child;

  const DependencyInjector({super.key, required this.child});

  @override
  Widget build(BuildContext context) => DependencyInjectorHelper(
    blocs: _blocs,
    providers: _providers,
    mappers: _mappers,
    repositories: _repositories,
    child: child,
  );
}
