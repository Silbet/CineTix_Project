import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'make_reservation.dart';

class BookingListScreen extends StatefulWidget {
  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  Future<Map<String, dynamic>> readMovieDetails() async {
    String jsonString = await rootBundle.loadString('assets/movieDetail.txt');
    return jsonDecode(jsonString);
  }

  Future<String> fetchMovieTitle(String movieId) async {
    try {
      Map<String, dynamic> movieDetails = await readMovieDetails();
      if (movieDetails.containsKey(movieId)) {
        return movieDetails[movieId]['title'];
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print('Error fetching movie title: $e');
      return 'Unknown';
    }
  }

  void cancelBooking(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('예매 취소하기'),
        content: Text(
            '정말 취소하시겠습니까? 총 환불 금액은 ${bookings[index].selectedAudienceCount * 12000}원입니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                bookings.removeAt(index);
                seatBooked.clear(); // 선택된 좌석 초기화
              });
              Navigator.of(context).pop();
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('예매 내역'),
      ),
      body: FutureBuilder(
        future: readMovieDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                Booking booking = bookings[index];
                return ListTile(
                  title: FutureBuilder(
                    future: fetchMovieTitle(booking.movieId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        String movieTitle = snapshot.data.toString();
                        return Text('영화 제목: $movieTitle');
                      }
                    },
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('예매 날짜: ${booking.formattedDate()}'),
                      Text('시간대: ${booking.selectedTimeSlot}'),
                      Text('관람 인원: ${booking.selectedAudienceCount} 인'),
                      Text('좌석: ${booking.selectedSeats.join(', ')}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      cancelBooking(index);
                    },
                    child: Text('예매 취소하기'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Booking {
  final String movieId;
  final DateTime selectedDate;
  final String selectedTimeSlot;
  final int selectedAudienceCount;
  final List<String> selectedSeats;

  Booking({
    required this.movieId,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.selectedAudienceCount,
    required this.selectedSeats,
  });

  String formattedDate() {
    return DateFormat('yyyy-MM-dd').format(selectedDate.toLocal());
  }
}
