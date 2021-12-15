import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 12.0),
      shadowColor: Colors.black,
      primary: Colors.blue,
    ),
    child: buildContent(),
    onPressed: onClicked,
  );

  Widget buildContent() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 20),
      SizedBox(width: 10),
      Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    ],
  );
}
