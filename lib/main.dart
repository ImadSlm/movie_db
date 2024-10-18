import 'package:flutter/material.dart';
import 'package:movie_api_demo/http_helper.dart';
import 'package:movie_api_demo/movie.dart';
import 'package:movie_api_demo/movie_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie DB',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Movie DB'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  httpHelper httphelper = httpHelper();
  List<Movie> moviesList = [];
  String imagebaseUrl = "https://image.tmdb.org/t/p/w92/";

  @override
  void initState() {
    super.initState();
    httphelper.getUpcoming().then((moviesList) {
      setState(() {
        this.moviesList = moviesList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: moviesList.length,
            itemBuilder: (context, index) {
              Movie movie = moviesList[index];
              return ListTile(
                title: Text(movie.title),
                subtitle: Text('Sortie : ${movie.releaseDate}'),
                leading: Image.network(
                  movie.posterPath,
                  width: 100,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetail(movie: movie),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
