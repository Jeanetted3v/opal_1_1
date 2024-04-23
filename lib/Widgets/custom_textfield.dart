import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String subTitle;
  final TextEditingController textEditingController;
  final String hintText;
  final TextInputType textInputType;
  final int? maxLines;
  final int? maxLength;
  final maxLengthEnforcement;

  const CustomTextfield({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.textInputType,
    this.maxLines,
    required this.subTitle,
    this.maxLength,
    this.maxLengthEnforcement,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return Column(
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
        TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            fillColor: Colors.white,
            border: inputBorder,
            focusedBorder: inputBorder,
            enabledBorder: inputBorder,
            filled: true,
            contentPadding: const EdgeInsets.all(10),
          ),
          keyboardType: textInputType,
          maxLines: maxLines,
          maxLength: maxLength,
          maxLengthEnforcement: maxLengthEnforcement,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}