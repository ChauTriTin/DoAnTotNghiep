import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:flutter/material.dart';

import '../common/const/color_constants.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.onChange,
  });

  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChange;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends BaseStatefulState<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      key: widget.fieldKey,
      obscureText: _obscureText,
      // maxLength: 30,
      onSaved: widget.onSaved,
      onChanged: widget.onChange,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        errorMaxLines: 3,
        focusedBorder: UIUtils.getOutlineFocus(ColorConstants.focusBorderTextInputColor),
        enabledBorder: UIUtils.getOutlineFocus(ColorConstants.borderTextInputColor),
        errorBorder: UIUtils.getOutlineFocus(ColorConstants.errorBorderTextInputColor),
        border: UIUtils.getOutlineFocus(ColorConstants.borderTextInputColor),
        errorStyle: TextStyle(color: ColorConstants.errorBorderTextInputColor),
        filled: true,
        hintStyle: TextStyle(color: ColorConstants.textEditBgColor),
        hintText: widget.hintText,
        fillColor: ColorConstants.textEditBgColor,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: ColorConstants.colorWhite,
          ),
        ),
      ),
    );
  }
}
