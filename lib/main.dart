// ignore_for_file: prefer_const_constructors, use_function_type_syntax_for_parameters

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_api_demo/bloc/movie_bloc.dart';
import 'package:movie_api_demo/bloc/movie_event.dart';
import 'package:movie_api_demo/bloc/movie_state.dart';
import 'package:movie_api_demo/http_helper.dart';
import 'package:movie_api_demo/movie.dart';
import 'package:movie_api_demo/movie_detail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
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
      // home: const MyHomePage(title: 'Movie DB'),
      home: BlocProvider(
        create: (context) => MovieBloc()..add(FetchUpcomingMovies()),
        child: MyHomePage(title: 'Movie DB'),
      ),
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
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    httphelper.getUpcoming().then((moviesList) {
      setState(() {
        this.moviesList = moviesList;
      });
    });
  }

  void toggleSearch() {
    setState(() {
      isSearching = !isSearching;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            "IMADb",
            style: GoogleFonts.anton(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          
        ),
        backgroundColor: Colors.black,
        actions: [
          Text(
            "Absolute Cinema",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Roboto",
              fontSize: 20,
            ),
          ),
          SizedBox(width: 80),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: IconButton(
              icon: Icon(Icons.search),
              color: isSearching? Colors.amber : Colors.white,
              onPressed: toggleSearch,
            ),
          ),
        ],
      ),
      body: moviesHomePageBody(context, isSearching),
    );
  }
}

Center moviesHomePageBody(context, isSearching) {
  final TextEditingController searchController = TextEditingController();

  void submitSearch(String query) {
    if (query.isNotEmpty) {
      BlocProvider.of<MovieBloc>(context).add(SearchMovies(query));
    } else {
      BlocProvider.of<MovieBloc>(context).add(FetchUpcomingMovies());
    }
  }

  return Center(
    child: Column(
      children: [
        isSearching ? searchText(searchController, submitSearch) : SizedBox(height: 0),
        Expanded(
          child: BlocBuilder<MovieBloc, MovieState>(
            builder: (context, state) {
              if (state is MovieLoading) {
                return CircularProgressIndicator(
                  color: Colors.amber,
                  strokeWidth: 6,
                );
              } else if (state is MovieLoaded) {
                return ListView.builder(
                  itemCount: state.movies.length,
                  itemBuilder: (context, index) {
                    final movie = state.movies[index];
                    return ListTile(
                      title: Text(
                        movie.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          Text('Sortie : ${movie.releaseDate}'),
                          SizedBox(width: 40),
                          Text(movie.voteAverage.toStringAsFixed(1)),
                          Icon(Icons.star, color: Colors.amber),
                        ],
                      ),
                      leading: Image.network(
                        movie.posterPath,
                        width: 100,
                        height: 300,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetail(movie: movie),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is MovieError) {
                return Center(child: Text('Failed to fetch movies: ${state.errmsg}', style: TextStyle(color: Colors.red)));
              } else {
                return Center(child: Text('Unknown state'));
              }
            },
          ),
        ),
      ],
    ),
  );
}

TextField searchText(TextEditingController searchController, void submitSearch(String query)) {
  return TextField(
    controller: searchController,
    decoration: InputDecoration(
      hintText: 'Rechercher un film',
      suffixIcon: IconButton(
        icon: Icon(Icons.send),
        onPressed: () {
          final query = searchController.text;
          submitSearch(query);
        },
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
    ),
    onSubmitted: (query) {
      submitSearch(query);
    },
    onChanged: (query) {
      submitSearch(query);
    },
  );
}
