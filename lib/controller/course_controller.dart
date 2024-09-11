import 'package:intl/intl.dart';
import 'package:myapp/core/constants.dart';
import 'package:myapp/model/course_model.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/model/course_repository.dart';

class CourseController {
  CourseRepository repository = CourseRepository();
  List<CourseEntity> courseList = []; // Declare the courseList variable

  Future<List<CourseEntity>> getCourseList() async {
    courseList = await repository
        .getAllCourses(); // Call the correct method name 'getAllCourses'
    return courseList;
  }

  String obterPrimeirasLetras(String nomeCurso) {
    return nomeCurso.length >= 2
        ? nomeCurso.substring(0, 2).toUpperCase()
        : nomeCurso.toUpperCase();
  }

  postNewCourse(CourseEntity courseEntity) async {
    try {
      await repository.postNewCourse(courseEntity);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCourseById(String id) async {
    final Uri apiUrl = Uri.parse('$urlAPI/courses');
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      courseList.removeWhere((course) => course.id == id);
    } else {
      throw Exception('Failed to delete course');
    }
  }

  void deleteCourse(String id) {
    deleteCourseById(id);
  }

  Future<void> updateCourse(int id, CourseEntity course) async {
    try {
      await repository.updateCourse(id, course);
    } catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }

  DateTime convertToBrazilTimeZone(DateTime dateTime) {
    // Brasília Time (BRT) is UTC-3, and during daylight saving time (BRST) it is UTC-2
    // Adjusting for BRT (UTC-3)
    return dateTime.toUtc().add(const Duration(hours: -3));
  }

  String dateTimeToDateBR(String date) {
    var inputDate = DateTime.parse(date);
    var outputFormat = DateFormat('dd/MM/yyyy');
    return outputFormat.format(inputDate);
  }
}
