import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive.dart';
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
          height:
              MediaQuery.of(context).size.height *
              EcoPlatesDesignTokens.layout.categoryModalHeightRatio,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(EcoPlatesDesignTokens.radius.xxl),
              topRight: Radius.circular(EcoPlatesDesignTokens.radius.xxl),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(
                  top: EcoPlatesDesignTokens.spacing.interfaceGap(context),
                ),
                width: EcoPlatesDesignTokens.layout.modalHandleWidth,
                height: EcoPlatesDesignTokens.layout.modalHandleHeight,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.subtle,
                  ),
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.radius.xs,
                  ),
                ),
              ),

              // Title
              Padding(
                padding: EdgeInsets.all(
                  EcoPlatesDesignTokens.spacing.sectionSpacing(context),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category,
                      color: theme.colorScheme.primary,
                      size: EcoPlatesDesignTokens.layout.modalTitleIconSize,
                    ),
                    SizedBox(
                      width: EcoPlatesDesignTokens.spacing.interfaceGap(
                        context,
                      ),
                    ),
                    Text(
                      'Choisir une catégorie',
                      style: TextStyle(
                        fontSize: EcoPlatesDesignTokens.typography.modalTitle(
                          context,
                        ),
                        fontWeight: EcoPlatesDesignTokens.typography.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                height: EcoPlatesDesignTokens.layout.standardDividerHeight,
              ),

              // Categories grid
              Flexible(
                child: GridView.builder(
                  padding: EdgeInsets.all(
                    EcoPlatesDesignTokens.spacing.dialogGap(context),
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        EcoPlatesDesignTokens.layout.categoryGridCrossAxisCount,
                    crossAxisSpacing: EcoPlatesDesignTokens.spacing
                        .interfaceGap(context),
                    mainAxisSpacing: EcoPlatesDesignTokens.spacing.interfaceGap(
                      context,
                    ),
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
                        borderRadius: BorderRadius.circular(
                          EcoPlatesDesignTokens.radius.lg,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withValues(
                                    alpha:
                                        EcoPlatesDesignTokens.opacity.pressed,
                                  )
                                : theme.colorScheme.surfaceContainerHighest
                                      .withValues(
                                        alpha: EcoPlatesDesignTokens
                                            .opacity
                                            .semiTransparent,
                                      ),
                            borderRadius: BorderRadius.circular(
                              EcoPlatesDesignTokens.radius.lg,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? color
                                  : theme.colorScheme.outline.withValues(
                                      alpha: EcoPlatesDesignTokens
                                          .opacity
                                          .veryTransparent,
                                    ),
                              width: isSelected
                                  ? EcoPlatesDesignTokens
                                        .layout
                                        .selectedBorderWidth
                                  : EcoPlatesDesignTokens
                                        .layout
                                        .unselectedBorderWidth,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                duration: EcoPlatesDesignTokens.animation.fast,
                                padding: EdgeInsets.all(
                                  EcoPlatesDesignTokens.spacing.interfaceGap(
                                    context,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color.withValues(
                                          alpha: EcoPlatesDesignTokens
                                              .opacity
                                              .overlay,
                                        )
                                      : color.withValues(
                                          alpha: EcoPlatesDesignTokens
                                              .opacity
                                              .hover,
                                        ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  icon,
                                  color: isSelected
                                      ? color
                                      : color.withValues(
                                          alpha: EcoPlatesDesignTokens
                                              .opacity
                                              .textSecondary,
                                        ),
                                  size: EcoPlatesDesignTokens
                                      .layout
                                      .categoryGridIconSize,
                                ),
                              ),
                              SizedBox(
                                height: EcoPlatesDesignTokens.spacing.microGap(
                                  context,
                                ),
                              ),
                              Text(
                                category,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: EcoPlatesDesignTokens.typography
                                      .hint(context),
                                  fontWeight: isSelected
                                      ? EcoPlatesDesignTokens
                                            .typography
                                            .semiBold
                                      : EcoPlatesDesignTokens
                                            .typography
                                            .regular,
                                  color: isSelected
                                      ? color
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: EcoPlatesDesignTokens
                                    .layout
                                    .shortTextMaxLines,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (isSelected) ...[
                                SizedBox(
                                  height: EcoPlatesDesignTokens.spacing
                                      .microGap(context),
                                ),
                                Container(
                                  width: EcoPlatesDesignTokens
                                      .layout
                                      .categorySelectionDotSize,
                                  height: EcoPlatesDesignTokens
                                      .layout
                                      .categorySelectionDotSize,
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
          height:
              MediaQuery.of(context).size.height *
              EcoPlatesDesignTokens.layout.unitModalHeightRatio,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(EcoPlatesDesignTokens.radius.xxl),
              topRight: Radius.circular(EcoPlatesDesignTokens.radius.xxl),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(
                  top: EcoPlatesDesignTokens.spacing.interfaceGap(context),
                ),
                width: EcoPlatesDesignTokens.layout.modalHandleWidth,
                height: EcoPlatesDesignTokens.layout.modalHandleHeight,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.subtle,
                  ),
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.radius.xs,
                  ),
                ),
              ),

              // Title
              Padding(
                padding: EdgeInsets.all(
                  EcoPlatesDesignTokens.spacing.sectionSpacing(context),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.straighten,
                      color: theme.colorScheme.primary,
                      size: EcoPlatesDesignTokens.layout.modalTitleIconSize,
                    ),
                    SizedBox(
                      width: EcoPlatesDesignTokens.spacing.interfaceGap(
                        context,
                      ),
                    ),
                    Text(
                      'Choisir une unité',
                      style: TextStyle(
                        fontSize: EcoPlatesDesignTokens.typography.modalTitle(
                          context,
                        ),
                        fontWeight: EcoPlatesDesignTokens.typography.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                height: EcoPlatesDesignTokens.layout.standardDividerHeight,
              ),

              // Units list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    bottom: EcoPlatesDesignTokens.spacing.dialogGap(context),
                  ),
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
                        width: EcoPlatesDesignTokens.layout.unitContainerWidth,
                        height:
                            EcoPlatesDesignTokens.layout.unitContainerHeight,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.surfaceContainerHighest
                                    .withValues(
                                      alpha: EcoPlatesDesignTokens
                                          .opacity
                                          .semiTransparent,
                                    ),
                          borderRadius: BorderRadius.circular(
                            EcoPlatesDesignTokens.radius.lg,
                          ),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary.withValues(
                                    alpha: EcoPlatesDesignTokens.opacity.subtle,
                                  )
                                : Colors.transparent,
                            width:
                                EcoPlatesDesignTokens
                                    .layout
                                    .unselectedBorderWidth *
                                EcoPlatesDesignTokens
                                    .opacity
                                    .selectedBorderMultiplier,
                          ),
                        ),
                        child: Icon(
                          getUnitIcon(unit),
                          size: EcoPlatesDesignTokens.layout.unitIconSize,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      title: Text(
                        unit,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? EcoPlatesDesignTokens.typography.semiBold
                              : EcoPlatesDesignTokens.typography.regular,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: EcoPlatesDesignTokens.spacing
                            .sectionSpacing(context),
                        vertical: EcoPlatesDesignTokens.spacing.interfaceGap(
                          context,
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
              topLeft: Radius.circular(EcoPlatesDesignTokens.radius.xxl),
              topRight: Radius.circular(EcoPlatesDesignTokens.radius.xxl),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(
                  top: EcoPlatesDesignTokens.spacing.interfaceGap(context),
                ),
                width: EcoPlatesDesignTokens.layout.modalHandleWidth,
                height: EcoPlatesDesignTokens.layout.modalHandleHeight,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.subtle,
                  ),
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.radius.xs,
                  ),
                ),
              ),

              // Title
              Padding(
                padding: EdgeInsets.all(
                  EcoPlatesDesignTokens.spacing.sectionSpacing(context),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.toggle_on,
                      color: theme.colorScheme.primary,
                      size: EcoPlatesDesignTokens.layout.modalTitleIconSize,
                    ),
                    SizedBox(
                      width: EcoPlatesDesignTokens.spacing.interfaceGap(
                        context,
                      ),
                    ),
                    Text(
                      "Statut de l'article",
                      style: TextStyle(
                        fontSize: EcoPlatesDesignTokens.typography.modalTitle(
                          context,
                        ),
                        fontWeight: EcoPlatesDesignTokens.typography.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                height: EcoPlatesDesignTokens.layout.standardDividerHeight,
              ),

              // Status options
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: EcoPlatesDesignTokens.spacing.microGap(context),
                ),
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
                        width: EcoPlatesDesignTokens.layout.unitContainerWidth,
                        height:
                            EcoPlatesDesignTokens.layout.unitContainerHeight,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withValues(
                                  alpha: EcoPlatesDesignTokens.opacity.pressed,
                                )
                              : theme.colorScheme.surfaceContainerHighest
                                    .withValues(
                                      alpha: EcoPlatesDesignTokens
                                          .opacity
                                          .semiTransparent,
                                    ),
                          borderRadius: BorderRadius.circular(
                            EcoPlatesDesignTokens.radius.lg,
                          ),
                          border: Border.all(
                            color: isSelected
                                ? color.withValues(
                                    alpha: EcoPlatesDesignTokens
                                        .opacity
                                        .semiTransparent,
                                  )
                                : Colors.transparent,
                            width: EcoPlatesDesignTokens
                                .layout
                                .selectedBorderWidth,
                          ),
                        ),
                        child: Icon(
                          icon,
                          size: EcoPlatesDesignTokens.size.icon(context),
                          color: color,
                        ),
                      ),
                      title: Text(
                        status.label,
                        style: TextStyle(
                          fontSize: EcoPlatesDesignTokens.typography.text(
                            context,
                          ),
                          fontWeight: isSelected
                              ? EcoPlatesDesignTokens.typography.semiBold
                              : EcoPlatesDesignTokens.typography.regular,
                          color: isSelected
                              ? color
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        status == StockItemStatus.active
                            ? 'Article disponible à la vente'
                            : 'Article temporairement indisponible',
                        style: TextStyle(
                          fontSize: EcoPlatesDesignTokens.typography.hint(
                            context,
                          ),
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: color,
                              size: EcoPlatesDesignTokens.size.icon(context),
                            )
                          : null,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: EcoPlatesDesignTokens.spacing
                            .sectionSpacing(context),
                        vertical: EcoPlatesDesignTokens.spacing.interfaceGap(
                          context,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(
                height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
              ),
            ],
          ),
        );
      },
    ),
  );
}
