import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/notifiers/admin/role/role_detail_notifier.dart';

class RoleDetailPage extends ConsumerStatefulWidget {
  final String roleId;
  const RoleDetailPage({super.key, required this.roleId});

  @override
  ConsumerState<RoleDetailPage> createState() => _RoleDetailPageState();
}

class _RoleDetailPageState extends ConsumerState<RoleDetailPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(roleDetailProvider.notifier).getRoleById(widget.roleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(roleDetailProvider);

    return Scaffold(
      appBar: customAppbarComponent(
        "Detail User",
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary
      ),
      body: state.isLoading || state.role == null
      ? Center(
          child: CircularProgressIndicator(color: colors.primary),
        )
      : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                spacing: 15,
                children: [
                  Text(
                    state.role!.name,
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  Text(
                    state.role!.description,
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}