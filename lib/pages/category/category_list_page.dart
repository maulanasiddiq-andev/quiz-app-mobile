import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/search_sort_component.dart';
import 'package:quiz_app/notifiers/category/category_list_notifier.dart';
import 'package:quiz_app/pages/category/category_add_page.dart';
import 'package:quiz_app/pages/category/category_detail_page.dart';
import 'package:quiz_app/pages/category/category_edit_page.dart';

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
            SizedBox(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colors.onSurface
                  )
                )
              ),
              child: SearchSortComponent(
                feature: "kategori",
                search: state.search, 
                sortDir: state.sortDir, 
                onSearchChanged: (value) {
                  notifier.searchCategories(value);
                },
                onSortDirChanged: (value) {
                  notifier.changeSortDir(value);
                },
              ),
            ),
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
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: colors.onSurface
                              )
                            )
                          ),
                          child: ListTile(
                            title: Row(
                              spacing: 10,
                              children: [
                                Text(category.name),
                                if (state.deletedCategoryId == category.categoryId)
                                  SizedBox(
                                    height: 14,
                                    width: 14,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: colors.primary,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) async {
                                switch (value) {
                                  case 'view':
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => CategoryDetailPage(categoryId: category.categoryId))
                                    );
                                    break;
                                  case 'edit':
                                    final result = await Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => CategoryEditPage(category: category))
                                    );
                  
                                    if (result != null && result == true) {
                                      notifier.refreshCategories();
                                    }
                                    break;
                                  case 'delete':
                                    // handle delete action
                                    notifier.deleteCategory(category.categoryId);
                                    break;
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: Text('Lihat Detail'),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Hapus'),
                                ),
                              ],
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