import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'database_helper.dart';
import 'home_screen.dart';
import 'main.dart';

class HabitScreen extends StatefulWidget {
  const HabitScreen({Key? key}) : super(key: key);

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  var _habitController = TextEditingController();
  var _dateController = TextEditingController();
  String selectedPriority = 'High';

  @override
  void initState(){
    super.initState();
  }


  DateTime _dateTime = DateTime.now();

  _showDatePicker(BuildContext context) async{
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));

    if(_pickedDate != null){
      setState(() {
        _dateTime = _pickedDate;
        _dateController.text = DateFormat('dd-MM-yyyy').format(_pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _habitController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Habit',
                hintText: 'Write Habit',
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Date',
                  hintText: 'Pick a Date',
                  prefixIcon: InkWell(
                    onTap: () {
                      _showDatePicker(context);
                    },
                    child: Icon(Icons.calendar_today),
                  )),
            ),
            SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RadioListTile(
                  title: Text("High"),
                  value: "High",
                  groupValue: selectedPriority,
                  onChanged: (value){
                    setState(() {
                      selectedPriority = value as String;
                    });
                  },
                ),
                RadioListTile(
                  title: Text("Low"),
                  value: "Low",
                  groupValue: selectedPriority,
                  onChanged: (value){
                    setState(() {
                      selectedPriority = value as String;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () async {
                _save();
              },
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }

  void _save() async {
    print('---------------> Habit: $_habitController.text');
    print('---------------> Priority: $selectedPriority');
    print('---------------> Date: $_dateController.text');

    Map<String, dynamic> row = {
      DatabaseHelper.columnHabit: _habitController.text,
      DatabaseHelper.columnPriority: selectedPriority,
      DatabaseHelper.columnDate: _dateController.text,
    };

    final result = await dbHelper.insert(row, DatabaseHelper.habitsTable);

    debugPrint('-----------------> inserted row id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Saved.');
    }
    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
