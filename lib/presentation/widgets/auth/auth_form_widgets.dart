import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/themes/deep_theme.dart';

/// Champ de texte personnalisé pour l'authentification
class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.onChanged,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword && !_isPasswordVisible,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      textCapitalization: widget.textCapitalization,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      style: TextStyle(
        fontSize: FontSizes.bodyMedium.getSize(context),
        color: DeepColorTokens.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        labelStyle: TextStyle(
          fontSize: FontSizes.bodySmall.getSize(context),
          color: DeepColorTokens.textSecondary,
        ),
        hintStyle: TextStyle(
          fontSize: FontSizes.bodySmall.getSize(context),
          color: DeepColorTokens.textTertiary,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                size: ResponsiveUtils.getIconSize(context),
                color: DeepColorTokens.neutral600,
              )
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  size: ResponsiveUtils.getIconSize(context),
                  color: DeepColorTokens.neutral600,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: widget.enabled 
            ? DeepColorTokens.surfaceBackground
            : DeepColorTokens.neutral200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.borderRadius),
          borderSide: BorderSide(
            color: DeepColorTokens.divider,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.borderRadius),
          borderSide: BorderSide(
            color: DeepColorTokens.divider,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.borderRadius),
          borderSide: BorderSide(
            color: DeepColorTokens.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.borderRadius),
          borderSide: BorderSide(
            color: DeepColorTokens.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.borderRadius),
          borderSide: BorderSide(
            color: DeepColorTokens.error,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.horizontalSpacing,
          vertical: context.verticalSpacing * 1.25,
        ),
      ),
    );
  }
}

/// Bouton principal pour l'authentification
class AuthPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const AuthPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: context.buttonHeight * 1.2,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? DeepColorTokens.primary,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.borderRadius),
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: context.horizontalSpacing * 1.5,
            vertical: context.verticalSpacing,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: ResponsiveUtils.getIconSize(context) * 1.1,
                    ),
                    SizedBox(width: context.horizontalSpacing / 2),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: FontSizes.bodyLarge.getSize(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Bouton secondaire pour l'authentification
class AuthSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const AuthSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: context.horizontalSpacing,
          vertical: context.verticalSpacing / 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: ResponsiveUtils.getIconSize(context),
              color: DeepColorTokens.primary,
            ),
            SizedBox(width: context.horizontalSpacing / 2),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: FontSizes.bodyMedium.getSize(context),
              color: DeepColorTokens.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bouton pour l'authentification sociale
class SocialAuthButton extends StatelessWidget {
  final String text;
  final String? imagePath;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;

  const SocialAuthButton({
    super.key,
    required this.text,
    this.imagePath,
    this.icon,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.textColor = DeepColorTokens.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: context.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(
            color: DeepColorTokens.divider,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.borderRadius),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.horizontalSpacing,
            vertical: context.verticalSpacing,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                height: 24,
                width: 24,
              )
            else if (icon != null)
              Icon(
                icon,
                size: 24,
                color: textColor,
              ),
            SizedBox(width: context.horizontalSpacing),
            Text(
              text,
              style: TextStyle(
                fontSize: FontSizes.bodyMedium.getSize(context),
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Diviseur avec texte
class AuthDivider extends StatelessWidget {
  final String text;

  const AuthDivider({
    super.key,
    this.text = 'ou',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.verticalSpacing),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: DeepColorTokens.divider,
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.horizontalSpacing),
            child: Text(
              text,
              style: TextStyle(
                fontSize: FontSizes.caption.getSize(context),
                color: DeepColorTokens.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: DeepColorTokens.divider,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Header pour les pages d'authentification
class AuthPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showBackButton;

  const AuthPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBackButton)
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_rounded,
              size: ResponsiveUtils.getIconSize(context) * 1.2,
              color: DeepColorTokens.textPrimary,
            ),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
        SizedBox(height: context.verticalSpacing),
        Text(
          title,
          style: TextStyle(
            fontSize: FontSizes.headlineLarge.getSize(context),
            fontWeight: FontWeight.bold,
            color: DeepColorTokens.textPrimary,
          ),
        ),
        SizedBox(height: context.verticalSpacing / 2),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: FontSizes.bodyMedium.getSize(context),
            color: DeepColorTokens.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Checkbox avec label pour les conditions
class AuthCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Widget label;

  const AuthCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(context.borderRadius / 2),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.verticalSpacing / 2,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: DeepColorTokens.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            SizedBox(width: context.horizontalSpacing / 2),
            Expanded(child: label),
          ],
        ),
      ),
    );
  }
}