import 'package:cunty/src/imports.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class MessengerPage extends StatefulWidget {
  const MessengerPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MessengerPageState createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  List<MessageModel> values = [];

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Message',
              ),
              controller: _controller,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        final String message = _controller.text;
                        values.add(MessageModel(
                            id: const Uuid().v8(),
                            senderId: '1',
                            receiverId: '2',
                            type: 'test',
                            message: message,
                            time: DateTime.now().toString()));
                        _controller.clear();
                      });
                    },
                    child: const Text('Add'),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      values.clear();
                      setState(() {});
                    },
                    child: const Text('Clear'),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Divider(),
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
