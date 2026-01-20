# PulseNow Flutter Crypto app sample

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



### Screen shots
<img width="300" height="2556" alt="Simulator Screenshot - iPhone 16 - 2026-01-19 at 01 43 28" src="https://github.com/user-attachments/assets/8a44d591-0250-4999-9205-c11c0299f5b2" />
<img width="300" height="2556" alt="Simulator Screenshot - iPhone 16 - 2026-01-19 at 01 43 45" src="https://github.com/user-attachments/assets/c6a723b3-ac41-4bc2-8c4f-5bf7164448ed" />
<img width="300" height="2556" alt="Simulator Screenshot - iPhone 16 - 2026-01-19 at 01 43 38" src="https://github.com/user-attachments/assets/ada8ba68-74ae-4954-a87c-037defa04b2f" />
<img width="300" height="2556" alt="Simulator Screenshot - iPhone 16 - 2026-01-19 at 01 44 08" src="https://github.com/user-attachments/assets/1ae50a46-17ef-40d4-96e1-0e9b64b51bd6" />
<img width="300" height="2556" alt="Simulator Screenshot - iPhone 16 - 2026-01-19 at 01 43 56" src="https://github.com/user-attachments/assets/d808af40-676e-4e8b-a65a-f9a1af2a7f3d" />
<img width="300" height="2556" alt="Simulator Screenshot - iPhone 16 - 2026-01-19 at 01 43 52" src="https://github.com/user-attachments/assets/e9a83100-b4b5-4201-9d1f-b637dfaa7aaf" />
