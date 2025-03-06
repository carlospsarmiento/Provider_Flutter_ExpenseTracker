import 'package:flutter/material.dart';

class CustomWidgetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool canGoBack;
  const CustomWidgetAppBar({
    super.key,
    required this.title,
    this.canGoBack = true
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: canGoBack? InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.chevron_left, size: 30)
      ):null,
      title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w500)
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
