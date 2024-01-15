import 'package:cunty/src/imports.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({Key? key}) : super(key: key);

  static const String route = '/timetable';

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  final List<TableRow> _table = [];
  final List<int> _periods = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  late Future<String> _initFuture;

  Future<String> _init() async {
    _table.clear();
    return 'done';
  }

  @override
  void initState() {
    super.initState();

    _initFuture = _init();
  }

  @override
  LayoutBuilder build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder(
          future: _initFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                child: Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(3),
                    3: FlexColumnWidth(3),
                    4: FlexColumnWidth(3),
                    5: FlexColumnWidth(3),
                  },
                  // border: TableBorder.all(),
                  children: _items(
                      colorScheme, constraints.maxWidth, constraints.maxHeight),
                ),
              );
            }
          });
    });
  }

  List<TableRow> _items(ColorScheme colorScheme, double width, double height) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    Widget tableCell(
        {required String text, Color? color, required double height}) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            // border: Border.all(color: colorScheme.onSurface),
            borderRadius: BorderRadius.circular(25),
            color: color,
          ),
          padding: const EdgeInsets.all(8.0),
          height: height,
          child: Center(
              child:
                  Text(text, style: themeProvider.smallestTextStyle(context))),
        ),
      );
    }

    final List<String> days = [
      AppLocalizations.of(context)!.mon,
      AppLocalizations.of(context)!.tue,
      AppLocalizations.of(context)!.wed,
      AppLocalizations.of(context)!.thu,
      AppLocalizations.of(context)!.fri,
    ];
    List<TableRow> rows = [
      TableRow(children: [
        tableCell(
          text: '',
          // color: colorScheme.surface,
          height: height / 20,
        ),
        tableCell(
          text: AppLocalizations.of(context)!.mon,
          // color: colorScheme.surfaceVariant,
          height: height / 20,
        ),
        tableCell(
          text: AppLocalizations.of(context)!.tue,
          // color: colorScheme.surface,
          height: height / 20,
        ),
        tableCell(
          text: AppLocalizations.of(context)!.wed,
          // color: colorScheme.surfaceVariant,
          height: height / 20,
        ),
        tableCell(
          text: AppLocalizations.of(context)!.thu,
          // color: colorScheme.surface,
          height: height / 20,
        ),
        tableCell(
          text: AppLocalizations.of(context)!.fri,
          // color: colorScheme.surfaceVariant,
          height: height / 20,
        ),
      ]),
    ];
    var h = 1;
    for (var i = 0; i < _periods.length; i++) {
      List<TableCell> cells = [
        TableCell(
          child: Column(
            children: [
              tableCell(
                text: '${_periods[i]}',
                height: (height - (height / 20)) / 20 - 8,
              ),
              tableCell(
                text: '${_periods[i] + 1}',
                height: (height - (height / 20)) / 20 - 8,
              ),
            ],
          ),
        )
      ];
      for (var j = 0; j < days.length; j++) {
        cells.add(TableCell(
            child: tableCell(
          text: '${days[j]} ${i + 1}',
          color: colorScheme.primaryContainer,
          height: (height - (height / 20)) / 10 - 8,
        )));
      }
      rows.add(TableRow(children: cells));
    }
    _table.addAll(rows);

    return rows;
  }
}
