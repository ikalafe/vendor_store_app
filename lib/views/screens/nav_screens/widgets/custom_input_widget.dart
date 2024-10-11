import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputWidget extends StatelessWidget {
  final FocusNode focusNode;
  final String inputLabel;
  final TextInputFormatter? inputFormatter;
  final int? maxLengthInput;
  final int? maxLinesInput;
  final double? inputWidth;
  final FormFieldValidator validatorForm;
  final ValueChanged onChange;
  final TextInputType? keyboardType;
  const CustomInputWidget({
    super.key,
    required this.focusNode,
    required this.inputLabel,
    this.inputFormatter,
    this.maxLengthInput,
    this.maxLinesInput,
    this.inputWidth,
    required this.validatorForm,
    required this.onChange,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: inputWidth ?? MediaQuery.of(context).size.width,
        child: TextFormField(
          keyboardType: keyboardType,
          onChanged: onChange,
          validator: validatorForm,
          maxLength: maxLengthInput,
          maxLines: maxLinesInput,
          inputFormatters: <TextInputFormatter>[
            inputFormatter ?? FilteringTextInputFormatter.allow(RegExp(r'.*')),
          ],
          focusNode: focusNode,
          decoration: InputDecoration(
            floatingLabelAlignment: FloatingLabelAlignment.start,
            alignLabelWithHint: true,
            labelStyle: TextStyle(
              color: focusNode.hasFocus
                  ? const Color(0xff5796E4)
                  : const Color(0xff0E0E0E),
            ),
            labelText: inputLabel,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                width: 1,
                color: Color(0xff0E0E0E),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xff5796E4),
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
