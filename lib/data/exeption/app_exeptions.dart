class AppExeptions implements Exception {
  final prefix;
  final message;

  AppExeptions([this.prefix, this.message]);

  @override
  String toString() {
    return "$prefix $message";
  }
}

class NoInternetExeption extends AppExeptions {
  NoInternetExeption([String? message]) : super(message, "NoInternetExeption");
}

class RequestTimeOutExeption extends AppExeptions {
  RequestTimeOutExeption([String? message])
      : super(message, "Request TimeOut");
}

class InternalSeverExeption extends AppExeptions {
  InternalSeverExeption([String? message])
      : super(message, "InternalSeverExeption");
}
