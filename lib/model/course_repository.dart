import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/model/course_model.dart';

class CourseRepository {
  final String urlAPI = 'https://66be909542533c4031439066.mockapi.io/';

  Future<void> postNewCourse(CourseEntity courseEntity) async {
    final json = jsonEncode(CourseEntity.toJson(courseEntity));
    final response = await http.post(Uri.parse('$urlAPI/courses'), body: json, headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode != 201) {
      throw Exception("Looks like we had an issue");
    }
  }

  Future<void> updateCourse(int id, CourseEntity course) async {
    final url = Uri.parse('$urlAPI/courses/$id');
    final json = jsonEncode(CourseEntity.toJson(course));
    final response = await http.put(url, body: json, headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode != 200) {
      throw Exception("Looks like we had an issue updating the course.");
    }
  }

   Future<List<CourseEntity>> getAllCourses() async {
    final url = Uri.parse('$urlAPI/courses');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<CourseEntity> courses =
          body.map((dynamic item) => CourseEntity.fromJson(item)).toList();
      return courses;
    } else {
      throw Exception("Failed to load courses");
    }
  }
}