import 'package:flutter/material.dart';

class MyRow extends StatefulWidget {
  const MyRow({
    super.key,
    required this.projectName,
    required this.projectValue,
    required this.icon,
    required this.iconColor,
    required this.textColor,
  });

  final String projectName;
  final String projectValue;
  final Icon icon;
  final Color iconColor;
  final Color textColor;

  @override
  State<MyRow> createState() => _MyRowState();
}

class _MyRowState extends State<MyRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.projectName,
          style: const TextStyle(
            fontFamily: 'mytwo',
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        Row(
          children: [
            Icon(
              widget.icon.icon,
              color: widget.iconColor,
              size: widget.icon.size,
            ),
            Text(
              widget.projectValue,
              style: TextStyle(
                color: widget.textColor,
                fontFamily: 'mytwo',
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
