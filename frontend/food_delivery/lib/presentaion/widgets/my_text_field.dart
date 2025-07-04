import 'package:flutter/material.dart';
import 'package:food_delivery/utils/app_colors.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      this.prefixIcon,
      this.suffixIcon,
      this.maxLines,
      required this.hintText,
      this.fillColor,
      this.hintColor,
      this.controller,
      this.obscureText,
      this.keyboardType,
      this.onChanged,
      this.enabled,
      this.contentPadding});
  final ValueChanged<String>? onChanged;
  final bool? obscureText;
  final bool? enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final String hintText;
  final Color? fillColor;
  final Color? hintColor;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? contentPadding;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      controller: controller,
      maxLines: obscureText == null
          ? maxLines
          : obscureText!
              ? 1
              : maxLines,
      decoration: InputDecoration(
        fillColor: fillColor ?? AppColors.whiteColor.withValues(alpha: .05),
        filled: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding:
            contentPadding ?? EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.whiteColor
                .withOpacity(0.2), // Light grey for unfocused border
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: hintColor ?? AppColors.blackColor.withOpacity(0.5),
            ),
      ),
    );
  }
}
