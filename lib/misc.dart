import 'dart:math';

import 'package:flutter/material.dart';

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


List<int> listSumPerPeriods(DateTime startDate, DateTime endDate,
                            String periodType, List sortedPaids) {
  List<DateTime> periods = listPeriods(startDate, endDate, periodType);
  List<int> sums = List<int>.filled(periods.length+1, 0);
  int j = 0;
  for (int i = 0; i < periods.length; i++) {
    while (j < sortedPaids.length && sortedPaids[j]['date'].isBefore(periods[i])) {
      sums[i] += sortedPaids[j]['amount'] as int;
      j += 1;
    }
    if (j == sortedPaids.length) {
      break;
    }
  }
  while (j < sortedPaids.length) {
    sums[periods.length] += sortedPaids[j]['amount'] as int;
    j += 1;
  }
  return sums;
}


int getSumPaidOfCurrentPeriod(DateTime startDate, String periodType, List sortedPaids) {
  DateTime current = DateTime.now();
  if (current.isBefore(startDate)) {
    current = startDate;
  }
  List<DateTime> periods = listPeriods(startDate, current, periodType);
  List<int> sums = listSumPerPeriods(startDate, current, periodType, sortedPaids);
  for (int i = 0; i < periods.length; i++) {
    if (current.isBefore(periods[i])) {
      return sums[i];
    }
  }
  return sums[periods.length];
}
