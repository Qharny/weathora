import 'package:flutter/material.dart';

class FloatingMenuButton extends StatefulWidget {
  final VoidCallback onLocationPressed;
  final VoidCallback onSettingsPressed;

  const FloatingMenuButton({super.key, 
    required this.onLocationPressed,
    required this.onSettingsPressed,
  });

  @override
  State<FloatingMenuButton> createState() => _FloatingMenuButtonState();
}

class _FloatingMenuButtonState extends State<FloatingMenuButton>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 200,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Settings Button
          SizeTransition(
            sizeFactor: _expandAnimation,
            axis: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.only(bottom: 140),
              child: FloatingActionButton(
                heroTag: 'settings',
                onPressed: () {
                  _toggleMenu();
                  widget.onSettingsPressed();
                },
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.settings),
              ),
            ),
          ),
          // Location Button
          SizeTransition(
            sizeFactor: _expandAnimation,
            axis: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.only(bottom: 70),
              child: FloatingActionButton(
                heroTag: 'location',
                onPressed: () {
                  _toggleMenu();
                  widget.onLocationPressed();
                },
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.my_location),
              ),
            ),
          ),
          // Menu Button
          FloatingActionButton(
            heroTag: 'menu',
            onPressed: _toggleMenu,
            backgroundColor: Theme.of(context).primaryColor,
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _expandAnimation,
            ),
          ),
        ],
      ),
    );
  }
}