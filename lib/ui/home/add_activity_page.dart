import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/model/money_activity.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  String? _title;
  static final cubit = ActivitiesCubit();

  void _submit(BuildContext context) {
    cubit.addActivity(
      MoneyActivity(
        title: _title!,
        color: "color"
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
              left: 0,
              right: 0,
              top: 120,
              child: SizedBox(
                width: 250,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                  onChanged: (text) => {
                    _title = text
                  },
                ),
              )
          ),
          Positioned(
              left: 0,
              right: 0,
              top: 200,
              child: Row(
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
              )
          ),
          Positioned(
            left: 7,
            right: 7,
            bottom: 7,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () => _submit(context),
              child: const Text('SAVE'),
            )
          )
        ]
      )
    );
  }
}
