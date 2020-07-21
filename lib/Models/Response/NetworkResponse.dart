import 'dart:convert';

class NetworkResponse {
  final String message;

  NetworkResponse({this.message});

  factory NetworkResponse.fromRawJson(String str) =>
      NetworkResponse.fromJson(json.decode(str));

  factory NetworkResponse.fromJson(Map<String, dynamic> json) =>
      NetworkResponse(message: json['message']['text']);

  factory NetworkResponse.jsonParse(String str) =>
      json.decode(str)['message']['text'];

  Map<String, dynamic> toJson() => {"message": message};
}
