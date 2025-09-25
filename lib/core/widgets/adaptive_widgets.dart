import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Classe utilitaire pour déterminer la plateforme
class PlatformUtils {
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  static bool get isWeb => kIsWeb;

  /// Retourne true si on doit utiliser Cupertino
  static bool get shouldUseCupertino => isIOS || isMacOS;
}

/// Scaffold adaptatif qui utilise CupertinoPageScaffold sur iOS/macOS
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.shouldUseCupertino) {
      // iOS/macOS: Utiliser CupertinoPageScaffold
      Widget scaffold = CupertinoPageScaffold(
        navigationBar: appBar is CupertinoNavigationBar
            ? appBar! as ObstructingPreferredSizeWidget
            : appBar != null
            ? CupertinoNavigationBar(
                    middle: (appBar! as AppBar).title,
                    backgroundColor: backgroundColor,
                  )
                  as ObstructingPreferredSizeWidget
            : null,
        backgroundColor: backgroundColor,
        child: SafeArea(bottom: bottomNavigationBar == null, child: body),
      );

      // Si on a un floatingActionButton, l'ajouter avec un Stack
      if (floatingActionButton != null) {
        scaffold = Stack(
          children: [
            scaffold,
            Positioned(bottom: 16.0, right: 16.0, child: floatingActionButton!),
          ],
        );
      }

      return scaffold;
    } else {
      // Autres plateformes: Utiliser Scaffold Material
      return Scaffold(
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        bottomNavigationBar: bottomNavigationBar,
        backgroundColor: backgroundColor,
      );
    }
  }
}

/// AppBar adaptatif
class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdaptiveAppBar({
    required this.title,
    super.key,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.bottom,
  });

  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.shouldUseCupertino) {
      return CupertinoNavigationBar(
        middle: title,
        backgroundColor: backgroundColor,
        leading: leading,
        trailing: actions != null && actions!.isNotEmpty
            ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
            : null,
      );
    } else {
      return AppBar(
        title: title,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        backgroundColor: backgroundColor,
        bottom: bottom,
      );
    }
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

/// Bouton adaptatif
class AdaptiveButton extends StatelessWidget {
  const AdaptiveButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.color,
    this.padding,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.shouldUseCupertino) {
      return CupertinoButton(
        onPressed: onPressed,
        color: color,
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: padding,
        ),
        child: child,
      );
    }
  }
}

/// Indicateur de progression adaptatif
class AdaptiveProgressIndicator extends StatelessWidget {
  const AdaptiveProgressIndicator({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.shouldUseCupertino) {
      return CupertinoActivityIndicator(color: color);
    } else {
      return CircularProgressIndicator(
        valueColor: color != null
            ? AlwaysStoppedAnimation<Color>(color!)
            : null,
      );
    }
  }
}

/// Switch adaptatif
class AdaptiveSwitch extends StatelessWidget {
  const AdaptiveSwitch({
    required this.value,
    required this.onChanged,
    super.key,
    this.activeColor,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.shouldUseCupertino) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: activeColor,
      );
    } else {
      return Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: activeColor,
        activeTrackColor: activeColor?.withAlpha(128),
      );
    }
  }
}

/// Dialog adaptatif
class AdaptiveDialog extends StatelessWidget {
  const AdaptiveDialog({
    required this.title,
    required this.content,
    required this.actions,
    super.key,
  });

  final String title;
  final String content;
  final List<AdaptiveDialogAction> actions;

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.shouldUseCupertino) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions.map((action) {
          return CupertinoDialogAction(
            isDestructiveAction: action.isDestructive,
            onPressed: action.onPressed,
            child: Text(action.text),
          );
        }).toList(),
      );
    } else {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions.map((action) {
          return TextButton(
            onPressed: action.onPressed,
            child: Text(
              action.text,
              style: action.isDestructive
                  ? const TextStyle(color: Colors.red)
                  : null,
            ),
          );
        }).toList(),
      );
    }
  }

  /// Méthode statique pour afficher le dialog
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    required List<AdaptiveDialogAction> actions,
  }) {
    return showDialog(
      context: context,
      builder: (context) =>
          AdaptiveDialog(title: title, content: content, actions: actions),
    );
  }
}

/// Action pour AdaptiveDialog
class AdaptiveDialogAction {
  const AdaptiveDialogAction({
    required this.text,
    required this.onPressed,
    this.isDestructive = false,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isDestructive;
}

/// TextField adaptatif
class AdaptiveTextField extends StatelessWidget {
  const AdaptiveTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.decoration,
  });

  final TextEditingController? controller;
  final String? placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.shouldUseCupertino) {
      return CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    } else {
      return TextField(
        controller: controller,
        decoration: decoration ?? InputDecoration(hintText: placeholder),
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
      );
    }
  }
}

/// Bouton d'icône adaptatif
class AdaptiveIconButton extends StatelessWidget {
  const AdaptiveIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.cupertinoIcon,
    this.tooltip,
    this.color,
  });

  final Widget icon;
  final IconData? cupertinoIcon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.shouldUseCupertino) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: cupertinoIcon != null ? Icon(cupertinoIcon, color: color) : icon,
      );
    }

    return IconButton(
      icon: icon,
      onPressed: onPressed,
      tooltip: tooltip,
      color: color,
    );
  }
}
