import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/buttons/icon_square_button.dart';
import 'package:simplemoneytracker/ui/shared/icons_helper.dart';

import '../../shared/overscroll_notification_listener.dart';

class AllIconsList extends StatelessWidget {
  const AllIconsList({super.key, this.onIcon = _onIconDefault, required this.color});

  final Color color;

  final ValueChanged<String> onIcon;
  static void _onIconDefault(String iconKey) {}

  @override
  Widget build(BuildContext context) {
    final categories = IconsHelper.categories;

    return OverscrollNotificationListener(
      // 1. This removes the "automatic" top padding from the list
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          // 1. Remove horizontal padding from the ListView so it spans full width
          padding: const EdgeInsets.symmetric(vertical: 10),
          physics: const ClampingScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final categoryName = categories[index];
            final icons = IconsHelper.getIconsByCategory(categoryName) ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Control the text padding independently
                Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 8),
                  child: Text(
                    categoryName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                // 3. Wrap the GridView in Padding to indent the icons
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: icons.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      crossAxisCount: 5,
                    ),
                    itemBuilder: (context, iconIndex) {
                      return Center( // Prevents the icon from stretching to fill the grid cell
                        child: IconSquareButton(
                          imageKey: icons[iconIndex],
                          color: color,
                          onIconTap: onIcon,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }
}