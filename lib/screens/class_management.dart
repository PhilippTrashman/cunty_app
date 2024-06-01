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

  List<Map<String, dynamic>> data = [];

  Future<List<Map<String, dynamic>>> fetchData() async {
    if (_updateGrades) {
      data = await hs.fetchGrades();
      _updateGrades = false;
    }
    return data;
  }

  Future<SchoolGrade> fetchGrade(int id) async {
    if (_selectedGrade != null && _selectedGrade!['id'] != id) {
      throw Exception('Invalid grade id');
    }
    return hs.fetchGrade(id);
  }

  void updateGrades() {
    setState(() {
      _updateGrades = true;
    });
  }

  Future<List<Map<String, dynamic>>>? _dataFuture;
  Map<String, dynamic>? _selectedGrade;
  SchoolClassSmall? _selectedClass;

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
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
          return _gradeDetails(context, _selectedGrade!['id']);
        }
        return _gradeList(context, snapshot);
      },
    );
  }

  Column _gradeList(BuildContext context,
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    return Column(
      children: [
        Text('Grades', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Grade ${snapshot.data![index]['year']}'),
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
    Future<SchoolGrade> _detailsFuture = fetchGrade(gradeId);

    return FutureBuilder<SchoolGrade>(
      future: _detailsFuture,
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
            children: [
              Text('Details for Grade $gradeId'),
              Text('Details: ${snapshot.data!.year}'),
              ElevatedButton(
                child: Text('Back'),
                onPressed: () {
                  setState(() {
                    _selectedGrade = null;
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.classes.length,
                  itemBuilder: (context, index) {
                    var entry = snapshot.data!.classes.entries.elementAt(index);
                    return ListTile(
                      title: Text(entry.value.name),
                      subtitle:
                          Text('Teacher: ${entry.value.head_teacher_name}'),
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
    return Center(
      child: Column(
        children: [
          Text('Details for Class $classId'),
          ElevatedButton(
            child: Text('Back'),
            onPressed: () {
              setState(() {
                _selectedClass = null;
              });
            },
          ),
        ],
      ),
    );
  }
}
