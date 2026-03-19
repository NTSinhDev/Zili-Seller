import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zili_coffee/data/models/user/auth.dart';
import 'package:zili_coffee/data/models/cart/cart.dart';

class _LCSKey {
  static const String currentAuth = 'currentAuth';
  static const String cart = 'cart';
  static const String lastUsername = 'lastUsername';
}

class LocalStoreService {
  SharedPreferences? _sharedPrefer;
  Future<void> config() async {
    _sharedPrefer = await SharedPreferences.getInstance();
  }

  set currentAuth(Auth? auth) {
    final json = auth?.toJson() ?? '';
    if (json.isNotEmpty) {
      _sharedPrefer?.setString(_LCSKey.currentAuth, json);
    }
  }

  Auth? get currentAuth {
    final js = _sharedPrefer?.getString(_LCSKey.currentAuth) ?? '';
    if (js.isEmpty) return null;

    final jsMap = jsonDecode(js) as Map<String, dynamic>;
    if (jsMap.isEmpty) return null;

    return Auth.fromMap(jsMap);
  }

  set cart(Cart? cart) {
    final json = cart?.toJson() ?? '';
    if (json.isNotEmpty) {
      _sharedPrefer?.setString(_LCSKey.cart, json);
    }
  }

  Cart? get cart {
    final jsonData = _sharedPrefer?.getString(_LCSKey.cart) ?? '';
    if (jsonData.isEmpty) return null;
    return Cart.fromJson(jsonData);
  }

  Future<void> clearCart() async {
    await _sharedPrefer?.remove(_LCSKey.cart);
  }

  void removeAllCache() {
    _sharedPrefer?.clear();
  }

  Future<void> logout() async {
    await _sharedPrefer?.remove(_LCSKey.currentAuth);
  }

  set lastUsername(String? username) {
    if (username != null && username.isNotEmpty) {
      _sharedPrefer?.setString(_LCSKey.lastUsername, username);
    }
  }

  String? get lastUsername {
    return _sharedPrefer?.getString(_LCSKey.lastUsername);
  }
}
