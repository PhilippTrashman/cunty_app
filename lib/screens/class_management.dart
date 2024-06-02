import 'package:cunty/service/http_service.dart';
import 'package:cunty/src/imports.dart';
import 'package:flutter/material.dart';
import 'package:cunty/models/school_grade.dart';

class ClassManagement extends StatefulWidget {
  const ClassManagement({super.key});

  static const String route = '/class_management';

  @override
  State<ClassManagement> createState() => _ClassManagementState();
}

class _ClassManagementState extends State<ClassManagement> {
  final HttpService hs = HttpService();

  bool _updateGrades = true;

  List<SchoolGradeSmall> data = [];

  Future<List<SchoolGradeSmall>> fetchData() async {
    if (_updateGrades) {
      data = await hs.fetchGrades();
      _updateGrades = false;
    }
    return data;
  }

  Future<SchoolGrade> fetchGrade(int id) async {
    if (_selectedGrade != null && _selectedGrade!.id != id) {
      throw Exception('Invalid grade id');
    }
    return hs.fetchGrade(id);
  }

  Future<SchoolClass> fetchClass(int id) async {
    if (_selectedClass != null && _selectedClass!.id != id) {
      throw Exception('Invalid class id');
    }
    return hs.fetchClass(id);
  }

  void updateGrades() {
    setState(() {
      _updateGrades = true;
    });
  }

  Future<List<SchoolGradeSmall>>? _dataFuture;
  SchoolGradeSmall? _selectedGrade;
  SchoolClassSmall? _selectedClass;

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SchoolGradeSmall>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (snapshot.data == null) {
          return const Center(
            child: Text('Error: No data'),
          );
        }
        if (_selectedClass != null) {
          return _classDetails(context, _selectedClass!.id);
        }
        if (_selectedGrade != null) {
          return _gradeDetails(context, _selectedGrade!.id);
        }
        return _gradeList(context, snapshot);
      },
    );
  }

  Column _gradeList(
      BuildContext context, AsyncSnapshot<List<SchoolGradeSmall>> snapshot) {
    return Column(
      children: [
        Text('Grades', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Grade ${snapshot.data![index].grade}'),
                onTap: () {
                  setState(() {
                    _selectedGrade = snapshot.data![index];
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _gradeDetails(BuildContext context, int gradeId) {
    Future<SchoolGrade> detailsFuture = fetchGrade(gradeId);

    return FutureBuilder<SchoolGrade>(
      future: detailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (snapshot.data == null) {
          return const Center(
            child: Text('Error: No data'),
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        _selectedGrade = null;
                      });
                    },
                  ),
                  Text(
                      'Details for Grade ${snapshot.data!.grade} - Started in: ${snapshot.data!.year}',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center),
                ],
              ),
              const Divider(),
              SizedBox(
                width: double.infinity,
                child: Text('Classes',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.start),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.classes.length,
                  itemBuilder: (context, index) {
                    var entry = snapshot.data!.classes.entries.elementAt(index);
                    return ListTile(
                      title: Text(entry.value.name),
                      subtitle: Text('Teacher: ${entry.value.headTeacherName}'),
                      onTap: () {
                        setState(() {
                          _selectedClass = entry.value;
                        });
                      },
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _classDetails(BuildContext context, int classId) {
    return FutureBuilder<SchoolClass>(
      future: fetchClass(classId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (snapshot.data == null) {
          return const Center(
            child: Text('Error: No data'),
          );
        }
        return Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          _selectedClass = null;
                        });
                      },
                    ),
                    Text('Details for Class $classId',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center),
                  ],
                ),
                const Divider(),
                _headTeacherInfo(snapshot.data!.headTeacher),
                const Divider(),
                _studentsInfo(snapshot.data!),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _headTeacherInfo(SchoolClassHeadTeacher teacher) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Head Teacher', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            DataTable(
              columns: const [
                DataColumn(label: Expanded(child: Text('ID'))),
                DataColumn(label: Expanded(child: Text('Abbreviation'))),
                DataColumn(label: Expanded(child: Text('Name'))),
                DataColumn(label: Expanded(child: Text('Last Name'))),
                DataColumn(label: Expanded(child: Text('Username'))),
                DataColumn(label: Expanded(child: Text('Birthday'))),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text(teacher.account.id)),
                  DataCell(Text(teacher.abbreviation)),
                  DataCell(Text(teacher.account.name)),
                  DataCell(Text(teacher.account.lastName)),
                  DataCell(Text(teacher.account.username)),
                  DataCell(Text(teacher.account.birthday)),
                ])
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _studentsInfo(SchoolClass data) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Students', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            DataTable(
              columns: const [
                DataColumn(label: Expanded(child: Text('ID'))),
                DataColumn(label: Expanded(child: Text('Name'))),
                DataColumn(label: Expanded(child: Text('Last Name'))),
                DataColumn(label: Expanded(child: Text('Username'))),
                DataColumn(label: Expanded(child: Text('Birthday'))),
              ],
              rows: data.students.values
                  .map((student) => DataRow(cells: [
                        DataCell(Text(student.account.id.toString())),
                        DataCell(Text(student.account.name)),
                        DataCell(Text(student.account.lastName)),
                        DataCell(Text(student.account.username)),
                        DataCell(Text(student.account.birthday)),
                      ]))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
