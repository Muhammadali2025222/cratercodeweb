import 'package:flutter/material.dart';
import '../screens/application_form_screen.dart';
import '../screens/login_screen.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ScrollController scrollController;
  final String? title;
  
  const CustomAppBar({
    super.key,
    required this.scrollController,
    this.title,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(140); // Default height
}

class _CustomAppBarState extends State<CustomAppBar> with SingleTickerProviderStateMixin {
  bool _isScrolled = false;
  late AnimationController _animationController;
  static const List<_NavMenuItem> _navItems = [
    _NavMenuItem(text: 'Home', isActive: true, onSelected: _noop),
    _NavMenuItem(text: 'Courses', onSelected: _noop),
    _NavMenuItem(text: 'Contact Us', onSelected: _noop),
    _NavMenuItem(text: 'FAQ', onSelected: _noop),
    _NavMenuItem(text: 'About Us', onSelected: _noop),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    widget.scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _animationController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (widget.scrollController.offset > 100 && !_isScrolled) {
      setState(() {
        _isScrolled = true;
        _animationController.forward();
      });
    } else if (widget.scrollController.offset <= 100 && _isScrolled) {
      setState(() {
        _isScrolled = false;
        _animationController.reverse();
      });
    }
  }

  List<Widget> _buildDesktopNavChildren() {
    final widgets = <Widget>[const SizedBox(width: 30)];

    for (var i = 0; i < _navItems.length; i++) {
      if (i > 0) {
        widgets.add(const SizedBox(width: 10));
      }

      final item = _navItems[i];
      widgets.add(
        _NavItem(
          text: item.text,
          isActive: item.isActive,
          onTap: item.onSelected,
        ),
      );
    }

    widgets.addAll([
      const Spacer(),
      const SizedBox(width: 20),
      // Login Button
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF2F5DA8)),
          ),
        ),
        child: const Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF2F5DA8),
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
      ),
      const SizedBox(width: 20),
    ]);

    // Apply Now Button
    widgets.add(
      Builder(
        builder: (context) => ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ApplicationFormScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2F5DA8),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 4,
          ),
          child: const Text(
            'APPLY NOW',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );

    return widgets;
  }

  void _openMobileMenu(List<_NavMenuItem> navItems) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'CRATER CODE',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Color(0xFF24395A),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      color: const Color(0xFF24395A),
                      onPressed: () => Navigator.of(sheetContext).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                for (final item in navItems)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                        item.onSelected();
                      },
                      style: TextButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        foregroundColor: const Color(0xFF24395A),
                      ),
                      child: Row(
                        children: [
                          if (item.isActive)
                            Container(
                              width: 4,
                              height: 20,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: const BoxDecoration(
                                color: Color(0xFF24395A),
                                borderRadius: BorderRadius.all(Radius.circular(2)),
                              ),
                            )
                          else
                            const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              item.text.toUpperCase(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: item.isActive ? FontWeight.w700 : FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                // Login Button
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFF2F5DA8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Color(0xFF2F5DA8),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Apply Now Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ApplicationFormScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F5DA8),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'APPLY NOW',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 768;
    
    const collapsedHeight = 68.0;
    const expandedHeight = 140.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isScrolled ? collapsedHeight : expandedHeight,
      color: Colors.white,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: _isScrolled
                                ? Tween<double>(begin: 0.0, end: 1.0).animate(animation)
                                : Tween<double>(begin: 1.0, end: 0.0).animate(animation),
                            child: SlideTransition(
                              position: _isScrolled
                                  ? Tween<Offset>(
                                      begin: const Offset(-0.5, 0.0),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOutCubic,
                                    ))
                                  : Tween<Offset>(
                                      begin: Offset.zero,
                                      end: const Offset(-0.5, 0.0),
                                    ).animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInCubic,
                                    )),
                              child: child,
                            ),
                          );
                        },
                        child: _isScrolled
                            ? Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Image.asset(
                                  'lib/assets/logo.png',
                                  key: const ValueKey('logo'),
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const FlutterLogo(size: 40),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const Text(
                        'CRATER CODE',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Color(0xFF24395A),
                        ),
                      ),
                    ],
                  ),

                  if (!isSmallScreen) ..._buildDesktopNavChildren(),
                  if (isSmallScreen)
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black),
                      onPressed: () => _openMobileMenu(_navItems),
                    ),
                ],
              ),
            ),
          ),

          if (!_isScrolled)
            Positioned(
              bottom: -28,
              child: SizedBox(
                height: 160,
                child: Image.asset(
                  'lib/assets/logo.png',
                  width: 360,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const FlutterLogo(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void _noop() {}

class _NavMenuItem {
  final String text;
  final bool isActive;
  final VoidCallback onSelected;

  const _NavMenuItem({
    required this.text,
    this.isActive = false,
    required this.onSelected,
  });
}

class _NavItem extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.text,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF24395A), // Match home screen text color
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold, // Make all navigation items bold
              letterSpacing: 0.5,
              color: const Color(0xFF24395A), // Match home screen text color
            ),
          ),
          if (isActive) ...[
            const SizedBox(height: 4),
            Container(
              height: 2,
              width: 20,
              color: const Color(0xFF24395A), // Underline color
            ),
          ],
        ],
      ),
    );
  }
}
