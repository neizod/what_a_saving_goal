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
