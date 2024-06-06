import 'package:flutter/material.dart';

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample(
      {super.key, required this.listPayment, this.onSelected});
  final List<String> listPayment;
  final Function(String?)? onSelected;

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    return DropdownMenu<String>(
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
      width: sizeWidth * 0.32,
      initialSelection: widget.listPayment.first,
      onSelected: widget.onSelected,
      dropdownMenuEntries:
          widget.listPayment.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
