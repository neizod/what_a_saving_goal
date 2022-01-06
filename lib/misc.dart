import 'dart:math';

import 'package:flutter/material.dart';


// widgets ===================================================================

Widget showLoadingSplash(BuildContext context) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
    ),
  );
}



// focus node ================================================================

class DisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}


class EnabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => true;
}



// validator =================================================================

String? Function(String?) empty(String reason) {
  return (value) => ((value == null || value.isEmpty) ? reason : null);
}


String? Function(String?) notInt(String reason) {
  return (value) => ((value == null || int.tryParse(value) == null) ? reason : null);
}


String? Function(String?) refuse(List<String? Function(String?)> reasons) {
  return (value) => reasons.fold(null, (result, each) => (result == null) ? each(value) : result);
}



// datetime ==================================================================

final Map<String,String> periodTypeText = {
  'day': 'วัน',
  'week': 'สัปดาห์',
  'month': 'เดือน',
  'quarter': 'ไตรมาส',
  'year': 'ปี',
};


DateTime nextTime(DateTime date, int numPeriod, String periodType) {
  switch (periodType) {
    case 'day':
      return date.add(Duration(days: numPeriod));
    case 'week':
      return date.add(Duration(days: 7*numPeriod));
    case 'month':
      return nextMonths(date, numPeriod);
    case 'quarter':
      return nextMonths(date, 3*numPeriod);
    case 'year':
      return nextYear(date, numPeriod);
    default:
      throw Exception('unrecognized periodType');
  }
}


DateTime nextMonths(DateTime date, int months) {
  int dayLimit = DateTime(date.year, date.month+months+1, 0).day;
  return DateTime(date.year, date.month+months, min(date.day, dayLimit));
}


DateTime nextYear(DateTime date, int years) {
  int dayLimit = DateTime(date.year+years, date.month+1, 0).day;
  return DateTime(date.year+years, date.month, min(date.day, dayLimit));
}


List<DateTime> listPeriods(DateTime startDate, DateTime endDate, String periodType,
                           {bool expandToToday: true, bool includeLastEntry: true}) {
  if (startDate.isAfter(endDate)) {
    throw Exception('startDate can not happen after endDate.');
  }
  if (expandToToday && endDate.isBefore(DateTime.now())) {
    endDate = DateTime.now();
  }
  List<DateTime> periods = [];
  DateTime date = startDate;
  int i = 0;
  while (date.isBefore(endDate)) {
    periods.add(date);
    i += 1;
    date = nextTime(startDate, i, periodType);
  }
  if (includeLastEntry) {
    periods.add(date);
  }
  return periods;
}


// TODO accept periods as first argument
List<List<Map>> listPaidsPerPeriods(DateTime startDate, DateTime endDate,
                                    String periodType, List sortedPaids) {
  List<DateTime> periods = listPeriods(startDate, endDate, periodType);
  List<List<Map>> ls = [];
  for (int i = 0; i < periods.length+1; i++) {
    ls.add([]);
  }
  int j = 0;
  for (int i = 0; i < periods.length; i++) {
    while (j < sortedPaids.length && sortedPaids[j]['date'].isBefore(periods[i])) {
      ls[i].add(sortedPaids[j]);
      j += 1;
    }
    if (j == sortedPaids.length) {
      break;
    }
  }
  while (j < sortedPaids.length) {
    ls[periods.length].add(sortedPaids[j]);
    j += 1;
  }
  return ls;
}
