import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importar pacote para formatação de data
import '../controller/holiday_controller.dart';
import '../repositories/holiday_repository.dart';
import '../model/holiday.dart';
import 'app_drawer.dart'; // Import the AppDrawer

class HolidaysScreen extends StatefulWidget {
  @override
  _HolidaysScreenState createState() => _HolidaysScreenState();
}

class _HolidaysScreenState extends State<HolidaysScreen> {
  late Future<List<Holiday>> futureHolidays;
  final HolidayController controller = HolidayController(HolidayRepository());

  @override
  void initState() {
    super.initState();
    futureHolidays = controller.getHolidays();
  }

  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feriados Nacionais'),
      ),
      drawer: AppDrawer(), // Use the AppDrawer here
      body: Center(
        child: FutureBuilder<List<Holiday>>(
          future: futureHolidays,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Icon(Icons.event, color: Colors.blue),
                      title: Text(
                        snapshot.data![index].name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        formatDate(snapshot.data![index].date),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
