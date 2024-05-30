import 'package:flutter/material.dart';
import 'package:cunty/src/imports.dart';

class MessengerPage extends StatefulWidget {
  const MessengerPage({super.key});

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
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
            child: const Text('Add'),
          ),
          TextButton(
            onPressed: () {
              updateList();
              setState(() {});
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: updateList,
            child: const Text('Update List'),
          ),
        ],
      ),
    );
  }
}
