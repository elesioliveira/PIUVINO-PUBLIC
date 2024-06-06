// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piu_vino/src/config/custom_colors.dart';

class CustomTextField extends StatefulWidget {
  IconData? icon;
  final String label;
  final bool isSecret;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool readOnly;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final GlobalKey<FormFieldState>? formFieldKey;
  final bool styleLabe;
  final double? borderRadius;

  CustomTextField({
    super.key,
    this.icon,
    required this.label,
    this.isSecret = false,
    this.inputFormatters,
    this.initialValue,
    this.readOnly = false,
    this.validator,
    this.onSaved,
    this.controller,
    this.textInputType,
    this.formFieldKey,
    this.styleLabe = false,
    this.borderRadius,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool isObscure;

  @override
  void initState() {
    super.initState();

    isObscure = widget.isSecret;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.formFieldKey,
      controller: widget.controller,
      readOnly: widget.readOnly,
      initialValue: widget.initialValue,
      inputFormatters: widget.inputFormatters,
      obscureText: isObscure,
      validator: widget.validator,
      onSaved: widget.onSaved,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        focusColor: CustomColors.primaryColor,

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: CustomColors
                .primaryColor, // Cor da borda quando o TextField está focado
          ),
        ),

        // prefixIcon: Icon(widget.icon),
        labelStyle: widget.styleLabe
            ? null
            : TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w400,
              ),
        suffixIcon: widget.isSecret
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
              )
            : null,
        labelText: widget.label,

        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? 8,
          ),
        ),
      ),
    );
  }
}
