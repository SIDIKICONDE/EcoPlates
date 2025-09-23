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
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  
  const AdaptiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
  });
  
  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.shouldUseCupertino) {
      // iOS/macOS: Utiliser CupertinoPageScaffold
      return CupertinoPageScaffold(
        navigationBar: appBar is CupertinoNavigationBar
            ? appBar as CupertinoNavigationBar
            : appBar != null
                ? CupertinoNavigationBar(
                    middle: (appBar as AppBar).title,
                    backgroundColor: backgroundColor,
                  )
                : null,
        backgroundColor: backgroundColor,
        child: SafeArea(
          bottom: bottomNavigationBar == null,
          child: body,
        ),
      );
    } else {
      // Autres plateformes: Utiliser Scaffold Material
      return Scaffold(
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
        backgroundColor: backgroundColor,
      );
    }
  }
}

/// AppBar adaptatif
class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;

  const AdaptiveAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
  });
  
  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.shouldUseCupertino) {
      return CupertinoNavigationBar(
        middle: title,
        backgroundColor: backgroundColor,
        leading: leading,
        trailing: actions != null && actions!.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              )
            : null,
      );
    } else {
      return AppBar(
        title: title,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        backgroundColor: backgroundColor,
      );
    }
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Bouton adaptatif
class AdaptiveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  
  const AdaptiveButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.padding,
  });
  
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
  final Color? color;
  
  const AdaptiveProgressIndicator({
    super.key,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.shouldUseCupertino) {
      return CupertinoActivityIndicator(
        color: color,
      );
    } else {
      return CircularProgressIndicator(
        valueColor: color != null ? AlwaysStoppedAnimation<Color>(color!) : null,
      );
    }
  }
}

/// Switch adaptatif
class AdaptiveSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  
  const AdaptiveSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });
  
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
  final String title;
  final String content;
  final List<AdaptiveDialogAction> actions;
  
  const AdaptiveDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });
  
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
      builder: (context) => AdaptiveDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }
}

/// Action pour AdaptiveDialog
class AdaptiveDialogAction {
  final String text;
  final VoidCallback onPressed;
  final bool isDestructive;
  
  const AdaptiveDialogAction({
    required this.text,
    required this.onPressed,
    this.isDestructive = false,
  });
}

/// TextField adaptatif
class AdaptiveTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final InputDecoration? decoration;
  
  const AdaptiveTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.decoration,
  });
  
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
        decoration: decoration ??
            InputDecoration(
              hintText: placeholder,
            ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
      );
    }
  }
}