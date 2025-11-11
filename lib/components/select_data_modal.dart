import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/search_sort_component.dart';
import 'package:quiz_app/notifiers/select_data_notifier.dart';

class SelectDataModal extends ConsumerStatefulWidget {
  final String data;
  const SelectDataModal({super.key, required this.data});

  @override
  ConsumerState<SelectDataModal> createState() => _SelectDataModalState();
}

class _SelectDataModalState extends ConsumerState<SelectDataModal> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) {
        final notifier = ref.read(selectDataProvider(widget.data).notifier);
        notifier.loadMoreDatas();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(selectDataProvider(widget.data));
    final colors = Theme.of(context).colorScheme;
    final notifier = ref.read(selectDataProvider(widget.data).notifier);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colors.onSurface)
              )
            ),
            child: Text(
              "Pilih ${widget.data}",
              style: TextStyle(
                fontSize: 16
              ),
            ),
          ),
          SizedBox(height: 10),
          SearchSortComponent(
            feature: widget.data, 
            search: state.search, 
            sortDir: state.sortDir, 
            onSearchChanged: (value) {
              notifier.searchDatas(value);
            }, 
            onSortDirChanged: (value) {
              notifier.changeSortDir(value);
            }
          ),
          if (state.isLoading) 
            Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: ListView(
                shrinkWrap: true,
                controller: scrollController,
                children: [
                  ...state.datas.map((data) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop(data);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        // decoration: BoxDecoration(
                        //   border: Border(
                        //     bottom: BorderSide(color: colors.onSurface)
                        //   )
                        // ),
                        child: Text(
                          data.name,
                          style: TextStyle(
                            fontSize: 16
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
              ),
            )
        ],
      ),
    );
  }
}