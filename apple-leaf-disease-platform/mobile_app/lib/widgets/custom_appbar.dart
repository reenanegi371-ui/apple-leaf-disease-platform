import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color? backgroundColor;
  final double elevation;
  final Widget? leading;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor,
    this.elevation = 0,
    this.leading,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: showBackButton,
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                )
              : null),
      actions: actions,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      elevation: elevation,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withBlue(200),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Color> colors;
  final List<Widget>? actions;
  final bool showBackButton;

  const GradientAppBar({
    Key? key,
    required this.title,
    required this.colors,
    this.actions,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      automaticallyImplyLeading: showBackButton,
      actions: actions,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onBackPressed;

  const SearchAppBar({
    Key? key,
    required this.hintText,
    required this.onChanged,
    this.onFilterPressed,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      ),
      title: Container(
        height: 40,
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white),
            filled: true,
            fillColor: Colors.white24,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
      actions: [
        if (onFilterPressed != null)
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: onFilterPressed,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}