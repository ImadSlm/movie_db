// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_api_demo/movie.dart';

class httpHelper {
  final String urlBase = "https://api.themoviedb.org/3/movie";
  final String urlUpcoming = "/upcoming?";
  final String apiKey = "api_key=07c2ece398332e13310af832a90646fc";
  final String language = "&language=fr-FR";

  Future<List<Movie>> getUpcoming() async {
    final url = "$urlBase$urlUpcoming$apiKey$language";
    http.Response result = await http.get(Uri.parse(url));

    if (result.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(result.body);
      final List moviesMap = jsonResponse['results'];
      List<Movie> movies = moviesMap.map((json) => Movie.fromJson(json)).toList();
      return movies;
    } else {
      return [];
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = "$urlBase$urlUpcoming$apiKey$language&query=$query";
    http.Response result = await http.get(Uri.parse(url));

    if (result.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(result.body);
      final List moviesMap = jsonResponse['results'];
      List<Movie> movies = moviesMap.map((json) => Movie.fromJson(json)).toList();
      return movies;
    } else {
      return [];
    }
  }
}
