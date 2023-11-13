import 'package:flutter/material.dart';
import 'package:org_app/TaskList.dart';
import 'package:provider/provider.dart';

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<TaskListData, bool>(
      selector: (_, data) => data.showLoading,
      builder: (context, showLoading, _) => Visibility(
        visible: showLoading,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}