import 'package:flutter/material.dart';
import 'select_chips_screen.dart';


Future<List<ChipData>?> showSelectChipsScreen({
  required BuildContext context,
  required List<ChipData> chipDataList,
  required List<String> alreadySelectedChips,
  required int maxChips,
}) async {
  return await showModalBottomSheet<List<ChipData>>(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(50),
      ),
    ),
    builder: (BuildContext context) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SelectChipsScreen(
            //title: title,
            chipDataList: chipDataList,
            selectedChipsLabels: alreadySelectedChips,
            onDone: (selectedChips) {
              Navigator.of(context).pop(selectedChips);
            },
            maxChips: maxChips,
          ),
        ),
      );
    },
  );
}