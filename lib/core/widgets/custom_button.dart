import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lingora/core/utils/app_constants.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Color color;
  final Color? textColor;
  final bool isLoading;
  final VoidCallback function;
  final double? width;
  final double? height;
  final double borderRadius;
  final Gradient? gradient;
  final Border? border;
  final IconData? icon;
  final Color? iconColor;
  final Widget? loadingWidget;
  final bool enableHapticFeedback;
  final bool enableShadow;
  final double? elevation;
  final Color? shadowColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.function,
    required this.textColor,
    this.gradient,
    this.height,
    this.borderRadius = AppDimens.radiusXL,
    this.isLoading = false,
    this.border,
    this.width,
    this.icon,
    this.iconColor,
    this.loadingWidget,
    this.enableHapticFeedback = true,
    this.enableShadow = true,
    this.elevation,
    this.shadowColor,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isLoading) {
      setState(() => _isPressed = true);
      _animationController.forward();
      if (widget.enableHapticFeedback) {
        HapticFeedback.lightImpact();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isLoading) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (!widget.isLoading) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveElevation =
        widget.elevation ?? (widget.enableShadow ? 8.0 : 0.0);
    final pressedElevation = effectiveElevation * 0.5;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.width ?? AppButtonSizes.width(context),
            height: widget.height ?? AppButtonSizes.height(context),
            decoration: BoxDecoration(
              border: widget.border,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              gradient: widget.gradient,
              color: widget.gradient == null ? widget.color : null,
              boxShadow: widget.enableShadow
                  ? [
                      BoxShadow(
                        color: (widget.shadowColor ?? widget.color)
                            .withValues(alpha: _isPressed ? 0.2 : 0.3),
                        blurRadius:
                            _isPressed ? pressedElevation : effectiveElevation,
                        offset: Offset(0, _isPressed ? 2 : 4),
                        spreadRadius: _isPressed ? 0 : 1,
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.isLoading ? null : widget.function,
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                splashColor: Colors.white.withValues(alpha: 0.2),
                highlightColor: Colors.white.withValues(alpha: 0.1),
                child: Container(
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                      );
                    },
                    child: widget.isLoading
                        ? _buildLoadingWidget()
                        : _buildButtonContent(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return widget.loadingWidget ??
        SizedBox(
          key: const ValueKey('loading'),
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.textColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        );
  }

  Widget _buildButtonContent() {
    return Row(
      key: const ValueKey('content'),
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Icon(
                  widget.icon,
                  size: AppDimens.iconM,
                  color: widget.iconColor ??
                      widget.textColor ??
                      Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
          SizedBox(width: AppDimens.elementBetween),
        ],
        Text(
          widget.text,
          style: TextStyle(
            color: widget.textColor ??
                Theme.of(context).textTheme.bodyMedium!.color,
            fontSize: AppButtonSizes.textSize(context),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
