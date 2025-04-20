// ignore_for_file: camel_case_types

import 'dart:convert'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_api_demo/movie.dart';

class httpHelper {
  final String urlBase = "https://api.themoviedb.org/3/movie";
  final String urlUpcoming = "/upcoming?";
  final String apiKey = "api_key=${dotenv.env['API_KEY']}";
  final String language = "&language=fr-FR";

  Future<List<Movie>> getUpcoming() async {
    if (dotenv.env['API_KEY'] == null || dotenv.env['API_KEY']!.isEmpty) {
      throw Exception('API_KEY is missing in the .env file');
    }

    final url = "$urlBase$urlUpcoming$apiKey$language";
    http.Response result = await http.get(Uri.parse(url));

    if (result.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(result.body);
      final List moviesMap = jsonResponse['results'];
      List<Movie> movies = moviesMap.map((json) => Movie.fromJson(json)).toList();
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final List<Movie> upcomingMovies = await getUpcoming();
    final List<Movie> searchResult = upcomingMovies.where((movie) => movie.title.toLowerCase().contains(query.toLowerCase())).toList();
    return searchResult;
  }
}
