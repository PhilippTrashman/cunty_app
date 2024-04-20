import 'package:cunty/models/period_model.dart';
import 'package:cunty/models/assignment_model.dart';

class PeriodPlanModel {
  final String userId;
  final String weekDay;
  final Map<int, PeriodModel> periods;
  final Map<int, AssignmentModel> assignments = {};

  PeriodPlanModel({
    required this.userId,
    required this.weekDay,
    required this.periods,
  });

  factory PeriodPlanModel.fromJson(Map<String, dynamic> json) {
    return PeriodPlanModel(
      userId: json['user_id'],
      weekDay: json['week_day'],
      periods: json['periods'],
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'week_day': weekDay,
        'periods': periods,
      };

  @override
  String toString() =>
      'PeriodPlanModel(user_id: $userId, week_day: $weekDay, periods: $periods)';
}
