import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ScrollController scrollController;
  
  const CustomAppBar({
    super.key,
    required this.scrollController,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(160); // Default height
}

class _CustomAppBarState extends State<CustomAppBar> with SingleTickerProviderStateMixin {
  bool _isScrolled = false;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;
  
  @override
  Size get preferredSize => Size.fromHeight(_isScrolled ? 60 : 160); // Shrink height when scrolled
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _positionAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
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

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 768;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: Colors.white,
      child: Column(
        children: [
          // Top row - Brand name and navigation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Brand name with logo
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
                                'lib/assets/logo.jpg',
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
                
                // Navigation items
                if (!isSmallScreen) ...[
                  const SizedBox(width: 30), // Space from brand name
                  _NavItem(text: 'Home', isActive: true, onTap: () {}),
                  const SizedBox(width: 10),
                  _NavItem(text: 'Courses', onTap: () {}),
                  const SizedBox(width: 10),
                  _NavItem(text: 'Contact Us', onTap: () {}),
                  const SizedBox(width: 10),
                  _NavItem(text: 'FAQ', onTap: () {}),
                  const SizedBox(width: 10),
                  _NavItem(text: 'About Us', onTap: () {}),
                  const Spacer(), // Pushes sign up button to the right
                  const SizedBox(width: 40), // Space before sign up button
                  // Sign Up button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F5DA8), // Match home screen button color
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14), // Match home screen button border radius
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600, // Match home screen button text weight
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
                if (isSmallScreen)
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () {
                      // TODO: Implement mobile menu drawer
                    },
                  ),
              ],
            ),
          ),
          
          // Bottom row - Logo that animates up (only shown when not scrolled)
          if (!_isScrolled)
            Container(
              height: 100,
              alignment: Alignment.center,
              child: Image.asset(
                'lib/assets/logo.jpg',
                height: 90,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => 
                    const FlutterLogo(),
              ),
            ),
        ],
      ),
    );
  }
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
