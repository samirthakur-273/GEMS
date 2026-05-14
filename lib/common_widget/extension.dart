/* 
Author-Jyoti Gite
Description:- Common File for extensions
 */

extension list_extension<T> on List<T> {
  /// returns null value if there's no item at given index
  T? get(int index) {
    try {
      return this[index];
    } on RangeError {
      return null;
    }
  }

  /// returns null value if there's no item at 0 position
  T? get firstOrNull {
    try {
      return this[0];
    } on RangeError {
      return null;
    }
  }
}
