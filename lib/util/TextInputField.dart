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
    this.onChange,
    this.initalText,
    this.backgroundColor,
    this.textColor,
    this.isDisable,
    this.onTap,
    this.controller,
  });

  final Key? fieldKey;
  final TextInputType? keyboardType;
  final String? labelText;
  final bool? isDisable;
  final String? initalText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final Color? backgroundColor;
  final Color? textColor;
  final ValueChanged<String>? onChange;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final GestureTapCallback? onTap;
  final TextEditingController? controller;

  @override
  _TextInputField createState() => _TextInputField();
}

class _TextInputField extends BaseStatefulState<TextInputField> {
  @override
  Widget build(BuildContext context) {
    if (widget.onTap != null) {
      return GestureDetector(onTap: widget.onTap, child: getTextEditField());
    } else {
      return getTextEditField();
    }
  }

  Widget getTextEditField() {
    return TextFormField(
      controller: widget.controller,
      enabled: !(widget.isDisable ?? false),
      // readOnly: !(widget.isDisable ?? false) ,
      style: TextStyle(color: widget.textColor ?? Colors.white),
      key: widget.fieldKey,
      onSaved: widget.onSaved,
      initialValue: widget.initalText,
      onChanged: widget.onChange,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
          errorMaxLines: 3,
          focusedBorder:
              UIUtils.getOutlineFocus(ColorConstants.focusBorderTextInputColor),
          enabledBorder:
              UIUtils.getOutlineFocus(ColorConstants.borderTextInputColor),
          errorBorder:
              UIUtils.getOutlineFocus(ColorConstants.errorBorderTextInputColor),
          border: UIUtils.getOutlineFocus(ColorConstants.borderTextInputColor),
          errorStyle:
              TextStyle(color: ColorConstants.errorBorderTextInputColor),
          filled: true,
          // errorStyle: ,
          hintStyle: TextStyle(color: ColorConstants.textEditBgColor),
          fillColor: widget.backgroundColor ?? ColorConstants.textEditBgColor),
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
