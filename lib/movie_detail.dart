import 'package:flutter/material.dart';
import 'package:movie_api_demo/movie.dart';

class MovieDetail extends StatelessWidget {
  final Movie movie;
  const MovieDetail({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              movie.posterPath,
              height: 500,
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(child: Text(movie.title, style: const TextStyle(fontSize: 30))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("Sortie le : ${movie.releaseDate}", style: const TextStyle(fontSize: 20))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Text(movie.overview),
            ),
          ],
        ),
      ),
    );
  }
}
