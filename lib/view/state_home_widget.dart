import 'package:flutter/material.dart';

class StateHomeWidget extends StatelessWidget {
  const StateHomeWidget(
      {super.key,
      required this.isChoose,
      required this.icon,
      required this.text,
      required this.onPress});

  final bool isChoose;
  final Icon icon;
  final String text;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 12),
      width: MediaQuery.of(context).size.width * 0.28,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          backgroundColor: isChoose ? Colors.redAccent : Colors.white10,
          //<-- SEE HERE
          side: const BorderSide(width: 2, color: Colors.black),
        ),
        onPressed: onPress,
        icon: icon,
        label: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 10),
        ),
      ),
    );
  }
}
