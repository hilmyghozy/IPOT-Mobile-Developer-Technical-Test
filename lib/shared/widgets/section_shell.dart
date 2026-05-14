import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';

class SectionShell extends StatelessWidget {
  const SectionShell({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.borderRadius = const BorderRadius.all(Radius.circular(28)),
    this.blurSigma = 18,
  });

  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white.withValues(alpha: 0.56),
            borderRadius: borderRadius,
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: const Color(0x140A241D),
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
