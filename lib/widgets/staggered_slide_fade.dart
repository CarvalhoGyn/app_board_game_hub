import 'package:flutter/material.dart';

class StaggeredSlideFade extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration duration;
  final double offset;
  final Axis direction; // Added support for horizontal sliding

  const StaggeredSlideFade({
    super.key,
    required this.child,
    required this.index,
    this.duration = const Duration(milliseconds: 400),
    this.offset = 50.0,
    this.direction = Axis.vertical,
  });

  @override
  State<StaggeredSlideFade> createState() => _StaggeredSlideFadeState();
}

class _StaggeredSlideFadeState extends State<StaggeredSlideFade> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    
    final beginOffset = widget.direction == Axis.vertical 
        ? Offset(0, widget.offset) 
        : Offset(widget.offset, 0);

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Stagger delay based on index
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}
