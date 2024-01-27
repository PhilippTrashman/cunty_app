import 'package:cunty/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:cunty/src/imports.dart';
import 'package:hive/hive.dart';


class MessengerPage extends StatefulWidget {
  const MessengerPage({super.key});

  @override
  _MessengerPageState createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  List<MessageModel> values = [];
  late Box<MessageModel> taskBox;

  @override
  void initState() {
    super.initState();
    
    openBox();
  }

  Future openBox() async {
    taskBox = await Hive.openBox<MessageModel>('tasks');
    updateList();
  }

  void updateList() {
    setState(() {
      values = taskBox.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                taskBox.add(MessageModel(type: 'test', message: 'hello', time: DateTime.now().toString()));
                updateList();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                taskBox.clear();
                updateList();
                setState(() {
                  
                });
              },
              child: Text('Clear'),
            ),
            TextButton(
              onPressed: updateList,
              child: Text('Update List'),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(values[index].message),
                    subtitle: Text(values[index].time),
                  );
                },
                itemCount: values.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
