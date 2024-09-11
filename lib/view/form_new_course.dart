import 'package:flutter/material.dart';
import 'package:myapp/model/course_model.dart';
import 'package:myapp/controller/course_controller.dart';

class FormNewCourse extends StatefulWidget {
  final CourseEntity? course;
  const FormNewCourse({super.key, this.course});
  @override
  _FormNewCourseState createState() => _FormNewCourseState();
}

class _FormNewCourseState extends State<FormNewCourse> {
  final GlobalKey<FormState> keyform = GlobalKey<FormState>();
  final TextEditingController textName = TextEditingController();
  final TextEditingController textDescription = TextEditingController();
  final TextEditingController textstartAt = TextEditingController();
  final CourseController controller = CourseController();

  @override
  void dispose() {
    textName.dispose();
    textDescription.dispose();
    textstartAt.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final DateTime brazilTime = controller.convertToBrazilTimeZone(picked);
      setState(() {
        textstartAt.text =
            controller.dateTimeToDateBR(brazilTime.toIso8601String());
      });
    }
  }

  void postNewCourse() async {
    CourseEntity course = CourseEntity(
      name: textName.text,
      description: textDescription.text,
      startAt: textstartAt.text,
    );
    try {
      await controller.postNewCourse(course);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Course saved successfully!"),
      ));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error saving course: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Course'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: keyform,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: textName,
                          decoration: InputDecoration(
                            hintText: "Fill course name",
                            prefixIcon: Icon(Icons.book),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return "Please enter a course name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: textDescription,
                          decoration: InputDecoration(
                            hintText: "Fill course description",
                            prefixIcon: Icon(Icons.description),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return "Please enter a course description";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: textstartAt,
                          decoration: InputDecoration(
                            hintText: "Fill course date",
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return "Please enter a course date";
                            }
                            return null;
                          },
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            await _selectDate(context);
                          },
                        ),
                        const SizedBox(height: 24.0),
                        Container(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (keyform.currentState?.validate() ?? false) {
                                postNewCourse();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Save",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
