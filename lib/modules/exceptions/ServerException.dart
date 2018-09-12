class ServerException implements Exception{
  String cause;
  ServerException({this.cause});
}