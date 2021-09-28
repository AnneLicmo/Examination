class AppException {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class SocketDataException extends AppException {
  SocketDataException([var message]) : super(message, "");
}

class FetchDataException extends AppException {
  FetchDataException([var message]) : super(message, '');
}

class BadRequestException extends AppException {
  BadRequestException([var message]) : super(message, '');
}

class UnauthorisedException extends AppException {
  UnauthorisedException([var message]) : super(message, '');
}

class InvalidInputException extends AppException {
  InvalidInputException([var message]) : super(message, '');
}

class AuthenticationException extends AppException {
  AuthenticationException([var message]) : super(message, '');
}

class SupportException extends AppException {
  SupportException([var message]) : super(message, '');
}
