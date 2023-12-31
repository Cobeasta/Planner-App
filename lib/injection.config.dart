// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'taskList/TaskListViewModel.dart' as _i6;
import 'taskList/TaskRepository.dart' as _i5;
import 'taskList/TaskService.dart' as _i3;
import 'ViewModelFactory.dart' as _i4;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i3.TaskService>(() => _i3.TaskService());
  gh.singleton<_i4.ViewModelFactory>(_i4.ViewModelFactoryImpl());
  gh.factory<_i5.TaskRepository>(
      () => _i5.TaskRepository(gh<_i3.TaskService>()));
  gh.factory<_i6.TaskListViewModel>(
      () => _i6.TaskListViewModel(gh<_i5.TaskRepository>()));
  return getIt;
}
