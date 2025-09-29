import 'dart:async';

import 'package:flutter/material.dart';

import '../../../domain/entities/stock_item.dart';
import 'utils.dart';

/// Modales pour la page de formulaire d'article de stock

/// Affiche la modale de sélection de catégorie
void showCategoryModal(
  BuildContext context,
  String? selectedCategory,
  void Function(String) onCategorySelected,
  void Function() onChangesMade, {
  required bool isEditMode,
}) {
  final theme = Theme.of(context);

  unawaited(
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 8.0),
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category,
                      color: theme.colorScheme.primary,
                      size: 24.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Choisir une catégorie',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              // Categories grid
              Flexible(
                child: GridView.builder(
                  padding: EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                  ),
                  itemCount: stockItemCategories.length,
                  itemBuilder: (context, index) {
                    final category = stockItemCategories[index];
                    final isSelected = selectedCategory == category;
                    final color = getCategoryColor(context, category);
                    final icon = getCategoryIcon(category);

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          onCategorySelected(category);
                          if (isEditMode) onChangesMade();
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withOpacity(0.15)
                                : theme.colorScheme.surfaceContainerHighest
                                      .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: isSelected ? color : Colors.transparent,
                              width: isSelected ? 2.0 : 1.0,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                width: 48.0,
                                height: 48.0,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color.withOpacity(0.2)
                                      : color.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  icon,
                                  color: isSelected
                                      ? color
                                      : color.withOpacity(0.7),
                                  size: 28.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                category,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? color
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (isSelected) ...[
                                SizedBox(height: 4.0),
                                Container(
                                  width: 8.0,
                                  height: 8.0,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

/// Affiche la modale de sélection d'unité
void showUnitModal(
  BuildContext context,
  TextEditingController unitController,
  void Function() onChangesMade, {
  required bool isEditMode,
}) {
  final theme = Theme.of(context);

  unawaited(
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 8.0),
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.straighten,
                      color: theme.colorScheme.primary,
                      size: 24.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Choisir une unité',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              // Units list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 20.0),
                  itemCount: stockItemUnits.length,
                  itemBuilder: (context, index) {
                    final unit = stockItemUnits[index];
                    final isSelected = unitController.text == unit;

                    return ListTile(
                      onTap: () {
                        unitController.text = unit;
                        if (isEditMode) onChangesMade();
                        Navigator.of(context).pop();
                      },
                      leading: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primaryContainer
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            width: 1.0,
                          ),
                        ),
                        child: Icon(
                          getUnitIcon(unit),
                          size: 20.0,
                          color: isSelected
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      title: Text(
                        unit,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                              size: 24.0,
                            )
                          : null,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 4.0,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

/// Affiche la modale de sélection de statut
void showStatusModal(
  BuildContext context,
  StockItemStatus selectedStatus,
  void Function(StockItemStatus) onStatusSelected,
  void Function() onChangesMade, {
  required bool isEditMode,
}) {
  final theme = Theme.of(context);

  unawaited(
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 8.0),
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.toggle_on,
                      color: theme.colorScheme.primary,
                      size: 24.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      "Statut de l'article",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              // Status options
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: StockItemStatus.values.map((status) {
                    final isSelected = selectedStatus == status;
                    final color = status == StockItemStatus.active
                        ? theme.colorScheme.primary
                        : theme.colorScheme.tertiary;
                    final icon = status == StockItemStatus.active
                        ? Icons.check_circle
                        : Icons.pause_circle;

                    return ListTile(
                      onTap: () {
                        onStatusSelected(status);
                        if (isEditMode) onChangesMade();
                        Navigator.of(context).pop();
                      },
                      leading: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withOpacity(0.15)
                              : theme.colorScheme.surfaceContainerHighest
                                    .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: isSelected ? color : Colors.transparent,
                            width: 2.0,
                          ),
                        ),
                        child: Icon(
                          icon,
                          size: 20.0,
                          color: color,
                        ),
                      ),
                      title: Text(
                        status.label,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: color,
                              size: 24.0,
                            )
                          : null,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 4.0,
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 20.0),
            ],
          ),
        );
      },
    ),
  );
}
