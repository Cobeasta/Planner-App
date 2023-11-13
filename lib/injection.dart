import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import './injection.config.dart';
final getIt = GetIt.I;

@InjectableInit(
  initializerName: 'initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void initializeGetIt() {
  initGetIt(getIt);
}
