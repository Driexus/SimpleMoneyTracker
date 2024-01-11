import 'package:flutter/material.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/ui/home/add_activity/all_icons_list.dart';
import 'package:simplemoneytracker/ui/home/buttons/rectangular_button.dart';
import 'package:simplemoneytracker/ui/home/add_activity/colors_list.dart';
import 'package:simplemoneytracker/utils/toast_helper.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {

  //region Main State Handling

  static final cubit = ActivitiesCubit();

  String _title = "";
  Color _color = Colors.black87;
  String? _imageKey;

  void _updateTitle(String value) => setState(() {
    _title = value;
  });

  void _updateColor(Color color) => setState(() {
    _color = color;
  });

  void _updateIcon(String value) => setState(() {
    _imageKey = value;
  });

  void _submit(BuildContext context) {
    if (_title == "") {
      ToastHelper.showToast("Cannot save activity without a title");
      return;
    }

    if (_imageKey == null) {
      ToastHelper.showToast("Cannot save activity without an icon");
      return;
    }

    cubit.addActivity(
        MoneyActivity(
            title: _title,
            color: _color.value,
            imageKey: _imageKey!
        )
    );
    Navigator.pop(context);
    ToastHelper.showToast("New activity created");
  }

  //endregion

  //region List Handling

  ButtonType? _activeListType;

  late final _colorsList = ColorsList(
    onColor: _updateColor,
  );

  AllIconsList get _iconsList => AllIconsList(
    color: _color,
    onIcon: _updateIcon,
  );

  Widget get _activeList {
    switch (_activeListType) {
      case ButtonType.color:  return _colorsList;
      case ButtonType.icon:   return _iconsList;
      case null:              return const SizedBox();
    }
  }

  void _onListButtonTap(ButtonType buttonType) => setState(() {
    _activeListType = _activeListType == buttonType ?
        null : buttonType;
  });

  Icon _getButtonIcon(ButtonType buttonType) {
    IconData iconData = _activeListType == buttonType ?
      Icons.expand_less : Icons.expand_more;

    return Icon(iconData);
  }

  //endregion

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
                      onPressed: () => _onListButtonTap(ButtonType.color),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Color"),
                          _getButtonIcon(ButtonType.color)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: OutlinedButton(
                        onPressed: () => _onListButtonTap(ButtonType.icon),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Icon"),
                            _getButtonIcon(ButtonType.icon)
                          ],
                        ),
                      )
                  )
                ],
              )
            ]
          ),
          Positioned(
            bottom: 55,
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

enum ButtonType { icon, color }
