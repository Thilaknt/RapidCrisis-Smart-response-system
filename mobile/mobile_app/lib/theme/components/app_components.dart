/// Reusable Professional Components
/// Status indicators, alerts, cards, and other common UI elements

import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';
import '../tokens/spacing.dart';

// ========== STATUS BADGE ==========
class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Widget? icon;

  const StatusBadge({
    Key? key,
    required this.label,
    required this.backgroundColor,
    this.textColor = AppColors.white,
    this.icon,
  }) : super(key: key);

  factory StatusBadge.success(String label, {Widget? icon}) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.success,
      icon: icon,
    );
  }

  factory StatusBadge.warning(String label, {Widget? icon}) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.warning,
      textColor: AppColors.gray950,
      icon: icon,
    );
  }

  factory StatusBadge.error(String label, {Widget? icon}) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.error,
      icon: icon,
    );
  }

  factory StatusBadge.critical(String label, {Widget? icon}) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.critical,
      icon: icon,
    );
  }

  factory StatusBadge.info(String label, {Widget? icon}) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.info,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            SizedBox(width: AppSpacing.sm),
          ],
          Text(
            label,
            style: AppTypography.badge.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}

// ========== ALERT CARD ==========
class AlertCard extends StatelessWidget {
  final String title;
  final String message;
  final AlertType type;
  final Widget? icon;
  final VoidCallback? onDismiss;
  final List<Widget>? actions;

  const AlertCard({
    Key? key,
    required this.title,
    required this.message,
    required this.type,
    this.icon,
    this.onDismiss,
    this.actions,
  }) : super(key: key);

  Color get _backgroundColor {
    switch (type) {
      case AlertType.error:
        return AppColors.errorLight;
      case AlertType.warning:
        return AppColors.warningLight;
      case AlertType.success:
        return AppColors.successLight;
      case AlertType.info:
        return AppColors.infoLight;
    }
  }

  Color get _borderColor {
    switch (type) {
      case AlertType.error:
        return AppColors.error;
      case AlertType.warning:
        return AppColors.warning;
      case AlertType.success:
        return AppColors.success;
      case AlertType.info:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        side: BorderSide(color: _borderColor, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null) ...[
                  Padding(
                    padding: EdgeInsets.only(right: AppSpacing.md),
                    child: icon!,
                  ),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.cardTitle),
                      SizedBox(height: AppSpacing.sm),
                      Text(message, style: AppTypography.body),
                    ],
                  ),
                ),
                if (onDismiss != null)
                  GestureDetector(
                    onTap: onDismiss,
                    child: const Icon(Icons.close, size: 20),
                  ),
              ],
            ),
            if (actions != null && actions!.isNotEmpty) ...[
              SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!
                    .asMap()
                    .entries
                    .map((entry) {
                      if (entry.key > 0) {
                        return SizedBox(width: AppSpacing.md);
                      }
                      return entry.value;
                    })
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum AlertType { error, warning, success, info }

// ========== INFO CARD ==========
class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? icon;
  final VoidCallback? onTap;
  final bool isCompact;

  const InfoCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.onTap,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: EdgeInsets.all(isCompact ? AppSpacing.md : AppSpacing.lg),
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: EdgeInsets.only(right: AppSpacing.lg),
              child: icon!,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.cardTitle,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  subtitle,
                  style: AppTypography.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: child,
        ),
      );
    }

    return Card(child: child);
  }
}

// ========== STAT TILE ==========
class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final Color? color;
  final Widget? icon;
  final VoidCallback? onTap;

  const StatTile({
    Key? key,
    required this.label,
    required this.value,
    this.unit,
    this.color,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: icon!,
            ),
          Text(label, style: AppTypography.caption),
          SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: AppTypography.displaySmall),
              if (unit != null)
                Padding(
                  padding: EdgeInsets.only(left: AppSpacing.sm),
                  child: Text(unit!, style: AppTypography.bodyMedium),
                ),
            ],
          ),
        ],
      ),
    );

    if (onTap != null) {
      return Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: child,
        ),
      );
    }

    return Card(child: child);
  }
}

// ========== SECTION HEADER ==========
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTrailingTap;

  const SectionHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTrailingTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppTypography.sectionTitle),
                if (subtitle != null) ...[
                  SizedBox(height: AppSpacing.sm),
                  Text(subtitle!, style: AppTypography.body),
                ],
              ],
            ),
          ),
          if (trailing != null)
            GestureDetector(
              onTap: onTrailingTap,
              child: trailing!,
            ),
        ],
      ),
    );
  }
}

// ========== LOADING SKELETON ==========
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const SkeletonLoader({
    Key? key,
    this.width = double.infinity,
    this.height = 20,
    BorderRadius? borderRadius,
  })  : borderRadius = borderRadius ?? const BorderRadius.all(Radius.circular(8)),
        super(key: key);

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        color: AppColors.surfaceMuted,
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.surfaceMuted,
                  AppColors.gray300,
                  AppColors.surfaceMuted,
                ],
                stops: [
                  _controller.value - 0.3,
                  _controller.value,
                  _controller.value + 0.3,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ========== EMPTY STATE ==========
class EmptyState extends StatelessWidget {
  final Widget icon;
  final String title;
  final String message;
  final Widget? action;
  final bool compact;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? AppSpacing.lg : AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(height: AppSpacing.xl),
            Text(title, style: AppTypography.headlineMedium),
            SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTypography.body,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              SizedBox(height: AppSpacing.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

// ========== DIVIDER WITH TEXT ==========
class DividerWithText extends StatelessWidget {
  final String text;
  final Color? color;

  const DividerWithText({
    Key? key,
    required this.text,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: color ?? AppColors.borderLight,
            height: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            text,
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: color ?? AppColors.borderLight,
            height: 1,
          ),
        ),
      ],
    );
  }
}
