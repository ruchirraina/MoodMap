import 'package:flutter/widgets.dart';

void trySignIn(GlobalKey<FormState> formKey) {
  // validate form
  formKey.currentState?.validate();
}
