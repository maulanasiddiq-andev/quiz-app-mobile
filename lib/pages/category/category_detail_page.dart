import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/constants/action_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/notifiers/category/category_detail_notifier.dart';

class CategoryDetailPage extends ConsumerStatefulWidget {
  final String categoryId;
  const CategoryDetailPage({super.key, required this.categoryId});

  @override
  ConsumerState<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends ConsumerState<CategoryDetailPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(categoryDetailProvider.notifier).getCategoryById(widget.categoryId);
    });

  }
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(categoryDetailProvider);

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Detail Kategori"),
      body: state.isLoading || state.category == null
      ? Center(
          child: CircularProgressIndicator(color: colors.primary),
        )
      : Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 15,
                      children: [
                        Text(
                          state.category!.name,
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                        Text(
                          state.category!.description,
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButtonComponent(
                onTap: () {
                  context.push("/${ResourceConstant.category}/${ActionConstant.edit}/${widget.categoryId}");
                }, 
                text: "Edit"
              ),
            )
          ],
        ),
    );
  }
}