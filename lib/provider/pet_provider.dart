import 'package:flutter/foundation.dart';
import 'package:project1/models/pet.dart';

import '../resources/cloud_data_management.dart';

class PetProvider with ChangeNotifier {
  Pet? _pet;
  final CloudStoreDataManagement _authMethods = CloudStoreDataManagement();

  Pet get getPet => _pet!;

  Future<void> refreshUser() async {
    Pet pet = await _authMethods.getPetDetails();
    _pet = pet;
    notifyListeners();
  }
}
