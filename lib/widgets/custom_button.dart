// ==================== CUSTOM BUTTON WIDGET ====================
// Reusable button component dengan loading state.
// Bisa dengan atau tanpa icon, custom warna, dan full width.

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  // Text yang ditampilkan di button.
  final String text;

  // Callback saat button di-tap.
  final VoidCallback onPressed;

  // Status loading: true = spinner, false = text.
  final bool isLoading;

  // Warna background button (optional, default merah).
  final Color? backgroundColor;

  // Warna text button (optional, default putih).
  final Color? textColor;

  // Icon di sebelah kanan text (optional).
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Full width button dengan height tetap.
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        // Disable button saat loading.
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          // Warna background: custom atau default merah.
          backgroundColor: backgroundColor ?? const Color(0xFFE53935),
          foregroundColor: textColor ?? Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // Warna saat disabled (loading).
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: isLoading
        // Tampilkan circular progress saat loading.
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
        // Tampilkan text dan icon (jika ada).
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            // Tampilkan icon jika parameter icon tidak null.
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}