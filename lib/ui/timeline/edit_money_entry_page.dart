import 'package:flutter/material.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/ui/home/edit_activity/all_icons_list.dart';
import 'package:simplemoneytracker/ui/home/buttons/rectangular_button.dart';
import 'package:simplemoneytracker/ui/home/edit_activity/colors_list.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import 'package:simplemoneytracker/utils/toast_helper.dart';

import '../shared/bottom_button.dart';


class EditMoneyEntryPage extends StatefulWidget {
  const EditMoneyEntryPage({super.key, this.moneyActivity, required this.cubit});

  final MoneyActivity? moneyActivity;
  final ActivitiesCubit cubit;

  @override
  State<StatefulWidget> createState() => _EdiMoneyEntryPageState();
}

class _EdiMoneyEntryPageState extends State<EditMoneyEntryPage> {

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
    final MoneyActivity finalActivity = widget.moneyActivity!;

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

  String? get _activityTitle => widget.moneyActivity?.title;

  IconButton? _deleteButton(BuildContext mainContext) => widget.moneyActivity == null ? null : IconButton(
      iconSize: 35,
      icon: const Icon(Icons.delete_forever),
      onPressed: () =>  {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Delete ${_activityTitle!}?'),
            content: Text('Are you sure you want to delete ${_activityTitle!} and all its relevant entries? This action is not reversible.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  widget.cubit.deleteActivity(widget.moneyActivity!);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ToastHelper.showToast("Activity ${_activityTitle!} deleted");
                },
                child: const Text('OK'),
              ),
            ],
          ),
        )
      }
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            body: Stack(
                children: [
                  Positioned(
                      top: 35,
                      right: 10,
                      child: Container(child: _deleteButton(context))
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                          children: [
                            const SizedBox(height: 60),
                            RectangularButton(
                              imageKey: _imageKey,
                              description: _title,
                              color: _color,
                              hasRipple: false,
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                                initialValue: _title,
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
                      )
                  ),
                  Positioned(
                      bottom: 55,
                      top: 310,
                      right: 0,
                      left: 0,
                      child: _activeList
                  ),
                  BottomButton(
                      text: "SAVE",
                      onTap: () => _submit(context)
                  ),
                ]
            )
        )
    );
  }
}

enum ButtonType { icon, color }
