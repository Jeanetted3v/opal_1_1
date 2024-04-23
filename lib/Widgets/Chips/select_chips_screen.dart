import 'package:flutter/material.dart';

class ChipData {
  final String label;
  bool isSelected;

  ChipData({
    required this.label,
    this.isSelected = false,
  });
}

class SelectChipsScreen extends StatefulWidget {
  final List<ChipData> chipDataList;
  final List<String> selectedChipsLabels;
  final Function(List<ChipData> selectedChips) onDone;
  final int maxChips;

  SelectChipsScreen({
    required this.chipDataList,
    required this.onDone,
    required this.selectedChipsLabels,
    required this.maxChips,
  });

  @override
  _SelectChipsScreenState createState() => _SelectChipsScreenState();
}

class _SelectChipsScreenState extends State<SelectChipsScreen> {
  List<ChipData> selectedChips = [];
  List<ChipData> filteredChipDataList = [];
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(searchChips);
    // Select already selected chips
    widget.chipDataList.forEach((chipData) {
      if (widget.selectedChipsLabels.contains(chipData.label)) {
        chipData.isSelected = true;
        selectedChips.add(chipData);
      }
    });
    filteredChipDataList = widget.chipDataList;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchChips() {
    String searchText = searchController.text.toLowerCase();
    if (searchText == '') {
      setState(() {
        filteredChipDataList = widget.chipDataList;
      });
    } else {
      List<ChipData> temp = [];
      for (int i = 0; i < widget.chipDataList.length; i++) {
        ChipData chipData = widget.chipDataList[i];
        if (chipData.label.toLowerCase().contains(searchText)) {
          temp.add(chipData);
        }
      }
      setState(() {
        filteredChipDataList = temp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        foregroundColor: Colors.grey.shade800,
        elevation: 0,
        toolbarHeight: 50,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Please select'),
            Text(
              "${selectedChips.length}/${widget.maxChips}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.onDone(selectedChips);
              //Navigator.pop(context, selectedChips);
            },
            child: Text("Done", style: TextStyle(color: Colors.grey.shade800)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //SizedBox(height: 3),

            //Selected Chips
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedChips.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: Chip(
                        label: Text(selectedChips[index].label),
                        deleteIcon: Icon(
                          Icons.clear,
                          size: 14,
                        ),
                        onDeleted: () {
                          setState(() {
                            selectedChips[index].isSelected = false;
                            selectedChips.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            //SizedBox(height: 5),

            //Search Bar
            Container(
              height: 40,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search",
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),

            //List of chips
            Expanded(
                child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 5.0,
                runSpacing: -2.0,
                children: filteredChipDataList.map<Widget>((ChipData chipData) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (!chipData.isSelected &&
                            selectedChips.length >= widget.maxChips) {
                          // Do not select new chip if already 5 chips are selected
                          return;
                        }
                        chipData.isSelected = !chipData.isSelected;
                        if (chipData.isSelected) {
                          selectedChips.add(chipData);
                        } else {
                          selectedChips.remove(chipData);
                        }
                      });
                    },
                    child: Chip(
                      label: Text(chipData.label),
                      backgroundColor: chipData.isSelected
                          ? Colors.red.shade200
                          : Colors.grey.shade300,
                    ),
                  );
                }).toList(),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
