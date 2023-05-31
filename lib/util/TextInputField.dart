import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:flutter/material.dart';

import '../common/const/color_constants.dart';
import '../common/const/dimen_constants.dart';

class TextInputField extends StatefulWidget {
  const TextInputField({
    super.key,
    this.fieldKey,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.keyboardType,
  });

  final Key? fieldKey;
  final TextInputType? keyboardType;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  _TextInputField createState() => _TextInputField();
}

class _TextInputField extends BaseStatefulState<TextInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      key: widget.fieldKey,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
          errorMaxLines: 3,
          focusedBorder: UIUtils.getOutlineFocus(ColorConstants.focusBorderTextInputColor),
          enabledBorder: UIUtils.getOutlineFocus(ColorConstants.borderTextInputColor),
          errorBorder: UIUtils.getOutlineFocus(ColorConstants.errorBorderTextInputColor),
          border: UIUtils.getOutlineFocus(ColorConstants.borderTextInputColor),
          errorStyle: TextStyle(color: ColorConstants.errorBorderTextInputColor),
          filled: true,
          // errorStyle: ,
          hintStyle: TextStyle(color: ColorConstants.textEditBgColor),
          fillColor: ColorConstants.textEditBgColor),
    );
  }

  InputBorder getOutlineFocus(Color? outLineColor) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: outLineColor ?? ColorConstants.borderTextInputColor,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(DimenConstants.radiusLoginBtnRound),
    );
  }
}
