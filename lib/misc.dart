import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


// widgets ===================================================================

var formatter = DateFormat('d LLLL y');

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


List<DateTime> listPeriods(Map goal, {bool endDateIsNow: true, bool includeLastEntry: true}) {
  DateTime startDate = goal['startDate'];
  DateTime endDate = goal['endDate'];
  if (endDateIsNow) {
    endDate = DateTime.now();
  }
  if (startDate.isAfter(endDate)) {
    endDate = startDate;
  }
  List<DateTime> periods = [];
  DateTime date = startDate;
  int i = 0;
  while (date.isBefore(endDate)) {
    periods.add(date);
    i += 1;
    date = nextTime(startDate, i, goal['periodType']);
  }
  if (includeLastEntry) {
    periods.add(date);
  }
  return periods;
}


List<List<Map>> listPaidsPerPeriods(Map goal, List periods) {
  List<List<Map>> ls = [];
  for (int i = 0; i < periods.length+1; i++) {
    ls.add([]);
  }
  int j = 0;
  for (int i = 0; i < periods.length; i++) {
    while (j < goal['paids'].length && goal['paids'][j]['date'].isBefore(periods[i])) {
      ls[i].add(goal['paids'][j]);
      j += 1;
    }
  }
  while (j < goal['paids'].length) {
    ls[periods.length].add(goal['paids'][j]);
    j += 1;
  }
  return ls;
}


// ===========================================================================

String makePeriodTitle(int index, List periods) {
  if (index == 0) {
    return 'ก่อนออม';
  } else if (index == periods.length) {
    return 'อนาคต';
  } // TODO == periods.length - 1 => ปัจจุบัน ???
  return 'งวดที่ ${index}';
}


String makePeriodRange(int index, List periods) {
  // TODO need to sub the second date by 1 day !
  if (index == 0) {
    //DateFormat()
    return '??? -- ${formatter.format(periods[0])}';
  } if (index == periods.length) {
    return '${formatter.format(periods.last)} -- ???';
  }
  return '${formatter.format(periods[index-1])} -- ${formatter.format(periods[index])}';
}
