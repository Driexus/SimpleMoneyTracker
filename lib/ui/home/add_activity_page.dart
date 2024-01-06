import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/ui/home/buttons/rectangular_button.dart';
import 'package:simplemoneytracker/ui/home/colors_list.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {

  static final cubit = ActivitiesCubit();
  String _title = "";
  Color _color = Colors.deepPurple;
  String _imageKey = "";

  void _updateTitle(String value) {
    setState(() {
      _title = value;
    });
  }

  void _updateColor(Color color) {
    setState(() {
      _color = color;
    });
  }

  void _updateIcon() {

  }

  void _submit(BuildContext context) {
    cubit.addActivity(
      MoneyActivity(
        title: _title,
        color: _color.value
      )
    );
    Navigator.pop(context);
    Fluttertoast.showToast(
        msg: "New activity created",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black38,
        textColor: Colors.white,
        fontSize: 16
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 60,
            right: 10,
            left: 10,
            child: Column(
              children: [
                RectangularButton(
                  imageKey: 'ac_unit',
                  description: _title,
                  color: _color
                ),
                const SizedBox(height: 30),
                TextField(
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                  onChanged: _updateTitle
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Color"),
                            Icon(Icons.expand_more)
                          ],
                        ),
                        onPressed: () {  },
                      ),
                    ),
                    Expanded(
                        child: OutlinedButton(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Icon"),
                              Icon(Icons.expand_more)
                            ],
                          ),
                          onPressed: () {  },
                        )
                    )
                  ],
                ),
                const SizedBox(height: 30),
                ColorsList(
                  onColor: _updateColor,
                )
              ]
            )
          ),
          Positioned(
            bottom: 7,
            right: 7,
            left: 7,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () => _submit(context),
              child: const Text('SAVE'),
            ),
          )
        ]
      )
    );
  }
}
