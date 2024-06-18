import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'payment.dart';
import 'booking.dart';

List<Booking> bookings = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Booking',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: DatePickerScreen(movieId: '1'),
    );
  }
}

class DatePickerScreen extends StatefulWidget {
  final String movieId;

  DatePickerScreen({required this.movieId});

  @override
  _DatePickerScreenState createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  DateTime? selectedDate;
  List<String> timeSlots = ["10:00 AM", "2:00 PM", "6:00 PM", "10:00 PM"];
  String? selectedTimeSlot;
  int? selectedAudienceCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('날짜 선택'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 30)),
              onDateChanged: (pickedDate) {
                setState(() {
                  selectedDate = pickedDate;
                });
              },
            ),
            if (selectedDate != null) ...[
              SizedBox(height: 20),
              DropdownButton<String>(
                hint: Text('시간대 선택'),
                value: selectedTimeSlot,
                onChanged: (newValue) {
                  setState(() {
                    selectedTimeSlot = newValue!;
                  });
                },
                items: timeSlots.map((time) {
                  return DropdownMenuItem(
                    child: new Text(time),
                    value: time,
                  );
                }).toList(),
              ),
            ],
            if (selectedTimeSlot != null) ...[
              SizedBox(height: 20),
              DropdownButton<int>(
                hint: Text('관람 인원 선택'),
                value: selectedAudienceCount,
                onChanged: (newValue) {
                  setState(() {
                    selectedAudienceCount = newValue!;
                  });
                },
                items: List.generate(10, (index) => index + 1).map((count) {
                  return DropdownMenuItem(
                    child: new Text('$count 명'),
                    value: count,
                  );
                }).toList(),
              ),
            ],
            if (selectedAudienceCount != null) ...[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SeatSelectionScreen(
                              movieId: widget.movieId,
                              selectedDate: selectedDate!,
                              selectedTimeSlot: selectedTimeSlot!,
                              selectedAudienceCount: selectedAudienceCount!,
                            )),
                  );
                },
                child: Text('좌석 선택'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SeatSelectionScreen extends StatefulWidget {
  final String movieId;
  final DateTime selectedDate;
  final String selectedTimeSlot;
  final int selectedAudienceCount;

  SeatSelectionScreen({
    required this.movieId,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.selectedAudienceCount,
  });

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

List<String> seatBooked = [];

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<List<bool>> seats =
      List.generate(6, (_) => List.generate(10, (_) => false));
  List<int> selectedSeats = [];
  final List<String> seatLabels = List.generate(6, (row) => 'ABCDEF'[row])
      .expand((row) => List.generate(10, (col) => '$row${col + 1}'))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('좌석 선택'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            color: Colors.grey,
            child: Center(
              child: Text(
                'SCREEN',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: seats.length * seats[0].length,
              itemBuilder: (context, index) {
                int row = index ~/ 10;
                int col = index % 10;
                bool isSelected = seats[row][col];
                bool isBooked = seatBooked.contains(seatLabels[index]);

                return GestureDetector(
                  onTap: () {
                    if (!isBooked && // 예약된 좌석이 아닌 경우에만 선택 가능하도록
                        !isSelected &&
                        selectedSeats.length < widget.selectedAudienceCount) {
                      setState(() {
                        seats[row][col] = true; // 선택된 좌석으로 표시
                        selectedSeats.add(index); // 선택된 좌석 목록에 추가
                        seatBooked.add(seatLabels[index]); // 예약된 좌석 리스트에 추가
                      });
                    } else if (isSelected) {
                      setState(() {
                        seats[row][col] = false; // 선택 취소된 좌석으로 표시
                        selectedSeats.remove(index); // 선택된 좌석 목록에서 제거
                        seatBooked.remove(seatLabels[index]); // 예약된 좌석 리스트에서 제거
                      });
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: isBooked
                        ? Colors.red
                        : (isSelected ? Colors.red : Colors.grey),
                    child: Text(seatLabels[index]),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          if (selectedSeats.length == widget.selectedAudienceCount)
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        movieId: widget.movieId,
                        selectedDate: widget.selectedDate,
                        selectedTimeSlot: widget.selectedTimeSlot,
                        selectedAudienceCount: widget.selectedAudienceCount,
                        selectedSeats: selectedSeats
                            .map((index) => seatLabels[index])
                            .toList(),
                      ),
                    ),
                  );
                },
                child: Text('결제하기'),
              ),
            ),
        ],
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  final String movieId;
  final DateTime selectedDate;
  final String selectedTimeSlot;
  final int selectedAudienceCount;
  final List<String> selectedSeats;

  PaymentScreen({
    required this.movieId,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.selectedAudienceCount,
    required this.selectedSeats,
  });

  @override
  Widget build(BuildContext context) {
    double totalAmount = selectedAudienceCount * 12000.0;

    Booking booking = Booking(
      movieId: movieId,
      selectedDate: selectedDate,
      selectedTimeSlot: selectedTimeSlot,
      selectedAudienceCount: selectedAudienceCount,
      selectedSeats: selectedSeats,
    );

    bookings.add(booking);

    void navigateToPaymentMethodSelection() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentMethodSelectionScreen(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('결제하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('영화 ID: $movieId'),
            Text(
                '날짜: ${DateFormat('yyyy-MM-dd').format(selectedDate.toLocal())}'),
            Text('시간대: $selectedTimeSlot'),
            Text('관람 인원: $selectedAudienceCount 인'),
            Text('좌석: ${selectedSeats.join(', ')}'),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  '결제 금액: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${NumberFormat.currency(locale: 'ko_KR', symbol: '₩').format(totalAmount)} ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '(${selectedAudienceCount} 인)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: navigateToPaymentMethodSelection,
              child: Text('결제하기'),
            ),
          ],
        ),
      ),
    );
  }
}
