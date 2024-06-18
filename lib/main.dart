import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineTix',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0x800020),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';

  // Sample user data
  final Map<String, String> _users = {
    'test@example.com': 'password123',
    'admin@example.com': 'admin123' // Admin account added
  };

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (_users.containsKey(email) && _users[email] == password) {
      setState(() {
        _errorMessage = '';
      });
      if (email == 'admin@example.com') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    } else {
      setState(() {
        _errorMessage = '이메일 또는 비밀번호가 잘못되었습니다.';
      });
    }
  }

  void _register() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _users[email] = password;
        _errorMessage = '';
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      setState(() {
        _errorMessage = '올바른 이메일과 비밀번호를 입력해주세요.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie, size: 100, color: Color(0x800020)),
              SizedBox(height: 20),
              Text(
                'CineTix',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0x800020)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  backgroundColor: Color(0x800020),
                  textStyle: TextStyle(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('로그인'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  backgroundColor: Color(0x800020),
                  textStyle: TextStyle(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('회원가입'),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Color(0x800020)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메인 메뉴', style: TextStyle(fontSize: 28, fontFamily: 'Raleway')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovieListScreen(forBooking: true)),
                );
              },
              child: Text('예매하기'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                backgroundColor: Color(0x800020),
                textStyle: TextStyle(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingInfoScreen()),
                );
              },
              child: Text('예매 정보'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                backgroundColor: Color(0x800020),
                textStyle: TextStyle(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovieListScreen(forBooking: false)),
                );
              },
              child: Text('영화 목록'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                backgroundColor: Color(0x800020),
                textStyle: TextStyle(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('관리자 페이지', style: TextStyle(fontSize: 28, fontFamily: 'Raleway')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMovieScreen()),
                );
              },
              child: Text('영화 등록'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                backgroundColor: Color(0x800020),
                textStyle: TextStyle(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteMovieScreen()),
                );
              },
              child: Text('영화 삭제'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                backgroundColor: Color(0x800020),
                textStyle: TextStyle(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovieListScreen(forBooking: false)),
                );
              },
              child: Text('영화 목록'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                backgroundColor: Color(0x800020),
                textStyle: TextStyle(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserListScreen()),
                );
              },
              child: Text('회원 정보'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                backgroundColor: Color(0x800020),
                textStyle: TextStyle(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  final bool forBooking;

  MovieListScreen({required this.forBooking});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  static List<Map<String, dynamic>> movies = [
    {'title': '범죄도시 4', 'age': 15},
    {'title': '퓨리오사-매드맥스 사가', 'age': 18},
    {'title': '극장판 하이큐!! 쓰레기장의 결전', 'age': 12},
    {'title': '설계자', 'age': 15},
    {'title': '혹성탈출-새로운 시대', 'age': 12},
  ];

  static List<Map<String, dynamic>> bookings = [];

  void _addMovie(String title, int age) {
    setState(() {
      movies.add({'title': title, 'age': age});
    });
  }

  void _deleteMovie(String title) {
    setState(() {
      movies.removeWhere((movie) => movie['title'] == title);
    });
  }

  void _addBooking(String movieTitle, String seat, DateTime date, String time) {
    setState(() {
      bookings.add({'movieTitle': movieTitle, 'seat': seat, 'date': date, 'time': time});
    });
  }

  bool _isSeatBooked(String movieTitle, String seat, DateTime date, String time) {
    return bookings.any((booking) =>
        booking['movieTitle'] == movieTitle &&
        booking['seat'] == seat &&
        booking['date'] == date &&
        booking['time'] == time);
  }

  Icon _getAgeIcon(int age) {
    if (age == 12) {
      return Icon(Icons.looks_one, color: Colors.blue);
    } else if (age == 15) {
      return Icon(Icons.looks_two, color: Colors.orange);
    } else if (age == 18) {
      return Icon(Icons.looks_3, color: Colors.red);
    } else {
      return Icon(Icons.looks_4, color: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.forBooking ? '예매하기' : '영화 목록'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => widget.forBooking ? MainScreen() : AdminScreen()),
            );
          },
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: _getAgeIcon(movies[index]['age']),
              title: Text(movies[index]['title']),
              onTap: () {
                if (widget.forBooking) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DateSelectionScreen(
                        movieTitle: movies[index]['title'],
                        addBooking: _addBooking,
                        isSeatBooked: _isSeatBooked,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movieTitle: movies[index]['title']),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class AddMovieScreen extends StatefulWidget {
  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  void _addMovie() {
    String title = _titleController.text;
    int age = int.parse(_ageController.text);

    if (title.isNotEmpty && age > 0) {
      _MovieListScreenState.movies.add({'title': title, 'age': age});
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('영화 등록'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '영화 제목',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: '상영 등급',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addMovie,
              child: Text('영화 등록'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                backgroundColor: Color(0x800020),
                textStyle: TextStyle(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteMovieScreen extends StatefulWidget {
  @override
  _DeleteMovieScreenState createState() => _DeleteMovieScreenState();
}

class _DeleteMovieScreenState extends State<DeleteMovieScreen> {
  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 하시겠습니까?'),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                setState(() {
                  _MovieListScreenState.movies.removeAt(index);
                });
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('영화 삭제'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminScreen()),
            );
          },
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: _MovieListScreenState.movies.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text(_MovieListScreenState.movies[index]['title']),
              onTap: () => _confirmDelete(index),
            ),
          );
        },
      ),
    );
  }
}

class UserListScreen extends StatelessWidget {
  final List<Map<String, String>> _users = [
    {'email': 'test@example.com', 'password': 'password123'},
    {'email': 'admin@example.com', 'password': 'admin123'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원 정보'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminScreen()),
            );
          },
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text(_users[index]['email']!),
              subtitle: Text('비밀번호: ${_users[index]['password']}'),
            ),
          );
        },
      ),
    );
  }
}

