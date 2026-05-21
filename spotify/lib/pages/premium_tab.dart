import 'package:flutter/material.dart';

class PremiumTab extends StatefulWidget {
  const PremiumTab({super.key});
  @override
  State<PremiumTab> createState() => _PremiumTabState();
}

class _PremiumTabState extends State<PremiumTab> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Text("Premium Tab", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
    );
  }
}