import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:org_app/injection.dart';

import 'ViewModel.dart';

abstract class ViewModelFactory {
  T create<T extends ViewModel>();
}

@Singleton(as: ViewModelFactory)
class ViewModelFactoryImpl implements ViewModelFactory {
  @override
  T create<T extends ViewModel>() => getIt.get<T>();
}