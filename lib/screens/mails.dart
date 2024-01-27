import 'package:cunty/src/imports.dart';

class Mails extends StatefulWidget {
  const Mails({super.key});

  static const String route = '/mails';

  @override
  State<Mails> createState() => _MailsState();
}

class _MailsState extends State<Mails> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Mails'));
  }
}
