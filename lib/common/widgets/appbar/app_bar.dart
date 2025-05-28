import 'package:flutter/material.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;
  final Color? backgroundColor;
  final bool hideBack;
  final bool showSearch;

  const BasicAppbar({
    this.title,
    this.hideBack = false,
    this.action,
    this.backgroundColor,
    this.showSearch = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          backgroundColor: backgroundColor ?? Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: title ?? const Text(''),
          actions: [action ?? Container()],
          leading: hideBack
              ? Builder(
                  builder: (context) => IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: context.isDarkMode ? Colors.white : Colors.black87,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                )
              : IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: context.isDarkMode
                          ? Colors.white.withOpacity(0.03)
                          : Colors.black.withOpacity(0.04),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 15,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
        ),
        // if (showSearch)
        //   Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: TextField(
        //       decoration: InputDecoration(
        //         hintText: 'Search',
        //         prefixIcon: const Icon(Icons.search),
        //         filled: true,
        //         fillColor: context.isDarkMode
        //             ? Colors.white.withOpacity(0.05)
        //             : Colors.grey[200],
        //         border: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(30),
        //           borderSide: BorderSide.none,
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  @override
  Size get preferredSize {
    double height = kToolbarHeight;
    if (showSearch) height += 70;
    return Size.fromHeight(height);
  }
}


// Phi Đen