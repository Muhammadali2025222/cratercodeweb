import 'package:flutter/foundation.dart';

class WhatsAppVisibilityProvider with ChangeNotifier {
  bool _isVisible = true;

  bool get isVisible => _isVisible;

  void setVisibility(bool value) {
    if (_isVisible == value) return;
    _isVisible = value;
    notifyListeners();
  }
}
