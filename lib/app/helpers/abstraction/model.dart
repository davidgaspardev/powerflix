abstract class Model {
  /// Constant constructor
  ///
  /// Using a const constructor allows a class of objects that cannot be
  /// defined using a literal syntax to be assigned to a constant identifier.
  /// When using the const keyword for initialization, no matter how many
  /// times you instantiate an object with the same values, only one instance
  /// exists in memory.
  const Model();

  Map<String, dynamic> toMap();

  String toJson();
}