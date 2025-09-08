/// Runtime configuration helpers.
///
/// Read sensitive values from --dart-define during development or CI instead of
/// hardcoding them in source.
const String kApiKey = String.fromEnvironment('ECO_API_KEY', defaultValue: '');
