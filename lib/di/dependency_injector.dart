import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/ui/source/remote/login_service.dart';
import 'package:pine/di/dependency_injector_helper.dart';
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
  Widget build(BuildContext context) =>
      DependencyInjectorHelper(blocs: _blocs, providers: _providers, mappers: _mappers, repositories: _repositories, child: child);
}
