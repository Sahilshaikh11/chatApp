import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receverEmail;
  const ChatPage({super.key, required this.receverEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receverEmail),
      ),
    );
  }
}
