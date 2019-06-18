import 'dart:async';
import 'dart:convert' as Convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

typedef RequestCompletion = void Function(Map data);

class HttpRequest {
    static requestGET (
      String authority, String unencodedPath, RequestCompletion completion,
      [Map<String, String> queryParameters]) async {
    try {
      var httpClient = new HttpClient();
      var uri = new Uri.http(authority, unencodedPath, queryParameters);
      var request = await httpClient.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(Convert.utf8.decoder).join();
      Map data = Convert.jsonDecode(responseBody);
      completion(data);
    } on Exception catch (e) {
      print("Request(Get has error): " + e.toString());
    }
  }
    final baseUrl;

    final dio = Dio();

    HttpRequest(this.baseUrl);

  // get request
  Future<dynamic> get(String url, {Map<String, String> headers}) async {
    try {
      // 构建请求
      http.Response response = await http.get(this.baseUrl + url, headers: headers);
      final statusCode = response.statusCode;
      final body = response.body;
      print('[uri=$url][statusCode=$statusCode][response=$body]');
      var result = Convert.jsonDecode(body);
      return result;
    } on Exception catch (e) {
      print('[uri=$url]exception e=${e.toString()}');
      return '';
    }
  }
  // POST Request
  Future<dynamic> post(String url, dynamic body, {Map<String, String> headers}) async {
    try {
      http.Response response = await http.post(this.baseUrl + url, body: body, headers: headers);
      final statusCode = response.statusCode;
      final responseBody = response.body;
      var result = Convert.jsonDecode(responseBody);
      print('[uri=$url][statusCode=$statusCode][response=$responseBody]');
      return result;
    } on Exception catch (e) {
      print('[uri=$url]exception e=${e.toString()}');
      return '';
    }
  }
  // PUT Request
  Future<dynamic> put(String url, dynamic body, {Map<String, String> headers}) async {
    try {
      http.Response response = await http.put(this.baseUrl + url, body: body, headers: headers);
      final statusCode = response.statusCode;
      final responseBody = response.body;
      var result = Convert.jsonDecode(responseBody);
      print('[uri=$url][statusCode=$statusCode][response=$responseBody]');
      return result;
    } on Exception catch (e) {
      print('[uri=$url]exception e=${e.toString()}');
      return '';
    }
  }
  // DELETE Request
  Future<dynamic> delete(String url, {Map<String, String> headers}) async {
    try {
      http.Response response = await http.delete(this.baseUrl + url, headers: headers);
      final statusCode = response.statusCode;
      final responseBody = response.body;
      var result = Convert.jsonDecode(responseBody);
      print('[uri=$url][statusCode=$statusCode][response=$responseBody]');
      return result;
    } on Exception catch (e) {
      print('[uri=$url]exception e=${e.toString()}');
      return '';
    }
  }

}