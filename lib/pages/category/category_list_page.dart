import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/confirm_dialog.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/search_sort_component.dart';
import 'package:quiz_app/constants/action_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/notifiers/category/category_list_notifier.dart';

class CategoryListPage extends ConsumerStatefulWidget {
  const CategoryListPage({super.key});

  @override
  ConsumerState<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends ConsumerState<CategoryListPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) {
        final notifier = ref.read(categoryListProvider.notifier);
        notifier.loadMoreDatas();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<bool> confirmDelete(String name) async {
    final result = confirmDialog(
      context: context, 
      title: "Perhatian", 
      content: "Apakah anda yakin ingin menghapus kategori $name?"
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryListProvider);
    final notifier = ref.read(categoryListProvider.notifier);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Daftar Kategori"),
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
                physics: AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                  children: [
                    ...state.categories.map((category) {
                      return GestureDetector(
                        onTap: () {
                          context.push("/${ResourceConstant.category}/${ActionConstant.detail}/${category.categoryId}");
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
                                if (category.isMain)
                                  Icon(Icons.check, color: Colors.green),
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
                            subtitle: Text(
                              category.description.isEmpty
                                ? "-"
                                : category.description
                            ),
                            trailing: PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) async {
                                switch (value) {
                                  case 'view':
                                    context.push("/${ResourceConstant.category}/${ActionConstant.detail}/${category.categoryId}");
                                    break;
                                  case 'edit':
                                    final result = await context.push("/${ResourceConstant.category}/${ActionConstant.edit}/${category.categoryId}");
                  
                                    if (result != null && result == true) {
                                      notifier.refreshCategories();
                                    }
                                    break;
                                  case 'delete':
                                    // handle delete action
                                    final result = await confirmDelete(category.name);

                                    if (result == true) {
                                      notifier.deleteCategory(category.categoryId);
                                    }
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
                    }),
                    if (state.isLoadingMore)
                      Center(
                        child: CircularProgressIndicator(
                          color: colors.primary,
                        ),
                      )
                  ],
                )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "categoryFab",
        onPressed: () async {
          final result = await context.push("/${ResourceConstant.category}/${ActionConstant.create}");

          if (result != null && result == true) {
            notifier.refreshCategories();
          }
        },
        child: Icon(Icons.create),
      ),
    );
  }
}