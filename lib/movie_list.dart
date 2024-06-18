import 'package:flutter/material.dart';
import 'movie_manager.dart';
import 'movie_detail.dart';
import 'booking.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final MovieManager movieManager = MovieManager();

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    await movieManager.loadMoviesFromTxt('assets/movieInfo.txt');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '예매 차트',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red, // 상단바 배경색을 빨간색으로 설정
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: movieManager.movies.length,
                itemBuilder: (context, index) {
                  final movie = movieManager.movies[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailScreen(movieId: movie.id),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            movie.imageUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              movie.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '감독: ${movie.director}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '출연진: ${movie.cast.join(', ')}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text('나의 예매 내역'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('이벤트'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
