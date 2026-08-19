abstract class AttendanceSource {
  Future<void> recordCheckIn(String staffId, DateTime time);
  Future<void> recordCheckOut(String staffId, DateTime time);
}
