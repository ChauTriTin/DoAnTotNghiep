import 'package:flutter/material.dart';

import '../common/const/color_constants.dart';
import '../common/const/dimen_constants.dart';

/**
 * Created by Loitp on 08,August,2022
 * Galaxy One company,
 * Vietnam
 * +840766040293
 * freuss47@gmail.com
 */
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
  });

  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      key: widget.fieldKey,
      obscureText: _obscureText,
      maxLength: 8,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorConstants.focusBorderTextInputColor,
            width: 1.0,
          ),
          borderRadius:
              BorderRadius.circular(DimenConstants.radiusLoginBtnRound),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorConstants.borderTextInputColor,
            width: 1.0,
          ),
          borderRadius:
              BorderRadius.circular(DimenConstants.radiusLoginBtnRound),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorConstants.borderTextInputColor,
            width: 1.0,
          ),
          borderRadius:
              BorderRadius.circular(DimenConstants.radiusLoginBtnRound),
        ),
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
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: ColorConstants.colorWhite,),
        ),
      ),
    );
  }
}
