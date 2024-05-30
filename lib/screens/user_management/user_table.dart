import 'package:cunty/service/http_service.dart';
import 'package:cunty/src/imports.dart';

enum UserTableType { users, students, teachers, parents, admins }

class UserTable extends StatefulWidget {
  const UserTable(
      {super.key,
      required this.title,
      required this.data,
      required this.hs,
      required this.root,
      required this.update,
      required this.delete,
      required this.type});
  final String title;
  final List<Map<String, dynamic>> data;
  final HttpService hs;
  final bool root;
  final Function update;
  final Function delete;
  final UserTableType type;

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  int _rowsPerPage = 20;

  Widget body() {
    return shownData(context, widget.data);
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return body();
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
                Text(widget.title, style: const TextStyle(fontSize: 24)),
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
            source: _DataSource(
                context: context,
                data: data,
                deleteUser: widget.delete,
                update: widget.update,
                root: widget.root),
          ),
        ),
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  _DataSource(
      {required this.context,
      required this.data,
      required this.deleteUser,
      required this.update,
      required this.root});

  final BuildContext context;
  final bool root;
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
        DataCell(Text(root ? '${value["id"]}' : '${value["account"]["id"]}')),
        DataCell(
            Text(root ? '${value["name"]}' : '${value["account"]["name"]}')),
        DataCell(Text(root
            ? '${value["last_name"]}'
            : '${value["account"]["last_name"]}')),
        DataCell(Text(
            root ? '${value["username"]}' : '${value["account"]["username"]}')),
        DataCell(Text(
            root ? '${value["birthday"]}' : '${value["account"]["birthday"]}')),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                if (root) {
                  deleteUser(value["username"]);
                } else {
                  deleteUser(value["account"]["username"]);
                }
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
