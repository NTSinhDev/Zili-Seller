import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zili_coffee/data/models/address/location.dart';
import 'package:zili_coffee/data/models/user/auth.dart';
import 'package:zili_coffee/data/models/user/ability.dart';
import 'package:zili_coffee/data/models/user/user.dart';
import 'package:zili_coffee/data/repositories/base_repository.dart';

import '../../utils/helpers/permission_helper.dart';

class AuthRepository extends BaseRepository {
  String? ipNetwork;
  // UI
  final PageController _pageViewController = PageController(initialPage: 0);
  PageController get pageViewController => _pageViewController;
  Future<void> jumpToPageView({required int pageIndex}) async {
    await _pageViewController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  final BehaviorSubject<Location> storeProvinceStream = BehaviorSubject();
  final BehaviorSubject<Location> storeDistrictStream = BehaviorSubject();
  final BehaviorSubject<Location> storeTownStream = BehaviorSubject();

  Auth? _currentAuth;
  Auth? get currentAuth => _currentAuth;
  User? get currentUser => _currentAuth?.customer;

  List<String> get sellerPermissions => _currentAuth?.sellerPermissions ?? [];
  List<Ability> get abilities => _currentAuth?.abilities ?? [];

  bool can(String action, String subject) {
    if (abilities.length == 1 &&
        abilities.first.action == AbilityAction.manage &&
        abilities.first.subject == AbilitySubject.all) {
      return true;
    }
    debugPrint('abilities: $abilities');
    final a = action.toLowerCase();
    final s = subject.toLowerCase();
    return abilities.any(
      (ab) => ab.action.toLowerCase() == a && ab.subject.toLowerCase() == s,
    );
  }

  bool hasSellerPermission(String name) {
    final key = name.toLowerCase();
    return sellerPermissions.contains(key);
  }

  Auth? getCurrentAuth() {
    return _currentAuth ??= storage.currentAuth;
  }

  void setCurrentAuth(Auth auth) {
    _currentAuth = auth;
    storage.currentAuth = auth;
  }

  void setCurrentUser(User customer) {
    _currentAuth = _currentAuth?.copyWith(customer: customer);
    storage.currentAuth = _currentAuth;
  }

  void updateAvatar(String newAvatar) {
    final currentUser = _currentAuth?.customer;
    if (currentUser != null) {
      _currentAuth = _currentAuth?.copyWith(
        customer: currentUser.copyWith(avatar: newAvatar),
      );
      storage.currentAuth = _currentAuth;
    }
  }

  @override
  Future<void> clean() async {
    _currentAuth = null;
    await storage.logout();
  }
}
