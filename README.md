# Powerflix

A Flutter workout app that delivers structured training plans with difficulty tiers, exercise videos, and persistent favourites.

---

## Features

- **Home** — grid of workout plans loaded from a local JSON asset, cached in Hive after first launch
- **Workout Detail** — per-plan difficulty tiers (Light / Soft / Hard), exercise list, and a persistent favourite toggle
- **Video** — full-screen exercise video player with network streaming
- **Dark mode** — full theme support across all screens

---

## Tech stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3 / Dart ≥ 3.0 |
| Local storage | Hive 2 |
| Video | video_player |
| State management | `ChangeNotifier` + `ListenableBuilder` (no external package) |

---

## Architecture

The project follows a **Feature-first** folder structure with **MVVM** layering inside each feature, and a `core/` zone for shared domain models and cross-feature concerns (e.g. `FavoritesRepository`).

```
lib/
├── features/          # one vertical slice per capability
│   ├── home/
│   ├── workout_detail/
│   └── video/
├── core/              # shared domain models and repositories
├── shared/            # reusable widgets and theming
└── app/               # infrastructure (Hive init, adapters)

assets/
├── data/              # workouts.json
└── image/             # logo and muscle-map SVGs
```

| Directory | Responsibility |
|---|---|
| `features/` | One self-contained vertical slice per capability. Each feature owns its `data/`, `domain/`, and `presentation/` layers. Nothing leaks between features. |
| `core/` | Code shared by two or more features — domain models, shared repository interfaces, and cross-feature services. Promoted here only when genuinely needed by multiple features. |
| `shared/` | Reusable UI primitives and theming — widgets, colours, and `AppTheme`. No business logic. |
| `app/` | Composition root and infrastructure bootstrapping — database initialisation, adapters, and (soon) the service locator. |

Each feature is structured as:

```
feature/
├── data/datasources/      # abstract + concrete (local / network)
├── data/repositories/     # implements domain interface
├── domain/repositories/   # abstract interface (the ViewModel boundary)
└── presentation/          # ViewModel + Widget
```

For full architecture documentation — patterns, rules, and step-by-step guide for adding a new feature — see [CONTRIBUTING.md](./CONTRIBUTING.md).

---

## Getting started

### Prerequisites

- Flutter SDK `>=3.0.0` ([install guide](https://docs.flutter.dev/get-started/install))
- Dart SDK `>=3.0.0 <4.0.0` (bundled with Flutter)
- iOS Simulator / Android Emulator or a physical device

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

---

## Tests

```bash
flutter test
```

The suite covers ViewModels (via fake repositories), repository cache-aside logic, and model serialisation. All tests run without a device or emulator.

---

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for the branching strategy (Gitflow), architecture guide, and the checklist for adding a new feature.
