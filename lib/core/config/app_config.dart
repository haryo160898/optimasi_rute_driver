class AppConfig {
  const AppConfig({
    this.baseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.example.com',
    ),
    this.mockMode = const bool.fromEnvironment('MOCK_MODE', defaultValue: true),
  });

  final String baseUrl;
  final bool mockMode;
}
