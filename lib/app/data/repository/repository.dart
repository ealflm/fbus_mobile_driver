import '../models/notification_model.dart';
import '../models/route_model.dart';
import '../models/selected_trip_model.dart';
import '../models/statistic_model.dart';
import '../models/student_count_model.dart';
import '../models/student_trip_model.dart';
import '../models/trip_model.dart';
import '../models/tripx_model.dart';

abstract class Repository {
  /// Base login.
  ///
  /// Return token string.
  Future<String> login(String phoneNumber, String password);

  /// Return list of route
  Future<List<Route>> getRoute();

  /// Get trip with routeId and datetime
  Future<List<Tripx>> getTrip(
      String routeId, DateTime dateTime, SelectedTrip selectedTrip);

  /// Booking trip
  Future<void> bookTrip(
      String driverId, String tripId, String selectedStationId, bool type);

  /// Register notification
  Future<void> registerNotification(String driverId, String code);

  /// Get list of notification
  Future<List<Notification>> getNotifications(String driverId);

  /// Get ticket list
  Future<List<Ticket>> getTickets(String driverId);

  /// Get current Ticket
  Future<Ticket?> getCurrentTicket(String driverId);

  /// Get current Ticket
  Future<Statistic> getStatistic(String driverId);

  // Check in
  Future<void> checkin(String driverId, String code);

  // Feedback a trip by studenTripId
  Future<void> feedback(String studentTripId, double rate, String message);

  // Delete a trip by studenTripId
  Future<void> removeTrip(String studentTripId);

  // Fetch future trips
  Future<List<Trip>> getFutureTrips(String driverId);

  // Fetch past trips
  Future<List<Trip>> getPastTrips(String driverId);

  // Fetch student count list
  Future<List<StudentCount>> getStudentCounts(String tripId);

  // Change password
  Future<void> changePassword(
      String phoneNumber, String oldPassword, String newPassword);
}
