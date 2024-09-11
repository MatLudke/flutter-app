import 'package:flutter/material.dart';
import 'package:myapp/model/course_model.dart';
import 'package:myapp/controller/course_controller.dart';

class FormEditCourse extends StatefulWidget {
  final CourseEntity course;
  const FormEditCourse({super.key, required this.course});

  @override
  _FormEditCourseState createState() => _FormEditCourseState();
}

class _FormEditCourseState extends State<FormEditCourse> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startAtController = TextEditingController();
  final CourseController controller = CourseController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.course.name ?? '';
    _descriptionController.text = widget.course.description ?? '';
    _startAtController.text = widget.course.startAt ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startAtController.dispose();
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
        _startAtController.text =
            controller.dateTimeToDateBR(brazilTime.toIso8601String());
      });
    }
  }

  void _updateCourse() async {
    if (_formKey.currentState!.validate()) {
      CourseEntity updatedCourse = CourseEntity(
        id: widget.course.id,
        name: _nameController.text,
        description: _descriptionController.text,
        startAt: _startAtController.text,
      );

      try {
        await controller.updateCourse(
            int.parse(widget.course.id!), updatedCourse);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course updated successfully!')),
        );
        Navigator.pop(context, true); // Navigate back to the previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update course: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
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
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: "Course Name",
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
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            hintText: "Course Description",
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
                          controller: _startAtController,
                          decoration: InputDecoration(
                            hintText: "Course Date",
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
                            onPressed: _updateCourse,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Update",
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
