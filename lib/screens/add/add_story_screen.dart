import 'package:flutter/material.dart';

class AddStoryScreen extends StatelessWidget {
  const AddStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Story"), centerTitle: true),
      body: const Center(
        child: Text("Add Story Screen", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
