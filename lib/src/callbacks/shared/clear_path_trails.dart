extension ClearPathTrailsEx on String {
  String get clearPathTrails => this.replaceAll(RegExp(r'[\\/]$'), '');
}
