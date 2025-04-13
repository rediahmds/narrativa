enum AppPaths {
  register("/register"),
  login("/login");

  final String path;
  const AppPaths(this.path);
}
