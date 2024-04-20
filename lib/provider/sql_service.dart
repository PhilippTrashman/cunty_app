import 'package:cunty/src/imports.dart';
import 'package:sqlite3/sqlite3.dart';

class SqlService extends ChangeNotifier {
  late Database db;

  SqlService() {
    db = sqlite3.open('cunty.db');
  }

  void createUserTable() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        created_at TEXT NOT NULL,
        role TEXT NOT NULL
        first_name TEXT,
        last_name TEXT,
        birthday TEXT
      );
    ''');
  }

  void createClassTable() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS classes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        grade_id INTEGER NOT NULL,
      );
    ''');
  }

  void createAssignmentTable() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS assignments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        due_date TEXT NOT NULL,
        subject TEXT NOT NULL,
        teacher_id INTEGER NOT NULL,
        class_id TEXT NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (class_id) REFERENCES classes (id),
        FOREIGN KEY (teacher_id) REFERENCES users (id),
      );
    ''');
  }

  void createGradeTable() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS grades (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        created_at TEXT NOT NULL
      );
    ''');
  }

  void createClassroomTable() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS classrooms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
      );
    ''');
  }

  void createPeriodsTable() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS periods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        teacher_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (teacher_id) REFERENCES users (id),
      );
    ''');
  }

  void createPeriodClassroomsTable() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS period_classrooms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        period_id INTEGER NOT NULL,
        classroom_id INTEGER NOT NULL,
        FOREIGN KEY (period_id) REFERENCES periods (id),
        FOREIGN KEY (classroom_id) REFERENCES classrooms (id),
      );
    ''');
  }

  void createMessageTable() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sender_id INTEGER NOT NULL,
        receiver_id INTEGER NOT NULL,
        message TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (sender_id) REFERENCES users (id),
        FOREIGN KEY (receiver_id) REFERENCES users (id),
      );
    ''');
  }

  void close() {
    db.dispose();
  }

  void createTables() {
    createUserTable();

    createClassTable();

    createAssignmentTable();

    createGradeTable();

    createClassroomTable();

    createPeriodsTable();

    createPeriodClassroomsTable();
  }

  void dropTables() {
    db.execute('DROP TABLE IF EXISTS users;');
    db.execute('DROP TABLE IF EXISTS classes;');
    db.execute('DROP TABLE IF EXISTS assignments;');
    db.execute('DROP TABLE IF EXISTS grades;');
    db.execute('DROP TABLE IF EXISTS classrooms;');
    db.execute('DROP TABLE IF EXISTS periods;');
    db.execute('DROP TABLE IF EXISTS period_classrooms;');
  }
}
