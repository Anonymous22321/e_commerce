import 'package:e_commerce/core/api/api_endpoints.dart';





class ErrorModel {
  String code, doc_url, message, type;
  String? param;

  ErrorModel({
    required this.code,
    required this.doc_url,
    required this.message,
    this.param,
    required this.type,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> map) {
    final error = map[ApiKeys.error] ?? {};
    return ErrorModel(
      code: error[ApiKeys.code]?.toString() ?? "unknown",
      doc_url: error[ApiKeys.doc_url]?.toString() ?? "",
      message: error[ApiKeys.message]?.toString() ?? "An unexpected error occurred",
      param: error[ApiKeys.param]?.toString(),
      type: error[ApiKeys.type]?.toString() ?? "unknown",
    );
  }
}
