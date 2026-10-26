import 'dart:convert';

import 'package:flutter_application_1/models/popular_model.dart';
import 'package:http/http.dart' as http;

class ApiPopular {
  Uri link = Uri.parse(
    "https://api.themoviedb.org/3/movie/popular?api_key=fae41dc0d9724b99048e978672356175",
  );
  Future<List<PopularModel>?> getAllPopular() async {
    var response = await http.get(link);
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.body)['results'] as List;
      return jsonResult
          .map((popular) => PopularModel.fromMap(popular))
          .toList();
    }
    return null;
  }
}
