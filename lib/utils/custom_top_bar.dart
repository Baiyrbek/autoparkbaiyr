import 'package:flutter/material.dart';

class CustomTopBar extends StatelessWidget {
  final String? title;
  final VoidCallback? onBackPressed;
  final Widget? rightWidget;

  const CustomTopBar({
    Key? key,
    this.title,
    this.onBackPressed,
    this.rightWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        bottom: 14,
        left: 18,
        right: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBackPressed ?? () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 28,
                height: 28,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 22,
                ),
              ),
            ),
          ),
          Spacer(),
          Text(
            title ?? '',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          // Right widget or placeholder for symmetry
          rightWidget ?? Container(
            width: 28,
            height: 28,
          ),
        ],
      ),
    );
  }
} 