import 'package:cunty/src/imports.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  static const String route = '/user_management';

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final int _selectedIndex = 0;
  final int length = 4;

  Widget _buildTabView(int index) {
    switch (index) {
      case 0:
        return const Center(child: UserTable());
      case 1:
        return const Center(child: Text('Add User'));
      case 2:
        return const Center(child: Text('Remove User'));
      case 3:
        return const Center(child: Text('Search User'));
      default:
        return const Center(child: Text('User'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _selectedIndex,
      length: length,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person)),
              Tab(icon: Icon(Icons.person_add)),
              Tab(icon: Icon(Icons.person_remove)),
              Tab(icon: Icon(Icons.person_search)),
            ],
          ),
          Expanded(
            child: TabBarView(
                children:
                    List.generate(length, (index) => _buildTabView(index))),
          ),
        ],
      ),
    );
  }
}

class UserTable extends StatefulWidget {
  const UserTable({super.key});

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  Widget _buildTable() {
    return SizedBox.expand(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Role')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Phone')),
          DataColumn(label: Text('Actions')),
        ],
        rows: List.generate(10, (index) {
          return DataRow(
            cells: [
              DataCell(Text('User $index')),
              DataCell(Text('Role $index')),
              DataCell(Text('Email $index')),
              DataCell(Text('Phone $index')),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {},
                  ),
                ],
              )),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTable();
  }
}
