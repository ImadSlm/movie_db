class Movie {
  int id;
  String title;
  double voteAverage;
  String releaseDate;
  String overview;
  String posterPath;

  Movie({
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.releaseDate,
    required this.overview,
    required this.posterPath,
  });

  Movie.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      title = json['title'],
      voteAverage = (json['vote_average']as num).toDouble(),
      releaseDate = json['release_date'],
      overview = json['overview'],
      posterPath = json['poster_path'] != null ? "https://image.tmdb.org/t/p/w500/"+json['poster_path'] : "https://via.placeholder.com/102";
}

