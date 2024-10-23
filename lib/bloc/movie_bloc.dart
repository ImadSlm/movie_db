// ignore_for_file: prefer_final_fields

import 'package:bloc/bloc.dart';
import 'package:movie_api_demo/bloc/movie_event.dart';
import 'package:movie_api_demo/bloc/movie_state.dart';
import 'package:movie_api_demo/http_helper.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  httpHelper _httpHelper = httpHelper();

  MovieBloc() : super(MovieLoading()){
    on<FetchUpcomingMovies>((event, emit) async {
      emit(MovieLoading());
      try {
        final moviesFetched = await _httpHelper.getUpcoming();
        emit(MovieLoaded(moviesFetched));
      } catch (e) {
        emit(MovieError(e.toString()));
      }
    });

    on<SearchMovies>((event, emit) async {
      emit(MovieLoading());
      try {
        final moviesQuery = await _httpHelper.searchMovies(event.query);
        emit(MovieLoaded(moviesQuery));
      } catch (e) {
        emit(MovieError(e.toString()));
      }
    });
  }
}
