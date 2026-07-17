import 'package:e_commerce/core/api/api_endpoints.dart';

import 'package:e_commerce/core/api/api_endpoints.dart';

import 'package:e_commerce/core/api/api_endpoints.dart';

import 'package:e_commerce/core/api/api_endpoints.dart';

import 'package:e_commerce/core/api/api_endpoints.dart';

class ErrorModel {
  String code,doc_url,message, type;
  String? param;

  ErrorModel({
    required this.code,
    required this.doc_url,
    required this.message,
     this.param,
    required this.type,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> map) {
    return ErrorModel(
      code: map[ApiKeys.error][ApiKeys.code] as String,
      doc_url: map[ApiKeys.error][ApiKeys.doc_url] as String,
      message: map[ApiKeys.error][ApiKeys.message] as String,
      param: map[ApiKeys.error][ApiKeys.param] as String,
      type: map[ApiKeys.error][ApiKeys.type] as String,
    );
  }
}