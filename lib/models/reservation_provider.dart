import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/foundation.dart';
// Import your booking model

class ReservationProvider with ChangeNotifier {
  List<CourtsBooking> _reservations = [];

  List<CourtsBooking> get reservations => _reservations;

  void addReservation(CourtsBooking newReservation) {
    _reservations.add(newReservation);
    notifyListeners(); // Notify listeners to rebuild UI when data changes
  }

  void setReservations(List<CourtsBooking> reservations) {
    _reservations = reservations;
    notifyListeners();
  }

  void clearReservations() {
    _reservations.clear();
    notifyListeners();
  }
}
