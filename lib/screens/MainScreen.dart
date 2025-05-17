import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'MyScreen.dart';
import 'PetScreen.dart';
import 'ProfileScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final List<RoomBooking> _bookedRooms = [];

  final List<Widget> _screens = [];

  @override
void initState() {
  super.initState();
    _screens.addAll([
      HomeScreen(
        bookedRooms: _bookedRooms,
        onBook: (roomNumber, startDate, endDate) => setState(() {
          _bookedRooms.insert(
            0,
            RoomBooking(
              roomNumber: roomNumber,
              startDate: startDate,
              endDate: endDate,
            ),
          );
        }),
        onCancel: (roomNumber) => setState(() {
          _bookedRooms.removeWhere((booking) => booking.roomNumber == roomNumber);
        }),
      ),
      MyScreen(
        bookedRooms: _bookedRooms,
        onCancelBooking: (roomNumber) {
          setState(() {
            _bookedRooms.removeWhere((b) => b.roomNumber == roomNumber);
          });
        },
      ),
      BotChatScreen(),
      ProfileScreen(),
    ]);

}

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade100, Colors.grey.shade300],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: _onPageChanged,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Бронь'),
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Номера'),
              BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Питомец'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
            ],
          ),
        ),
      ),
    );
  }
}