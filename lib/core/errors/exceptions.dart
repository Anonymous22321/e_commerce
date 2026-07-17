import 'package:dio/dio.dart';
import 'package:e_commerce/core/errors/error_model.dart';

class ServerExceptions implements Exception{
  final ErrorModel errorModel;

  const ServerExceptions({
    required this.errorModel,
  });
}


void handleDioExceptions(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ServerExceptions(
        errorModel: ErrorModel.fromJson(e.response!.data),
      );

    case DioExceptionType.sendTimeout:
      throw ServerExceptions(
        errorModel: ErrorModel.fromJson(e.response!.data),
      );

    case DioExceptionType.receiveTimeout:
      throw ServerExceptions(
        errorModel: ErrorModel.fromJson(e.response!.data),
      );

    case DioExceptionType.badCertificate:
      throw ServerExceptions(
        errorModel: ErrorModel.fromJson(e.response!.data),
      );
    case DioExceptionType.cancel:
      throw ServerExceptions(
        errorModel: ErrorModel.fromJson(e.response!.data),
      );
    case DioExceptionType.connectionError:
      throw ServerExceptions(
        errorModel: ErrorModel.fromJson(e.response!.data),
      );
    case DioExceptionType.unknown:
      throw ServerExceptions(
        errorModel: ErrorModel.fromJson(e.response!.data),
      );

  /// only this mean that request reached server others not even
  /// reach server
    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400: // Bad request
          throw ServerExceptions(
            errorModel: ErrorModel.fromJson(e.response!.data),
          );

        case 401: // Un authorized
          throw ServerExceptions(
            errorModel: ErrorModel.fromJson(e.response!.data),
          );

        case 402: // Payment required
          throw ServerExceptions(
            errorModel: ErrorModel.fromJson(e.response!.data),
          );

        case 403: // Forbidden
          throw ServerExceptions(
            errorModel: ErrorModel.fromJson(e.response!.data),
          );

        case 404: // Not Found
          throw ServerExceptions(
            errorModel: ErrorModel.fromJson(e.response!.data),
          );

        case 500: // Server Exception
          throw ServerExceptions(
            errorModel: ErrorModel.fromJson(e.response!.data),
          );

      }
  }
}

