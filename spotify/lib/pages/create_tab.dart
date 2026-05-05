import 'package:flutter/material.dart';

class CreateTab extends StatefulWidget {
  const CreateTab({super.key});
  @override
  State<CreateTab> createState() => _CreateTabState();
}

class _CreateTabState extends State<CreateTab> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Text("Create Tab", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
    );
  }
}