import 'package:cunty/service/http_service.dart';
import 'package:cunty/src/imports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  late List<Map<String, dynamic>> filteredData;

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final birthdayController = TextEditingController();

  // ...

  @override
  void initState() {
    super.initState();
    filteredData = List<Map<String, dynamic>>.from(widget.data);
  }

  bool _showFilters = false;

  Widget body() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: Text(_showFilters ? 'Hide Filters' : 'Show Filters'),
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
          ),
        ),
        if (_showFilters) filterBox(),
        Expanded(child: shownData(context, filteredData)),
      ],
    );
  }

  Column filterBox() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'ID'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: birthdayController,
                decoration: const InputDecoration(labelText: 'Birthday'),
              ),
            ),
          ],
        ),
        filterButtonRow(),
      ],
    );
  }

  Widget filterButtonRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton(
              child: const Text('Apply Filters'),
              onPressed: () {
                setState(() {
                  // Filter the data based on the input values.
                  filteredData = widget.data.where((item) {
                    if (!widget.root) {
                      item = item['account'];
                    }
                    return (idController.text.isEmpty ||
                            item['id']
                                .toString()
                                .toLowerCase()
                                .contains(idController.text.toLowerCase())) &&
                        (nameController.text.isEmpty ||
                            item['name']
                                .toLowerCase()
                                .contains(nameController.text.toLowerCase())) &&
                        (lastNameController.text.isEmpty ||
                            item['last_name'].toLowerCase().contains(
                                lastNameController.text.toLowerCase())) &&
                        (usernameController.text.isEmpty ||
                            item['username'].toLowerCase().contains(
                                usernameController.text.toLowerCase())) &&
                        (birthdayController.text.isEmpty ||
                            item['birthday'].toLowerCase().contains(
                                birthdayController.text.toLowerCase()));
                  }).toList();
                });
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              child: const Text('Clear Filters'),
              onPressed: () {
                setState(() {
                  // Clear the filters by resetting filteredData to the original data.
                  filteredData = List<Map<String, dynamic>>.from(widget.data);
                  idController.clear();
                  nameController.clear();
                  lastNameController.clear();
                  usernameController.clear();
                  birthdayController.clear();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget shownData(BuildContext context, List<Map<String, dynamic>> data) {
    return SizedBox.expand(
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
              hs: widget.hs,
              data: data,
              deleteUser: widget.delete,
              update: widget.update,
              root: widget.root,
              type: widget.type),
        ),
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  _DataSource(
      {required this.context,
      required this.hs,
      required this.data,
      required this.deleteUser,
      required this.update,
      required this.root,
      required this.type});

  final BuildContext context;
  final HttpService hs;
  final bool root;
  final List<Map<String, dynamic>> data;
  final Function deleteUser;
  final Function update;
  final int _selectedCount = 0;
  final UserTableType type;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final Map<String, dynamic> value = data[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(_tapHandler(
            data: value,
            text: root ? '${value["id"]}' : '${value["account"]["id"]}')),
        DataCell(_tapHandler(
            data: value,
            text: root ? '${value["name"]}' : '${value["account"]["name"]}')),
        DataCell(_tapHandler(
            data: value,
            text: root
                ? '${value["last_name"]}'
                : '${value["account"]["last_name"]}')),
        DataCell(_tapHandler(
            data: value,
            text: root
                ? '${value["username"]}'
                : '${value["account"]["username"]}')),
        DataCell(_tapHandler(
            data: value,
            text: root
                ? '${value["birthday"]}'
                : '${value["account"]["birthday"]}')),
        DataCell(
          GestureDetector(
            onTap: () {},
            child: Row(
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
            ),
          ),
        ),
      ],
    );
  }

  Widget _tapHandler(
      {required Map<String, dynamic> data, required String text}) {
    return SizedBox.expand(
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: DetailedUserView(
                  username:
                      root ? data["username"] : data["account"]["username"],
                  hs: hs,
                ),
              );
            },
          );
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(text, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => _selectedCount;
}

class DetailedUserView extends StatefulWidget {
  final String username;
  final HttpService hs;

  const DetailedUserView({super.key, required this.username, required this.hs});

  @override
  State<DetailedUserView> createState() => _DetailedUserViewState();
}

class _DetailedUserViewState extends State<DetailedUserView> {
  Future<Map<String, dynamic>> fetchData() async {
    return widget.hs.fetchUser(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return columnView(snapshot.data ?? {});
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
          }
          return const SizedBox(
              width: double.maxFinite,
              child: Center(child: CircularProgressIndicator()));
        });
  }

  Widget columnView(Map<String, dynamic> data) {
    List<Widget> children = [];
    children.add(_userInfo(data));
    if (data.containsKey('student') && data['student'] != null) {
      children.add(_studentInfo(data));
    }
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }

  Column _userInfo(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('User', style: const TextStyle(fontSize: 20)),
        SizedBox(height: 10),
        DataTable(columns: const [
          DataColumn(label: Expanded(child: Text('ID'))),
          DataColumn(label: Expanded(child: Text('Name'))),
          DataColumn(label: Expanded(child: Text('Last Name'))),
          DataColumn(label: Expanded(child: Text('Username'))),
          DataColumn(label: Expanded(child: Text('Birthday'))),
          DataColumn(label: Expanded(child: Text('Email'))),
        ], rows: [
          DataRow(cells: [
            DataCell(Text('${data["id"]}')),
            DataCell(Text('${data["name"]}')),
            DataCell(Text('${data["last_name"]}')),
            DataCell(Text('${data["username"]}')),
            DataCell(Text('${data["birthday"]}')),
            DataCell(Text('${data["email"]}')),
          ]),
        ]),
      ],
    );
  }

  DataRow _parentRow(Map<String, dynamic> data) {
    data = data['parent'];
    final account = data['account'];
    String name = account['name'];
    String lastName = account['last_name'];
    String username = account['username'];
    String birthday = account['birthday'];
    return DataRow(cells: [
      DataCell(Text('${account["id"]}')),
      DataCell(Text(name)),
      DataCell(Text(lastName)),
      DataCell(Text(username)),
      DataCell(Text(birthday)),
    ]);
  }

  Column _studentInfo(Map<String, dynamic> data) {
    data = data['student']!;
    List<DataRow> parentRows = [];
    for (var parent in data['parents'].values) {
      parentRows.add(_parentRow(parent));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Text('Parents', style: const TextStyle(fontSize: 20)),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(columns: const [
            DataColumn(label: Expanded(child: Text('ID'))),
            DataColumn(label: Expanded(child: Text('Name'))),
            DataColumn(label: Expanded(child: Text('Last Name'))),
            DataColumn(label: Expanded(child: Text('Username'))),
            DataColumn(label: Expanded(child: Text('Birthday'))),
          ], rows: parentRows),
        ),
        SizedBox(height: 10),
        _schoolClassInfo(data['school_class']),
      ],
    );
  }

  Widget _schoolClassInfo(Map<String, dynamic> data) {
    String name = data['name'];
    String grade = data['grade_id'].toString();
    String teacher = data['head_teacher_name'];
    String teacher_abbr = data['head_teacher_abbreviation'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Text('School Class', style: const TextStyle(fontSize: 20)),
        SizedBox(height: 10),
        DataTable(columns: const [
          DataColumn(label: Expanded(child: Text('Name'))),
          DataColumn(label: Expanded(child: Text('Grade'))),
          DataColumn(label: Expanded(child: Text('Teacher'))),
          DataColumn(label: Expanded(child: Text('Abbreviation'))),
        ], rows: [
          DataRow(cells: [
            DataCell(Text(name)),
            DataCell(Text(grade)),
            DataCell(Text(teacher)),
            DataCell(Text(teacher_abbr)),
          ]),
        ]),
      ],
    );
  }
}
