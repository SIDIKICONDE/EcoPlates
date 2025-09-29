import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'responsive_utils.dart';

/// Texte avec taille responsive
class ResponsiveText extends StatelessWidget {
  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.baseFontSize,
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
    this.fontSize,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;
  final double? baseFontSize;
  final double? mobileSize;
  final double? tabletSize;
  final double? desktopSize;
  final FontSize? fontSize;

  @override
  Widget build(BuildContext context) {
    // L'initialisation ScreenUtil est gérée au niveau application

    double calculatedFontSize;

    // Priorité : fontSize centralisé > tailles individuelles > baseFontSize
    if (fontSize != null) {
      // Ne pas utiliser .sp car getSize retourne déjà la taille adaptée
      calculatedFontSize = fontSize!.getSize(context);
    } else if (mobileSize != null ||
        tabletSize != null ||
        desktopSize != null) {
      // Ne pas utiliser .sp pour éviter le double scaling
      calculatedFontSize = context.responsive(
        mobile: mobileSize ?? 16.0,
        tablet: tabletSize ?? 18.0,
        desktop: desktopSize ?? 20.0,
      );
    } else {
      // ResponsiveUtils.getResponsiveFontSize retourne déjà la bonne taille
      calculatedFontSize = ResponsiveUtils.getResponsiveFontSize(
        context,
        baseFontSize ?? style?.fontSize ?? 16.0,
      );
    }

    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(
        fontSize: calculatedFontSize,
      ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}

/// Bouton avec hauteur et padding responsifs
class ResponsiveButton extends StatelessWidget {
  const ResponsiveButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.style,
    this.width,
    this.height,
    this.padding,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    // L'initialisation ScreenUtil est gérée au niveau application

    final responsiveHeight = height ?? context.buttonHeight;
    final responsivePadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: context.horizontalSpacing,
          vertical: 16, // Valeur fixe au lieu de .h
        );

    return SizedBox(
      width: width,
      height: responsiveHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: (style ?? ElevatedButton.styleFrom()).copyWith(
          padding: WidgetStateProperty.all(responsivePadding),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.borderRadius),
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Card avec dimensions et espacement responsifs
class ResponsiveCard extends StatelessWidget {
  const ResponsiveCard({
    required this.child,
    super.key,
    this.margin,
    this.padding,
    this.elevation,
    this.color,
    this.shape,
    this.width,
    this.height,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final Color? color;
  final ShapeBorder? shape;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final responsiveMargin = margin ?? const EdgeInsets.all(12); // Valeur fixe
    final responsivePadding = padding ?? context.responsivePadding;
    final responsiveElevation =
        elevation ??
        context.responsive(
          mobile: 2.0,
          tablet: 4.0,
          desktop: 6.0,
        );

    return Container(
      width: width,
      height: height,
      margin: responsiveMargin,
      child: Card(
        elevation: responsiveElevation,
        color: color,
        shape:
            shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.borderRadius),
            ),
        child: Padding(
          padding: responsivePadding,
          child: child,
        ),
      ),
    );
  }
}

/// AppBar responsive avec hauteur adaptative
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ResponsiveAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.centerTitle,
    this.elevation,
    this.automaticallyImplyLeading = true,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool? centerTitle;
  final double? elevation;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
      backgroundColor: backgroundColor,
      centerTitle: centerTitle,
      elevation: elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: context.appBarHeight,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    WidgetsBinding.instance.platformDispatcher.views.isNotEmpty &&
            WidgetsBinding
                        .instance
                        .platformDispatcher
                        .views
                        .first
                        .physicalSize
                        .width /
                    WidgetsBinding
                        .instance
                        .platformDispatcher
                        .views
                        .first
                        .devicePixelRatio >
                ResponsiveUtils.mobileBreakpoint
        ? kToolbarHeight + 16
        : kToolbarHeight,
  );
}

/// Container avec contraintes responsives
class ResponsiveConstrainedBox extends StatelessWidget {
  const ResponsiveConstrainedBox({
    required this.child,
    super.key,
    this.maxWidth,
    this.maxHeight,
    this.minWidth,
    this.minHeight,
  });

  final Widget child;
  final double? maxWidth;
  final double? maxHeight;
  final double? minWidth;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? context.maxContentWidth,
        maxHeight: maxHeight ?? double.infinity,
        minWidth: minWidth ?? 0,
        minHeight: minHeight ?? 0,
      ),
      child: child,
    );
  }
}

