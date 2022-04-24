import 'package:flutter/widgets.dart';
import 'package:project1/resources/cloud_data_management.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final CloudStoreDataManagement _authMethods = CloudStoreDataManagement();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
