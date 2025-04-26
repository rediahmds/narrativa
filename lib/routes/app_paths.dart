enum AppPaths {
  register("/register"),
  login("/login"),
  stories("/stories");

  final String path;
  const AppPaths(this.path);
}
