import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioModule {
  @injectable
  Dio createDio() {
    final dio = Dio();
    dio.transformer = _JsonTransformer();
    return dio;
  }
}

class _JsonTransformer extends DefaultTransformer {
  _JsonTransformer() : super(jsonDecodeCallback: _parseJson);

  @override
  Future transformResponse(RequestOptions options, ResponseBody response) {
    response.headers['content-type'] = ['application/json'];
    return super.transformResponse(options, response);
  }
}

// Must be top-level function
dynamic _parseAndDecode(String response) {
  return jsonDecode(response);
}

Future _parseJson(String text) {
  return compute(_parseAndDecode, text);
}