/// Icône avec taille responsive
class ResponsiveIcon extends StatelessWidget {
  const ResponsiveIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final responsiveSize = size != null
        ? ResponsiveUtils.getIconSize(context, baseSize: size!)
        : ResponsiveUtils.getIconSize(context);

    return Icon(
      icon,
      size: responsiveSize,
      color: color,
      semanticLabel: semanticLabel,
    );
  }
}

/// Image avec dimensions responsives
class ResponsiveImage extends StatelessWidget {
  const ResponsiveImage({
    required this.image,
    super.key,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.baseSize,
  });

  final ImageProvider image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final Size? baseSize;

  @override
  Widget build(BuildContext context) {
    Size responsiveSize;

    if (baseSize != null) {
      responsiveSize = ResponsiveUtils.getResponsiveImageSize(
        context,
        baseSize: baseSize!,
      );
    } else {
      responsiveSize = Size(
        width ??
            context.responsive(mobile: 150.0, tablet: 200.0, desktop: 250.0),
        height ??
            context.responsive(mobile: 150.0, tablet: 200.0, desktop: 250.0),
      );
    }

    return Image(
      image: image,
      width: responsiveSize.width,
      height: responsiveSize.height,
      fit: fit,
      alignment: alignment,
    );
  }
}

/// SizedBox avec espacement responsive
class ResponsiveGap extends StatelessWidget {
  const ResponsiveGap({
    super.key,
    this.width,
    this.height,
    this.useVerticalSpacing = false,
    this.useHorizontalSpacing = false,
    this.multiplier = 1.0,
  });

  final double? width;
  final double? height;
  final bool useVerticalSpacing;
  final bool useHorizontalSpacing;
  final double multiplier;

  @override
  Widget build(BuildContext context) {
    final finalWidth = useHorizontalSpacing
        ? context.horizontalSpacing * multiplier
        : width;
    final finalHeight = useVerticalSpacing
        ? context.verticalSpacing * multiplier
        : height;

    return SizedBox(
      width: finalWidth,
      height: finalHeight,
    );
  }
}

/// Divider avec espacement responsive
class ResponsiveDivider extends StatelessWidget {
  const ResponsiveDivider({
    super.key,
    this.color,
    this.thickness,
    this.height,
    this.indent,
    this.endIndent,
  });

  final Color? color;
  final double? thickness;
  final double? height;
  final double? indent;
  final double? endIndent;

  @override
  Widget build(BuildContext context) {
    final responsiveHeight = height ?? context.verticalSpacing;
    final responsiveIndent = indent ?? context.horizontalSpacing;
    final responsiveEndIndent = endIndent ?? context.horizontalSpacing;

    return Divider(
      color: color,
      thickness: thickness,
      height: responsiveHeight,
      indent: responsiveIndent,
      endIndent: responsiveEndIndent,
    );
  }
}

/// TextField avec padding et taille responsifs
class ResponsiveTextField extends StatelessWidget {
  const ResponsiveTextField({
    super.key,
    this.controller,
    this.decoration,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final responsiveFontSize = ResponsiveUtils.getResponsiveFontSize(
      context,
      16,
    );
    final responsivePadding = EdgeInsets.symmetric(
      horizontal: context.horizontalSpacing,
      vertical: context.responsive(mobile: 14.0, tablet: 18.0, desktop: 22.0), // Sans .h
    );

    return TextFormField(
      controller: controller,
      decoration: (decoration ?? const InputDecoration()).copyWith(
        contentPadding: responsivePadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.borderRadius),
        ),
      ),
      style: TextStyle(fontSize: responsiveFontSize),
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      enabled: enabled,
    );
  }
}

/// ListTile avec dimensions responsives
class ResponsiveListTile extends StatelessWidget {
  const ResponsiveListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding,
    this.dense,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final bool? dense;

  @override
  Widget build(BuildContext context) {
    final responsivePadding =
        contentPadding ??
        EdgeInsets.symmetric(
          horizontal: context.horizontalSpacing,
          vertical: context.responsive(mobile: 10.0, tablet: 14.0, desktop: 18.0), // Sans .h
        );

    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      contentPadding: responsivePadding,
      dense: dense ?? context.isMobile,
    );
  }
}

/// Spacer vertical responsive
class VerticalGap extends ResponsiveGap {
  const VerticalGap({
    super.key,
    super.height,
    super.multiplier = 1.0,
  }) : super(
         useVerticalSpacing: height == null,
       );
}

/// Spacer horizontal responsive
class HorizontalGap extends ResponsiveGap {
  const HorizontalGap({
    super.key,
    super.width,
    super.multiplier = 1.0,
  }) : super(
         useHorizontalSpacing: width == null,
       );
}
