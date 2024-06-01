import 'dart:io';

import 'package:cunty/screens/user_management.dart';
import 'package:cunty/screens/class_management.dart';
import 'package:cunty/src/imports.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const String route = '/';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late AppState appState;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  bool extended = false;
  bool _isHidden = true;

  var selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    Widget page;
    switch (selectedPage) {
      case 0:
        page = const Placeholder(text: 'Welcome');
        break;
      case 1:
        page = const UserManagement();
        break;
      case 2:
        page = const ClassManagement();
      case 3:
        page = const Placeholder(text: 'Settings');
        break;
      default:
        page = const Placeholder(text: 'Info');
    }

    Widget navigator({bool? useInsteadOfExtended}) {
      return SafeArea(
          child: NavigationRail(
        extended: useInsteadOfExtended ?? extended,
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Icons.home),
            label: Text(
              'Home',
              style: TextStyle(overflow: TextOverflow.ellipsis),
            ),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.people),
            label: Text(
              'Users',
              style: TextStyle(overflow: TextOverflow.ellipsis),
            ),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.tv),
            label: Text(
              'Classes',
              style: TextStyle(overflow: TextOverflow.ellipsis),
            ),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.settings),
            label: Text(
              'Settings',
              style: TextStyle(overflow: TextOverflow.ellipsis),
            ),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.info),
            label: Text(
              'Info',
              style: TextStyle(overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
        selectedIndex: selectedPage,
        onDestinationSelected: (int index) {
          setState(() {
            selectedPage = (index);
          });
        },
      ));
    }

    Widget drawer() {
      return Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                extended = false;
              });
            },
            child: Container(
              color: Colors.black.withOpacity(0.5),
              width: extended ? double.infinity : 0,
              height: double.infinity,
            ),
          ),
          Drawer(
            width: extended ? 200 : 0,
            child: navigator(useInsteadOfExtended: true),
          ),
        ],
      );
    }

    Widget loggedIn() {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450 && Platform.isAndroid ||
              Platform.isIOS) {
            return Stack(
              children: [
                page,
                drawer(),
              ],
            );
          } else {
            return Stack(
              children: [
                Row(
                  children: [
                    navigator(useInsteadOfExtended: false),
                    Expanded(child: page),
                  ],
                ),
                drawer(),
              ],
            );
          }
        },
      );
    }

    Widget loggedOut() {
      return LayoutBuilder(builder: (context, constraints) {
        double maxHeight() {
          if (constraints.maxHeight < 200) {
            return 200;
          } else {
            if (constraints.maxHeight > 400) {
              return 400;
            } else {
              return constraints.maxHeight;
            }
          }
        }

        double maxWidth() {
          if (constraints.maxWidth < 200) {
            return 200;
          } else {
            if (constraints.maxWidth > 400) {
              return 400;
            } else {
              return constraints.maxWidth;
            }
          }
        }

        double height = maxHeight();
        double width = maxWidth();

        return Center(
            child: Container(
                constraints: BoxConstraints(
                  maxWidth: width,
                  maxHeight: height,
                  minHeight: 200,
                  minWidth: 200,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              emailController.clear();
                            },
                          ),
                          labelText: 'Email or Username',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: passwordController,
                        obscureText: _isHidden,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_isHidden
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isHidden = !_isHidden;
                              });
                            },
                          ),
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          await appState
                              .login(
                                  emailController.text, passwordController.text)
                              .then((value) {
                            setState(() {});
                          });
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                )));
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 40,
              ),
              const SizedBox(width: 8),
              Text('Cunty',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
            ],
          ),
          leading: IconButton(
            onPressed: () {
              setState(() {
                extended = !extended;
                debugPrint('Extended: $extended');
              });
            },
            icon: const Icon(Icons.menu),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                appState.logout();
              },
              icon: const Icon(Icons.developer_mode),
            )
          ],
        ),
        body: appState.loggedIn() ? loggedIn() : loggedOut());
  }
}

class Placeholder extends StatelessWidget {
  final String text;
  const Placeholder({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Text(text),
        Image.asset(
          'assets/images/amogus.gif',
          fit: BoxFit.contain,
        )
      ],
    ));
  }
}
