import 'package:flutter/foundation.dart';
import 'package:powerflix/core/domain/models/user.dart';
import 'package:powerflix/core/domain/repositories/user_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final UserRepository _repository;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  RegisterViewModel(this._repository);

  Future<void> save(UserModel user) async {
    _isSaving = true;
    notifyListeners();
    await _repository.saveUser(user);
    _isSaving = false;
    notifyListeners();
  }
}
