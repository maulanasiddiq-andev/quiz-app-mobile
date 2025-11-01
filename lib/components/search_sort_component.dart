import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_app/constants/sort_dir_constant.dart';

class SearchSortComponent extends StatefulWidget {
  final String feature;
  final String sortDir;
  final String search;
  final Function(String value) onSearchChanged;
  final Function(String value) onSortDirChanged;
  const SearchSortComponent({
    super.key,
    required this.feature,
    required this.search,
    required this.sortDir,
    required this.onSearchChanged,
    required this.onSortDirChanged
  });

  @override
  State<SearchSortComponent> createState() => _SearchSortComponentState();
}

class _SearchSortComponentState extends State<SearchSortComponent> {
  final TextEditingController searchController = TextEditingController();
  // for searching pause
  Timer? debounce;

  @override
  void initState() {
    searchController.text = widget.search;
    super.initState();
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: colors.onSurface),
                borderRadius: BorderRadius.circular(10)
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  if (debounce?.isActive ?? false) debounce!.cancel();

                  // Start a new 1-second timer
                  debounce = Timer(const Duration(seconds: 1), () async {
                    widget.onSearchChanged(value);
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: "Cari ${widget.feature}"
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (widget.sortDir == SortDirConstant.asc) {
                widget.onSortDirChanged(SortDirConstant.desc);
              } else {
                widget.onSortDirChanged(SortDirConstant.asc);
              }
            }, 
            icon: Icon(
              widget.sortDir == SortDirConstant.asc
                ? Icons.arrow_upward
                : Icons.arrow_downward
            )
          )
        ],
      ),
    );
  }
}