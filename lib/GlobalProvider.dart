

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:org_app/ViewModelFactory.dart';
import 'package:provider/provider.dart';

import 'injection.dart';

class GlobalProvider extends StatelessWidget {
  const GlobalProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: getIt.get<ViewModelFactory>()),
      ],
      child: child,
    );
  }
}