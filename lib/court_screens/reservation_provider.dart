import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/material.dart';

class ReservationProvider with ChangeNotifier {
  List<CourtsBooking> _reservations = [];

  List<CourtsBooking> get reservations => _reservations;

  void addReservation(CourtsBooking reservation) {
    _reservations.add(reservation);
    notifyListeners(); // Notify UI to update
  }

  void clearReservations() {
    _reservations.clear();
    notifyListeners();
  }
}
