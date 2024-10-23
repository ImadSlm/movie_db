import 'package:movie_api_demo/movie.dart';

abstract class MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
    final List<Movie> movies;
    MovieLoaded(this.movies);
}

class MovieError extends MovieState {
    final String errmsg;
    MovieError(this.errmsg);
}