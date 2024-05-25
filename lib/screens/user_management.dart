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
  int _rowsPerPage = 20;
  HttpService hs = HttpService();

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await hs.fetchUsers();
    if (response.statusCode == 200) {
      final data = (json.decode(response.data) as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return shownData(context, snapshot.data);
          }
        });
  }

  RefreshIndicator shownData(
      BuildContext context, List<Map<String, dynamic>> data) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SizedBox.expand(
        child: SingleChildScrollView(
          child: PaginatedDataTable(
            header: Text('User Table'),
            rowsPerPage: _rowsPerPage,
            availableRowsPerPage: <int>[5, 10, 20, 25, 50, 100],
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
            source: _DataSource(context, data),
          ),
        ),
      ),
    );
  }
}

class _Row {
  _Row(this.value);

  final int value;

  DataCell getCell(int index) => DataCell(Text('Data $index'));
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, this.data);

  final BuildContext context;
  final List<Map<String, dynamic>> data;
  int _selectedCount = 0;

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
              onPressed: () {},
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
