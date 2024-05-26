import 'package:cunty/service/http_service.dart';
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
  final HttpService hs = HttpService();

  void update() {
    setState(() {});
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchData() async {
    final responseUsers = await hs.fetchUsers();
    Map<String, List<Map<String, dynamic>>> data = {};
    if (responseUsers.statusCode == 200) {
      data['users'] = (json.decode(responseUsers.data) as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Widget _buildTabView(
      int index, Map<String, List<Map<String, dynamic>>> data) {
    switch (index) {
      case 0:
        return Center(
            child: UserTable(data: data['users']!, update: update, hs: hs));
      case 1:
        return const Center(child: Text('Classes'));
      case 2:
        return const Center(child: Text('Remove User'));
      case 3:
        return const Center(child: Text('Search User'));
      default:
        return const Center(child: Text('User'));
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
          return tabbuilder(snapshot.data);
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
      initialIndex: _selectedIndex,
      length: length,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person)),
              Tab(icon: Icon(Icons.school)),
              Tab(icon: Icon(Icons.person_add)),
              Tab(icon: Icon(Icons.person_search)),
            ],
          ),
          Expanded(
            child: TabBarView(
                children: List.generate(
                    length, (index) => _buildTabView(index, data))),
          ),
        ],
      ),
    );
  }
}

class UserTable extends StatefulWidget {
  const UserTable(
      {super.key, required this.data, required this.update, required this.hs});
  final List<Map<String, dynamic>> data;
  final Function update;
  final HttpService hs;

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  int _rowsPerPage = 20;

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return shownData(context, widget.data);
  }

  void deleteUser(String username) {
    setState(() {
      widget.hs.deleteUser(username);
    });
  }

  RefreshIndicator shownData(
      BuildContext context, List<Map<String, dynamic>> data) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SizedBox.expand(
        child: SingleChildScrollView(
          child: PaginatedDataTable(
            header: Row(
              children: [
                const Text('User Table'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {});
                    widget.update();
                  },
                ),
              ],
            ),
            rowsPerPage: _rowsPerPage,
            availableRowsPerPage: const <int>[5, 10, 20, 25, 50, 100],
            onRowsPerPageChanged: (int? value) {
              setState(() {
                _rowsPerPage = value!;
              });
            },
            columns: const <DataColumn>[
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Last Name')),
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Birthday')),
              DataColumn(label: Text('Actions')),
            ],
            source: _DataSource(context, data, deleteUser, widget.update),
          ),
        ),
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, this.data, this.deleteUser, this.update);

  final BuildContext context;
  final List<Map<String, dynamic>> data;
  final Function deleteUser;
  final Function update;
  final int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final Map<String, dynamic> value = data[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text('${value["id"]}')),
        DataCell(Text('${value["name"]}')),
        DataCell(Text('${value["last_name"]}')),
        DataCell(Text('${value["username"]}')),
        DataCell(Text('${value["birthday"]}')),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteUser(value["username"]);
                update();
              },
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => _selectedCount;
}
