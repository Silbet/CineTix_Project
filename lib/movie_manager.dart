import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Movie {
  final String id; // 영화 ID
  final String title;
  final List<String> cast;
  final String director;
  final int audienceRating;
  final int ageRestriction;
  final String imageUrl;

  Movie({
    required this.id,
    required this.title,
    required this.cast,
    required this.director,
    required this.audienceRating,
    required this.ageRestriction,
    required this.imageUrl,
  });
}

class MovieCreator {
  static List<Movie> createMoviesFromJson(String jsonContent) {
    List<dynamic> jsonList = json.decode(jsonContent);
    return jsonList.map((json) {
      return Movie(
        id: json['id'],
        title: json['title'],
        cast: List<String>.from(json['cast']),
        director: json['director'],
        audienceRating: json['audienceRating'],
        ageRestriction: json['ageRestriction'],
        imageUrl: json['imageUrl'],
      );
    }).toList();
  }
}

class MovieManager {
  List<Movie> movies = [];

  Future<void> loadMoviesFromTxt(String filePath) async {
    try {
      String path =
          filePath.startsWith('assets/') ? filePath : 'assets/$filePath';

      String contents = await rootBundle.loadString(path);

      movies = MovieCreator.createMoviesFromJson(contents);
    } catch (e) {
      print('파일을 읽어오는 중 에러 발생: $e');
      movies.clear();
    }
  }
}
