<p align="center">
  <h1 align="center">LiteFlags</h1>
  <p align="center">
    <strong>Minimal feature flags for Dart & Flutter</strong><br>
    <em>Flags de características minimalista para Dart y Flutter</em>
  </p>
</p>

<p align="center">
  <a href="#installation">Installation</a> •
  <a href="#usage">Usage</a> •
  <a href="#api">API</a> •
  <a href="#examples">Examples</a>
</p>

---

## Why LiteFlags? / ¿Por qué LiteFlags?

| | |
|---|---|
| **EN** | Stop scattering `if (kDebugMode)` and loose constants across your codebase. LiteFlags provides a single source of truth for feature flags—local or remote. |
| **ES** | Deja de esparciar `if (kDebugMode)` y constantes sueltas por tu código. LiteFlags provee una única fuente de verdad para feature flags—locales o remotos. |

---

## Installation

```yaml
# pubspec.yaml
dependencies:
  lite_flags:
    git:
      url: https://github.com/your-username/lite_flags.git
```

---

## Usage

```dart
import 'package:lite_flags/lite_flags.dart';
import 'package:http/http.dart' as http;

final flags = LiteFlags();

// 1. Inject loader (http, dio, or custom)
flags.setLoader((url) async => (await http.get(Uri.parse(url))).body);

// 2. Load remote config
await flags.load('https://api.example.com/config.json');

// 3. Query flags
if (flags.isEnabled('dark_mode')) { /* ... */ }
final limit = flags.get<int>('max_items', 10);
```

---

## API

```dart
void setLoader(FlagLoader loader)      
Future<void> load(String url)        
void set(String key, dynamic value)   
T get<T>(String key, T defaultValue)   
bool isEnabled(String key)             
void clear()                         
```

---

## Examples

<details>
<summary><strong>Dio Integration</strong></summary>

```dart
final dio = Dio();
flags.setLoader((url) async => (await dio.get(url)).data);
```
</details>

<details>
<summary><strong>Flutter Provider</strong></summary>

```dart
class FlagsNotifier extends ChangeNotifier {
  final _flags = LiteFlags();

  Future<void> init(FlagLoader loader, String url) async {
    _flags.setLoader(loader);
    await _flags.load(url);
    notifyListeners();
  }

  bool isEnabled(String key) => _flags.isEnabled(key);
}
```
</details>

<details>
<summary><strong>Unit Testing</strong></summary>

```dart
test('loads flags correctly', () async {
  LiteFlags().setLoader((_) async => '{"feature": true}');
  await LiteFlags().load('mock');
  expect(LiteFlags().isEnabled('feature'), isTrue);
});
```
</details>

---

## JSON Schema

```json
{
  "feature_x": true,
  "max_upload_mb": 10,
  "api_version": "v2"
}
```

---

## License

MIT License

Copyright (c) 2025 Jhafet Cánepa

