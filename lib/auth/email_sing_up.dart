import 'package:flutter/widgets.dart';

void trySignUp(GlobalKey<FormState> formKey) {
  // validate form
  formKey.currentState?.validate();
}
