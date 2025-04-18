enum AppPaths {
  register("/register"),
  login("/login"),
  home("/"),
  stories("/stories");

  final String path;
  const AppPaths(this.path);
}
