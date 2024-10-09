import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:produce_api/data/exeption/app_exeptions.dart';
import 'package:produce_api/data/network/api_servise.dart';
import 'package:http/http.dart' as http;

class NetworkServise implements ApiServise {
  @override
  Future getApi(String url) async {
    dynamic jsonResponse;
    try {
      var respone =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));

      switch (respone.statusCode) {
        case 200:
          jsonResponse = jsonDecode(respone.body);
          break;
        case 500:
          InternalSeverExeption("Server not responding");
      }
    } on SocketException {
      throw NoInternetExeption("NoInternetConnection");
    } on TimeoutException {
      throw TimeoutException("TimeoutException");
    } catch (e) {
      debugPrint("-----Catch:$e");
    }
    return jsonResponse;
  }

  @override
  Future postApi(String url, {requestJson}) async {
    dynamic jsonResponse;
    try {
      var respone = await http
          .post(
            Uri.parse(url),
            headers: {"content-type": "Application/json"},
            body: jsonEncode(requestJson),
          )
          .timeout(const Duration(milliseconds: 500));

      switch (respone.statusCode) {
        case 200:
          jsonResponse = jsonDecode(respone.body);
          break;
        case 500:
          InternalSeverExeption("Server not responding");
      }
    } on SocketException {
      throw NoInternetExeption("NoInternetConnection");
    } on TimeoutException {
      throw TimeoutException("TimeoutException");
    } catch (e) {
      debugPrint("-----Catch:$e");
    }
    return jsonResponse;
  }
}
