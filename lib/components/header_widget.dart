import 'package:flutter/material.dart';

import '../styles/colors.dart';


class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key,

    required this.title,
    this.onBackTap,
    this.trailing,
  }) : super(key: key);

  final String title;
  final VoidCallback? onBackTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: AppColors.primary,
          ),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          if (onBackTap != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: onBackTap,
                color: AppColors.primary,
                icon: const Icon(Icons.arrow_back),
                iconSize: 30,
              ),
            ),
          Expanded(
            child: Text(
              title,
              style:  TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(child: trailing),
        ],
      ),
    );
  }
}