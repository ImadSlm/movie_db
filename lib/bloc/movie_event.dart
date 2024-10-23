abstract class MovieEvent {}

class FetchUpcomingMovies extends MovieEvent {}
class SearchMovies extends MovieEvent {
  final String query;
  SearchMovies(this.query);
}