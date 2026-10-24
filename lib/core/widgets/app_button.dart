import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = true,
    this.isSecondary = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isSecondary
        ? ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.navy,
            side: const BorderSide(color: Color(0xFFE4E7EC)),
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: AppTheme.navy,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          );

    final button = ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Text(label),
    );

    if (!fullWidth) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}
