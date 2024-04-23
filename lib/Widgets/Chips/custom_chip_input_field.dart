import 'package:flutter/material.dart';

class CustomChipInputField extends StatelessWidget {
  final VoidCallback onTap;
  final String subTitle;
  final String hintText;
  final List<String> selectedChips;

  CustomChipInputField({
    required this.onTap,
    required this.subTitle,
    required this.hintText,
    required this.selectedChips,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            subTitle.toUpperCase(),
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    if (selectedChips.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          hintText,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 16,
                          ),
                        ),
                      ),

                    //Selected Chips into Labels only
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          selectedChips.join(', '),
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

//If using Chips:
                    // Expanded(
                    //   child: Wrap(
                    //     alignment: WrapAlignment.start,
                    //     spacing: 5,
                    //     children: selectedChips
                    //         .map((chip) => Text(
                    //               chip,
                    //               style: TextStyle(
                    //                   color: Colors.grey.shade600,
                    //                   fontSize: 16),
                    //             ))
                    //         .toList(),
                    //   ),
                    // ),