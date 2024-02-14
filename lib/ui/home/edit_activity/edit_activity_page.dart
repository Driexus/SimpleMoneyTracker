import 'package:flutter/material.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/ui/home/edit_activity/all_icons_list.dart';
import 'package:simplemoneytracker/ui/home/buttons/rectangular_button.dart';
import 'package:simplemoneytracker/ui/home/edit_activity/colors_list.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import 'package:simplemoneytracker/utils/toast_helper.dart';

class EditActivityPage extends StatefulWidget {
  const EditActivityPage({super.key, this.moneyActivity, required this.cubit});

  final MoneyActivity? moneyActivity;
  final ActivitiesCubit cubit;

  @override
  State<StatefulWidget> createState() => _EditActivityPageState();
}

class _EditActivityPageState extends State<EditActivityPage> {

  //region Main State Handling

  late String _title;
  late Color _color;
  String? _imageKey;

  @override
  void initState() {
    super.initState();
    _title = widget.moneyActivity?.title ?? "";
    _color = widget.moneyActivity?.color.toColor() ?? Colors.cyan;
    _imageKey = widget.moneyActivity?.imageKey;
  }

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

    // Create new activity or pass values to the one that already exists
    final MoneyActivity finalActivity = widget.moneyActivity == null ?
      MoneyActivity(
          title: _title,
          color: _color.value,
          imageKey: _imageKey!
      ) :
      widget.moneyActivity!.copy(
          title: _title,
          color: _color.value,
          imageKey: _imageKey!
      );

    widget.cubit.saveActivity(finalActivity);
    Navigator.pop(context);
    ToastHelper.showToast("Activity saved");
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
                color: _color,
                hasRipple: false,
              ),
              const SizedBox(height: 30),
              TextField(
                maxLines: 1,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Title',
                  hintText: _title,
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
