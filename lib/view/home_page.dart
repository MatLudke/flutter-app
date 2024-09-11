import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myapp/controller/course_controller.dart';
import 'package:myapp/model/course_model.dart';
import 'package:myapp/view/form_new_course.dart';
import 'package:myapp/view/form_edit_course.dart';
import 'app_drawer.dart'; // Import the AppDrawer

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<CourseEntity>> futureCourses;
  CourseController controller = CourseController();

  Future<List<CourseEntity>> getCourses() async {
    return await controller.getCourseList();
  }

  @override
  void initState() {
    futureCourses = getCourses();
    super.initState();
  }

  void deleteCourse(String id) async {
    await controller.deleteCourseById(id);
    setState(() {
      futureCourses = getCourses();
    });
  }

  void editCourse(CourseEntity course) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormEditCourse(course: course),
      ),
    );

    if (result == true) {
      setState(() {
        futureCourses = getCourses();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(), // Use the AppDrawer here
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormNewCourse(course: CourseEntity()),
            ),
          ).then((value) {
            futureCourses = getCourses();
            setState(() {});
          });
        },
      ),
      appBar: AppBar(
        title: const Text(
          "Courses",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<CourseEntity>>(
          future: futureCourses,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              deleteCourse(snapshot.data![index].id!);
                            },
                            icon: Icons.delete,
                            label: "Delete",
                            backgroundColor: Colors.red,
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              editCourse(snapshot.data![index]);
                            },
                            icon: Icons.edit,
                            label: "Edit",
                            backgroundColor: Colors.blue,
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Text(
                            controller.obterPrimeirasLetras(
                                snapshot.data![index].name!),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          snapshot.data![index].name!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(snapshot.data![index].description!),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
