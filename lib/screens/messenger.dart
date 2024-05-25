import 'package:cunty/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:cunty/src/imports.dart';

class MessengerPage extends StatefulWidget {
  const MessengerPage({super.key});

  @override
  _MessengerPageState createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  List<MessageModel> values = [];

  @override
  void initState() {
    super.initState();
  }

  void updateList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              updateList();
            },
            child: Text('Add'),
          ),
          TextButton(
            onPressed: () {
              updateList();
              setState(() {});
            },
            child: Text('Clear'),
          ),
          TextButton(
            onPressed: updateList,
            child: Text('Update List'),
          ),
        ],
      ),
    );
  }
}
