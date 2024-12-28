extension ListExtension<E> on List<E>? {
  /// Check if the list is empty before reducing it.
  E? reduceIfNotEmpty(E Function(E a, E b) condition) {
    return this == null || this!.isEmpty
        ? null
        : this!.reduce((aa, bb) => condition(aa, bb));
  }
}
