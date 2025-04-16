enum AppPaths {
  register("/register"),
  login("/login"),
  stories("/");

  final String path;
  const AppPaths(this.path);
}
