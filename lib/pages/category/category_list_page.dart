import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/notifiers/category/category_list_notifier.dart';
import 'package:quiz_app/pages/category/category_add_page.dart';
import 'package:quiz_app/pages/category/category_detail_page.dart';

class CategoryListPage extends ConsumerStatefulWidget {
  const CategoryListPage({super.key});

  @override
  ConsumerState<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends ConsumerState<CategoryListPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryListProvider);
    final notifier = ref.read(categoryListProvider.notifier);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: customAppbarComponent(
        "Kategori",
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CategoryAddPage())
              );

              if (result != null && result == true) {
                notifier.refreshCategories();
              }
            }, 
            icon: Icon(Icons.add)
          )
        ]
      ),
      body: RefreshIndicator(
        onRefresh: () => notifier.refreshCategories(),
        child: Column(
          children: [
            Expanded(
              child: state.isLoading
              ? Center(
                  child: CircularProgressIndicator(color: colors.primary),
                )
              : ListView(
                  children: [
                    ...state.categories.map((category) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => CategoryDetailPage(categoryId: category.categoryId))
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: colors.onSurface
                              )
                            )
                          ),
                          child: Text(
                            category.name,
                            style: TextStyle(
                              fontSize: 16
                            ),  
                          ),
                        ),
                      );
                    })
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}