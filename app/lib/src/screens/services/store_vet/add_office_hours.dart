import 'package:app/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class AddOfficeHoursScreen extends StatefulWidget {
  final Map<String, List<String>> officeHours;

  AddOfficeHoursScreen({this.officeHours}); 

  @override
  _AddOfficeHoursScreenState createState() => _AddOfficeHoursScreenState();
}

class _AddOfficeHoursScreenState extends State<AddOfficeHoursScreen> {
  Map<String, List<String>> officeHours;

  initState() {
    super.initState();
    
    if (widget.officeHours != null && 
      widget.officeHours.containsKey("Weekdays") && 
      widget.officeHours.containsKey("Weekends")) {
      officeHours = {
        "Weekdays": widget.officeHours["Weekdays"],
        "Weekends": widget.officeHours["Weekends"]
      };
    } else {
      officeHours = {
        "Weekdays": ["--", "--"],
        "Weekends": ["--", "--"]
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(
        backgroundColor: Colors.white, 
        iconColor: Colors.black
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: size.height * 0.1),
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Weekdays: From ",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.black
                  ),
                ),
                timePicker("Weekdays", true),
                Text(
                  "To ",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.black
                  ),
                ),
                timePicker("Weekdays", false),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.02)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Weekends: From ",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.black
                  ),
                ),
                timePicker("Weekends", true),
                Text(
                  "To ",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.black
                  ),
                ),
                timePicker("Weekends", false),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () => Navigator.pop(context, this.officeHours)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  timePicker(String key, bool from) {
    return OutlinedButton(
      child: Text(
        this.officeHours[key][from? 0: 1]
      ),
      onPressed: () async {
        var result = await showTimePicker(
          context: context, 
          initialTime: TimeOfDay.now()
        );
        setState(() {
          this.officeHours[key][from? 0: 1] = "${result.hour}:${result.minute}"; 
        });
      }
    );
  }
}