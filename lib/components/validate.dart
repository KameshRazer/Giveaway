String emailValidator(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Email format is invalid';
  } else {
    return null;
  }
}

String pwdValidator(String value) {
  if (value.length < 8) {
    return 'Password must be longer than 8 characters';
  } else {
    return null;
  }
}

String phoneNoValidator(String value) {
  if (value.length < 10 || value.contains('.') || value.contains(',')) {
    return 'Invalid Phone Number';
  } else {
    return null;
  }
}

String nameValidator(String value) {
  if (value.length == 0) {
    return 'Enter Name';
  } else {
    return null;
  }
}
