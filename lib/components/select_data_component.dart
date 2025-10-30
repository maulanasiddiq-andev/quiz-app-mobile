import 'package:flutter/material.dart';
import 'package:quiz_app/components/select_data_modal.dart';
import 'package:quiz_app/models/select_data_model.dart';

class SelectDataComponent extends StatefulWidget {
  final String title;
  final String data;
  final Function(SelectDataModel value) onSelected;
  final SelectDataModel? selectedData;
  const SelectDataComponent({
    super.key,
    required this.title,
    required this.data,
    required this.onSelected,
    this.selectedData,
  });

  @override
  State<SelectDataComponent> createState() => _SelectDataComponentState();
}

class _SelectDataComponentState extends State<SelectDataComponent> {
  Future<SelectDataModel?> selectDataModal() async {
    SelectDataModel? result = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(child: SelectDataModal(data: widget.data));
      },
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () async {
        SelectDataModel? result = await selectDataModal();

        if (result != null) {
          widget.onSelected(result);
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.onSurface)),
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text(
          widget.selectedData == null
            ? "Pilih ${widget.title}"
            : widget.selectedData!.name, 
          style: TextStyle(fontSize: 16)
        ),
      ),
    );
  }
}
