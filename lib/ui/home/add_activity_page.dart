import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/ui/home/all_icons_list.dart';
import 'package:simplemoneytracker/ui/home/buttons/rectangular_button.dart';
import 'package:simplemoneytracker/ui/home/colors_list.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {

  static final cubit = ActivitiesCubit();

  // TODO: Collapse list
  Widget _activeList = const SizedBox();

  // TODO: Change Icon colors
  late final AllIconsList _iconsList = AllIconsList(
    color: _color,
    onIcon: _updateIcon,
  );
  late final _colorsList = ColorsList(
    onColor: _updateColor,
  );

  String _title = "";
  Color _color = Colors.deepPurple;
  String? _imageKey;

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

  void _updateIcon(String value) {
    setState(() {
      _imageKey = value;
    });
  }

  void _showIcons() {
    setState(() {
      _activeList = _iconsList;
    });
  }

  void _showColors() {
    setState(() {
      _activeList = _colorsList;
    });
  }

  void _submit(BuildContext context) {
    cubit.addActivity(
      MoneyActivity(
        title: _title,
        color: _color.value,
        imageKey: _imageKey! // TODO: Add check before saving
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
          Column(
            children: [
              const SizedBox(height: 60),
              RectangularButton(
                imageKey: _imageKey,
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _showColors,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Color"),
                          Icon(Icons.expand_more)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: OutlinedButton(
                        onPressed: _showIcons,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Icon"),
                            Icon(Icons.expand_more)
                          ],
                        ),
                      )
                  )
                ],
              )
            ]
          ),
          Positioned(
            bottom: 80, // TODO: Add padding instead because of empty area above save button
            top: 310,
            right: 0,
            left: 0,
            child: _activeList
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 20),
                  minimumSize: const Size(double.infinity, 0)
              ),
              onPressed: () => _submit(context),
              child: const Text('SAVE'),
            )
          ),
        ]
      )
    );
  }
}
