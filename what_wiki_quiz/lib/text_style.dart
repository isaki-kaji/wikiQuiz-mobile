import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleFont extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fWeight;
  TitleFont(this.text, this.size, this.fWeight);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: GoogleFonts.hinaMincho(fontSize: size, fontWeight: fWeight),
      ),
    );
  }
}

class ButtonFont extends StatelessWidget {
  final String text;
  ButtonFont(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.hinaMincho(fontSize: 30, color: Colors.white),
    );
  }
}

var numberStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
var scoreStyle = GoogleFonts.hinaMincho(
    fontSize: 140, fontWeight: FontWeight.bold, color: Colors.purple);
