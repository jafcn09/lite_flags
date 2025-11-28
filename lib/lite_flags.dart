import 'dart:convert';

typedef FlagLoader = Future<String> Function(String url);

class LiteFlags {
  static final LiteFlags _instance = LiteFlags._();
  factory LiteFlags() => _instance;
  LiteFlags._();

  final Map<String, dynamic> _flags = {};
  FlagLoader? _loader;

  void setLoader(FlagLoader loader) => _loader = loader;

  Future<void> load(String url) async {
    final loader = _loader;
    if (loader == null) throw StateError('Loader not set. Call setLoader first.');
    _flags.addAll(jsonDecode(await loader(url)) as Map<String, dynamic>);
  }

  void set(String key, dynamic value) => _flags[key] = value;

  T get<T>(String key, T defaultValue) => _flags[key] as T? ?? defaultValue;

  bool isEnabled(String key) => get<bool>(key, false);

  void clear() => _flags.clear();
}