class DateSelectionScreen extends StatefulWidget {
  final String movieTitle;
  final Function(String, String, DateTime, String) addBooking;
  final Function(String, String, DateTime, String) isSeatBooked;

  DateSelectionScreen({required this.movieTitle, required this.addBooking, required this.isSeatBooked});

  @override
  _DateSelectionScreenState createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('날짜 선택'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MovieListScreen(forBooking: true)),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.movieTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime(2101),
              focusedDay: DateTime.now(),
              selectedDayPredicate: (day) {
                return isSameDay(selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  selectedDate = selectedDay;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedDate == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimeSelectionScreen(
                            movieTitle: widget.movieTitle,
                            selectedDate: selectedDate!,
                            addBooking: widget.addBooking,
                            isSeatBooked: widget.isSeatBooked,
                          ),
                        ),
                      );
                    },
              child: Text('다음'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: selectedDate == null ? Colors.grey : Color(0x800020),
                textStyle: TextStyle(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeSelectionScreen extends StatelessWidget {
  final String movieTitle;
  final DateTime selectedDate;
  final Function(String, String, DateTime, String) addBooking;
  final Function(String, String, DateTime, String) isSeatBooked;

  TimeSelectionScreen({required this.movieTitle, required this.selectedDate, required this.addBooking, required this.isSeatBooked});

  final List<Map<String, dynamic>> times = [
    {'time': '7:30 AM', 'seatsLeft': 170},
    {'time': '9:00 AM', 'seatsLeft': 170},
    {'time': '10:20 AM', 'seatsLeft': 170},
    {'time': '12:00 PM', 'seatsLeft': 165},
    {'time': '3:00 PM', 'seatsLeft': 170},
    {'time': '5:20 PM', 'seatsLeft': 166},
    {'time': '7:30 PM', 'seatsLeft': 170},
    {'time': '9:00 PM', 'seatsLeft': 170},
    {'time': '10:30 PM', 'seatsLeft': 170},
    {'time': '11:45 PM', 'seatsLeft': 170},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('시간 선택'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DateSelectionScreen(movieTitle: movieTitle, addBooking: addBooking, isSeatBooked: isSeatBooked)),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movieTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('시간 선택:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Expanded(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: times.map((time) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeatSelectionScreen(
                            movieTitle: movieTitle,
                            selectedDate: selectedDate,
                            selectedTime: time['time'],
                            addBooking: addBooking,
                            isSeatBooked: isSeatBooked,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0x800020),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.access_time, size: 30, color: Colors.white), // Increase icon size
                        SizedBox(height: 5),
                        Text(
                          time['time'],
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          '${time['seatsLeft']} 좌석 남음',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SeatSelectionScreen extends StatelessWidget {
  final String movieTitle;
  final DateTime selectedDate;
  final String selectedTime;
  final Function(String, String, DateTime, String) addBooking;
  final Function(String, String, DateTime, String) isSeatBooked;

  SeatSelectionScreen({
    required this.movieTitle,
    required this.selectedDate,
    required this.selectedTime,
    required this.addBooking,
    required this.isSeatBooked,
  });

  final List<List<String>> seats = List.generate(
    5,
    (i) => List.generate(5, (j) => 'Seat ${i + 1}-${j + 1}'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('좌석 선택'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TimeSelectionScreen(movieTitle: movieTitle, selectedDate: selectedDate, addBooking: addBooking, isSeatBooked: isSeatBooked)),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(Icons.tv, size: 50, color: Colors.grey),
                  Text(
                    'SCREEN',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: 25,
                itemBuilder: (context, index) {
                  int row = index ~/ 5;
                  int col = index % 5;
                  String seat = seats[row][col];
                  bool isBooked = isSeatBooked(movieTitle, seat, selectedDate, selectedTime);
                  return ElevatedButton(
                    onPressed: isBooked
                        ? null
                        : () {
                            addBooking(movieTitle, seat, selectedDate, selectedTime);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(
                                  movieTitle: movieTitle,
                                  selectedDate: selectedDate,
                                  selectedTime: selectedTime,
                                  selectedSeat: seat,
                                ),
                              ),
                            );
                          },
                    child: Text(seat, style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: isBooked ? Colors.grey : Color(0x800020),
                      textStyle: TextStyle(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  final String movieTitle;
  final DateTime selectedDate;
  final String selectedTime;
  final String selectedSeat;

  PaymentScreen({
    required this.movieTitle,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedSeat,
  });

  final List<String> paymentMethods = [
    '신용카드',
    '모바일 결제',
    '은행 이체',
    '토스',
    '카카오페이'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('결제'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SeatSelectionScreen(movieTitle: movieTitle, selectedDate: selectedDate, selectedTime: selectedTime, addBooking: (a, b, c, d) {}, isSeatBooked: (a, b, c, d) => false)),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movieTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('결제 수단 선택:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(paymentMethods[index]),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${paymentMethods[index]}로 결제 완료')),
                        );
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingInfoScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingInfoScreen extends StatelessWidget {
  final List<String> bookedMovies = [
    '범죄도시 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('예매 정보'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          },
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: bookedMovies.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: Icon(Icons.movie, color: Color(0x800020)),
              title: Text(bookedMovies[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movieTitle: bookedMovies[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class MovieDetailScreen extends StatelessWidget {
  final String movieTitle;

  MovieDetailScreen({required this.movieTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('영화 정보'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movieTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('영화에 대한 자세한 정보가 여기에 표시됩니다...', style: TextStyle(fontSize: 18)),
            // Add more details about the movie
          ],
        ),
      ),
    );
  }
}
