import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/notifiers/auth_notifier.dart';

class CheckModuleComponent extends ConsumerStatefulWidget {
  final Widget child;
  final List<String> moduleNames;
  const CheckModuleComponent({super.key, required this.child, required this.moduleNames});

  @override
  ConsumerState<CheckModuleComponent> createState() => _CheckModuleComponentState();
}

class _CheckModuleComponentState extends ConsumerState<CheckModuleComponent> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    final modules = state.token?.user?.role?.roleModules;

    return modules != null && widget.moduleNames.every((moduleName) => modules.any((module) => module.roleModuleName == moduleName))
      ? widget.child
      : SizedBox.shrink();
  }
}