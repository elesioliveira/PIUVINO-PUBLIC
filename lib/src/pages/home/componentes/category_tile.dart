import 'package:flutter/material.dart';
import 'package:piu_vino/src/config/custom_colors.dart';

class CategoryTile extends StatefulWidget {
  const CategoryTile({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onPressed,
  });

  final String category;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.isSelected
                ? CustomColors.primaryColor
                : Colors.transparent,
          ),
          child: Text(
            widget.category,
            style: TextStyle(
              color: widget.isSelected
                  ? Colors.white
                  : CustomColors.segundaryColor,
              fontWeight: FontWeight.bold,
              fontSize: widget.isSelected ? 16 : 14,
            ),
          ),
        ),
      ),
    );
  }
}
