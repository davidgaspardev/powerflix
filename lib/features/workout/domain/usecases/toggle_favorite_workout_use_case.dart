import 'package:moveflix/core/domain/repositories/user_repository.dart';

class ToggleFavoriteWorkoutUseCase {
  final UserRepository _userRepository;

  ToggleFavoriteWorkoutUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<bool> call(String workoutId) async {
    final prefs = await _userRepository.getPreferences();
    final ids = List<String>.from(prefs.favoriteWorkoutIds);
    final isFavorite = ids.contains(workoutId);

    if (isFavorite) {
      ids.remove(workoutId);
    } else {
      ids.add(workoutId);
    }

    await _userRepository.savePreferences(prefs.copyWith(favoriteWorkoutIds: ids));
    return !isFavorite;
  }
}
