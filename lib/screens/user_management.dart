import 'package:cunty/src/imports.dart';
import 'package:cunty/screens/user_management/user_table.dart';
import 'package:cunty/service/http_service.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  static const String route = '/user_management';
  final int _selectedIndex = 0;

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final int length = 5;
  final HttpService hs = HttpService();
  bool _userRequest = true;
  bool _studentRequest = true;
  bool _teacherRequest = true;
  bool _parentRequest = true;
  bool _adminRequest = true;
  Map<String, List<Map<String, dynamic>>> data = {
    'users': [],
    'students': [],
    'teachers': [],
    'parents': [],
    'admins': [],
  };

  Future<Map<String, List<Map<String, dynamic>>>> fetchData() async {
    if (_userRequest) {
      debugPrint('Fetching users');
      data['users'] = await hs.fetchUsers();
      _userRequest = false;
    }
    if (_studentRequest) {
      debugPrint('Fetching students');
      data['students'] = await hs.fetchStudents();
      _studentRequest = false;
    }
    if (_teacherRequest) {
      debugPrint('Fetching teachers');
      data['teachers'] = await hs.fetchTeachers();
      _teacherRequest = false;
    }
    if (_parentRequest) {
      debugPrint('Fetching parents');
      data['parents'] = await hs.fetchParents();
      _parentRequest = false;
    }
    if (_adminRequest) {
      debugPrint('Fetching admins');
      data['admins'] = await hs.fetchAdmins();
      _adminRequest = false;
    }
    return data;
  }

  void updateUsers() {
    setState(() {
      _userRequest = true;
    });
  }

  void updateStudents() {
    setState(() {
      _studentRequest = true;
    });
  }

  void updateTeachers() {
    setState(() {
      _teacherRequest = true;
    });
  }

  void updateParents() {
    setState(() {
      _parentRequest = true;
    });
  }

  void updateAdmins() {
    setState(() {
      _adminRequest = true;
    });
  }

  Widget _buildTabView(int index,
      {required Map<String, List<Map<String, dynamic>>> data}) {
    switch (index) {
      case 0:
        return Center(
            child: UserTable(
          title: 'Users',
          data: data['users'] ?? [],
          hs: hs,
          root: true,
          update: updateUsers,
          delete: deleteUser,
          type: UserTableType.users,
        ));
      case 1:
        return Center(
            child: UserTable(
          title: 'Students',
          data: data['students'] ?? [],
          hs: hs,
          root: false,
          update: updateStudents,
          delete: deleteUserRollStudent,
          type: UserTableType.students,
        ));
      case 2:
        return Center(
            child: UserTable(
          title: 'Teachers',
          data: data['teachers'] ?? [],
          hs: hs,
          root: false,
          update: updateTeachers,
          delete: deleteUserRollTeacher,
          type: UserTableType.teachers,
        ));
      case 3:
        return Center(
            child: UserTable(
          title: 'Parents',
          data: data['parents'] ?? [],
          hs: hs,
          root: false,
          update: updateParents,
          delete: deleteUserRollParent,
          type: UserTableType.parents,
        ));
      case 4:
        return Center(
            child: UserTable(
          title: 'Super Users',
          data: data['admins'] ?? [],
          hs: hs,
          root: false,
          update: updateAdmins,
          delete: deleteUserRollAdmin,
          type: UserTableType.admins,
        ));
      default:
        return const Center(child: Text('Error: Invalid index'));
    }
  }

  Widget body() {
    return FutureBuilder(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return tabbuilder(
              snapshot.data as Map<String, List<Map<String, dynamic>>>);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  DefaultTabController tabbuilder(
      Map<String, List<Map<String, dynamic>>> data) {
    return DefaultTabController(
      initialIndex: widget._selectedIndex,
      length: length,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'Users'),
              Tab(icon: Icon(Icons.boy), text: 'Students'),
              Tab(icon: Icon(Icons.school), text: 'Teachers'),
              Tab(icon: Icon(Icons.supervisor_account), text: 'Parents'),
              Tab(icon: Icon(Icons.engineering), text: 'Admins'),
            ],
          ),
          Expanded(
            child: TabBarView(
                children: List.generate(
                    length, (index) => _buildTabView(index, data: data))),
          ),
        ],
      ),
    );
  }

  AlertDialog deleteUserDialog(String username) {
    return AlertDialog(
      title: const Text('Delete User'),
      content: Text('Are you sure you want to delete $username?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await hs.deleteUser(username).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted $username'),
                ),
              );
            }).catchError((e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to delete $username'),
                ),
              );
            }).then((value) {
              Navigator.of(context).pop();
              setState(() {});
            });
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }

  void deleteUser(String username) {
    showDialog(
      context: context,
      builder: (BuildContext context) => deleteUserDialog(username),
    );
  }

  AlertDialog deleteUserRollDialog(String username, String roll) {
    return AlertDialog(
      title: const Text('Delete User'),
      content:
          Text('Are you sure you want to delete $roll roll from $username?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await hs.deleteUserRoll(roll, username).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted $roll roll from $username'),
                ),
              );
            }).catchError((e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to delete $roll roll from $username'),
                ),
              );
            }).then((value) {
              Navigator.of(context).pop();
              setState(() {});
            });
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }

  void deleteUserRoll(String username, String roll) {
    showDialog(
      context: context,
      builder: (BuildContext context) => deleteUserRollDialog(username, roll),
    );
  }

  void deleteUserRollStudent(String username) {
    deleteUserRoll(username, 'student');
  }

  void deleteUserRollTeacher(String username) {
    deleteUserRoll(username, 'teacher');
  }

  void deleteUserRollParent(String username) {
    deleteUserRoll(username, 'parent');
  }

  void deleteUserRollAdmin(String username) {
    deleteUserRoll(username, 'su');
  }
}
