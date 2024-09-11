import '../model/holiday.dart';
import '../repositories/holiday_repository.dart';

class HolidayController {
  final HolidayRepository repository;

  HolidayController(this.repository);

  Future<List<Holiday>> getHolidays() {
    return repository.fetchHolidays();
  }
}
