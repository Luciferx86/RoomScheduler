import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class DefTextFormField extends FormField<String> {
  final String fieldName;
  final TextInputType inputType;
  final Icon icon;
  final Function onTap;
  final bool showLoader;
  final Function onChanged;
  final int maxLength;
  final String iniValue;
  final bool readOnly;
  final bool explicitReadOnly;
  final TextEditingController controller;
  final bool removePadding;
  final FocusNode focusNode;
  final List<TextInputFormatter> inputFormatters;
  final TextCapitalization capitalization;
  final String initialFill;

  DefTextFormField({
    this.fieldName,
    this.icon,
    this.inputType,
    this.onTap,
    this.controller,
    this.showLoader = false,
    this.onChanged,
    this.maxLength,
    this.iniValue,
    this.focusNode,
    this.inputFormatters,
    this.readOnly = false,
    this.explicitReadOnly,
    this.capitalization = TextCapitalization.none,
    this.removePadding,
    this.initialFill,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    bool autoValidate = false,
  }) : super(
          builder: (FormFieldState<String> state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextFormField(
                focusNode: focusNode,
                inputFormatters: inputFormatters,
                textCapitalization: capitalization,
                initialValue: iniValue,
                readOnly: readOnly,
                maxLength: maxLength,
                onChanged: onChanged,
                controller: controller,
                onTap: onTap,
                autovalidate: autoValidate,
                keyboardType: inputType,
                validator: validator,
                onSaved: onSaved,
                autofocus: false,
                style: TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  suffix: Visibility(
                    visible: showLoader,
                    child: Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  labelText: fieldName,
                  prefixIcon: icon ?? null,
                ),
              ),
            );
          },
        );
}
