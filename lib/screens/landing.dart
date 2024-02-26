import 'package:cunty/screens/messenger.dart';
import 'package:cunty/src/imports.dart';
import 'package:cunty/screens/time_table.dart';
import 'package:cunty/screens/mails.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const String route = '/';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  
  @override
  void initState() {
    super.initState();
  }

  bool extended = false;

  var selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedPage) {
      case 0:
        page = const Placeholder(text: 'Home');
        break;
      case 1:
        page = const MessengerPage();
        break;
      case 2:
        page = const Mails();
        break;
      case 3:
        page = const TimeTable();
        break;
      case 4:
        page = const Placeholder(text: 'Calendar');
        break;
      case 5:
        page = const Placeholder(text: 'Settings');
        break;
      default:
        page = const Placeholder(text: 'Info');
    }

    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 450) {
          return Column(
            children: [
              Expanded(
                child: page,
              ),
              SafeArea(
                  child: BottomNavigationBar(
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.chat),
                    label: AppLocalizations.of(context)!.messenger,
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.mail),
                    label: 'Mail',
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.calendar_view_week),
                    label: AppLocalizations.of(context)!.timeTable,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.event),
                    label: AppLocalizations.of(context)!.calendar,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.info),
                    label: AppLocalizations.of(context)!.settings,
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.info),
                    label: 'Info',
                  ),
                ],
                currentIndex: selectedPage,
                onTap: (int index) {
                  setState(() {
                    selectedPage = index;
                  });
                },
              ))
            ],
          );
        } else {
          return Row(
            children: [
              SafeArea(
                  child: NavigationRail(
                extended: extended,
                destinations: [
                  const NavigationRailDestination(
                    icon: Icon(Icons.menu),
                    label: Text(''),
                  ),
                  const NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.chat),
                    label: Text(AppLocalizations.of(context)!.messenger),
                  ),
                  const NavigationRailDestination(
                    icon: Icon(Icons.mail),
                    label: Text('Mail'),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.calendar_view_week),
                    label: Text(AppLocalizations.of(context)!.timeTable),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.event),
                    label: Text(AppLocalizations.of(context)!.calendar),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.settings),
                    label: Text(AppLocalizations.of(context)!.settings),
                  ),
                  const NavigationRailDestination(
                    icon: Icon(Icons.info),
                    label: Text('Info'),
                  ),
                ],
                selectedIndex: selectedPage + 1,
                onDestinationSelected: (int index) {

                  setState(() {
                    if (index == 0) {
                      extended = !extended;
                    } else {
                      selectedPage = (index - 1);
                    }
                  });
                },
              )),
              Expanded(
                child: page,
              ),
            ],
          );
        }
      },
    ));
  }
}

class Placeholder extends StatelessWidget {
  final String text;
  const Placeholder({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text));
  }
}
