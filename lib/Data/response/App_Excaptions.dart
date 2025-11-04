class AppException implements Exception{


final _message;
final _prifix;
  AppException([this._message, this._prifix]);

  String toString(){
    return '$_prifix$_message';
  }
}


class FetchDataException extends AppException{

  FetchDataException([String? message]) :super (message, 'error During Communication');

}

class BadRequestException extends AppException{

  BadRequestException([String? message]) :super (message, 'Invalid Request');

}

class UnauthorizeException extends AppException{

  UnauthorizeException([String? message]) :super (message, 'UnauthorizeException Request');

}

class InvalidInputException extends AppException{

 InvalidInputException([String? message]) :super (message, 'Invalid Input');

}