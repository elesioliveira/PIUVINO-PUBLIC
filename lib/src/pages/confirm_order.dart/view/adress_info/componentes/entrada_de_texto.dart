import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piu_vino/src/config/custom_colors.dart';

class EntradaTextoAdress extends StatefulWidget {
  const EntradaTextoAdress(
      {super.key,
      required this.label,
      this.width,
      this.onChanged,
      this.checkTextField = false,
      this.textEditingController,
      this.validator,
      this.searchCep,
      this.inputFormatters});
  final String label;
  final double? width;
  final void Function(String)? onChanged;
  final bool checkTextField;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  final Function()? searchCep;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<EntradaTextoAdress> createState() => _EntradaTextoAdressState();
}

class _EntradaTextoAdressState extends State<EntradaTextoAdress> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.textEditingController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextFormField(
        maxLines: 1,
        inputFormatters: widget.inputFormatters,
        validator: widget.validator,
        controller: widget.textEditingController,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            label: Text(
              widget.label,
              style: const TextStyle(color: Colors.black),
            ),
            suffixIcon: widget.checkTextField
                ? Material(
                    child: InkWell(
                      onTap: widget.searchCep,
                      splashColor: CustomColors.segundaryColor,
                      child: Ink(
                        child: const Icon(
                          CupertinoIcons.info_circle,
                        ),
                      ),
                    ),
                  )
                : null,
            fillColor: Colors.white,
            filled: true),
      ),
    );
  }
}
