# PulseNow Flutter Assessment

This is the Flutter application for the PulseNow assessment. The required features are implemented, with additional enhancements listed below.

## Setup

1. Ensure Flutter is installed (Flutter 3.0+)
2. Install dependencies:
```bash
flutter pub get
```

3. Make sure the backend server is running (see `../backend/README.md`)

4. Run the app:
```bash
flutter run
```

## Project Structure

```
├── flutter_app/                 # Flutter application
│   ├── lib/
│   │   ├── core/                # DI + shared error handling
│   │   ├── data/                # Data sources + repository impls
│   │   ├── domain/              # Repositories + use cases
│   │   ├── models/              # Data models
│   │   ├── providers/           # Provider state management
│   │   ├── screens/             # UI screens (market list + detail)
│   │   ├── services/            # API + WebSocket services
│   │   └── utils/               # Formatters, constants, UI helpers
│   ├── test/                    # Unit/widget tests
│   └── pubspec.yaml
```


## Implementation Status (per `ASSESSMENT.md`)

### Required

- [x] API integration using `http` (`GET /api/market-data`) with retries + error handling
- [x] `MarketData` model with null safety and `fromJson`
- [x] Provider-based state management (`loading`, `error`, `empty`, `success`)
- [x] Market data list UI with price + 24h change color coding
- [x] Loading + error states and clean, readable code

### Nice to Have (Implemented)

- [x] Pull-to-refresh
- [x] Currency + percent formatting (with +/- indicators)
- [x] Empty state + retry button
- [x] Detail screen with additional stats
- [x] Search/filter + sorting (symbol, price, change, volume, market cap)
- [x] WebSocket stream for live updates
- [x] Local caching with TTL (SharedPreferences)
- [x] Basic analytics hooks
- [x] Dark mode support
- [x] Unit tests for model/repository