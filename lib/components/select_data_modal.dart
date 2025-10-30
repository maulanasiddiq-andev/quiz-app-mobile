import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/notifiers/select_data_notifier.dart';

class SelectDataModal extends ConsumerStatefulWidget {
  final String data;
  const SelectDataModal({super.key, required this.data});

  @override
  ConsumerState<SelectDataModal> createState() => _SelectDataModalState();
}

class _SelectDataModalState extends ConsumerState<SelectDataModal> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(selectDataProvider(widget.data));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.isLoading) 
              Center(child: CircularProgressIndicator())
            else
              ListView(
                shrinkWrap: true,
                children: [
                  ...state.datas.map((data) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop(data);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          data.name,
                          style: TextStyle(
                            fontSize: 16
                          ),  
                        ),
                      ),
                    );
                  })
                ],
              )
          ],
        ),
      ),
    );
  }
}