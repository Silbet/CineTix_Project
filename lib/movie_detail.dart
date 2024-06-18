import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'make_reservation.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Details',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MovieDetailScreen(movieId: '1'),
    );
  }
}

class MovieDetailScreen extends StatelessWidget {
  final String movieId;

  MovieDetailScreen({required this.movieId});

  Future<Map<String, dynamic>> _loadMovieDetail() async {
    try {
      String detailPath = 'assets/movieDetail.txt';
      String infoPath = 'assets/movieInfo.txt';

      String detailContents = await rootBundle.loadString(detailPath);
      String infoContents = await rootBundle.loadString(infoPath);

      Map<String, dynamic> movieDetails = json.decode(detailContents);
      List<dynamic> movieInfos = json.decode(infoContents);

      Map<String, dynamic>? detail = movieDetails[movieId];
      if (detail == null) {
        throw Exception('Movie with id $movieId not found');
      }

      int? audienceRating;
      int? ageRestriction;
      for (var movie in movieInfos) {
        if (movie['id'] == movieId) {
          audienceRating = movie['audienceRating'];
          ageRestriction = movie['ageRestriction'];
          break;
        }
      }

      if (audienceRating == null || ageRestriction == null) {
        throw Exception(
            'Audience rating or age restriction not found for movie with id $movieId');
      }

      return {
        'title': detail['title'],
        'director': detail['director'],
        'cast': detail['cast'],
        'plot': detail['plot'],
        'imageUrl': detail['imageUrl'],
        'audienceRating': audienceRating,
        'ageRestriction': ageRestriction,
      };
    } catch (e) {
      print('Error loading movie detail: $e');
      throw Exception('Failed to load movie detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadMovieDetail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Loading...'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text('Failed to load movie detail'),
            ),
          );
        } else {
          var movieDetail = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(movieDetail['title']),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        movieDetail['imageUrl'],
                        width: 200,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movieDetail['title'],
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text('감독: ${movieDetail['director']}',
                                style: TextStyle(fontSize: 18)),
                            SizedBox(height: 10),
                            Text('출연진: ${movieDetail['cast'].join(', ')}',
                                style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10),
                            Text('관람 인원: ${movieDetail['audienceRating']}'),
                            SizedBox(height: 10),
                            Text('연령 제한: ${movieDetail['ageRestriction']}'),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DatePickerScreen(movieId: movieId)),
                                );
                              },
                              child: Text('예매하기'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    '줄거리: ${movieDetail['plot']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
