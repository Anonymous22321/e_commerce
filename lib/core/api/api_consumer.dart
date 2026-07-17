abstract class ApiConsumer {
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  });

  Future post(
    String path, {
    dynamic data,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  });

  Future delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  });
}
