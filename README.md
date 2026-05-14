# IPOT QR Ordering

Production-style Flutter implementation of the IPOT Mobile Developer Technical Test.

Core flow: `QR Scan -> Menu -> Cart -> Submit Order -> Order Tracking`

## Tech stack

- Flutter
- Feature-first clean architecture
- `flutter_bloc` with focused cubits
- Repository pattern
- `get_it` for dependency injection
- `dio` for the API layer foundation
- `equatable` for immutable state/value equality
- Local mock JSON assets for offline development

## Features

- QR scanner using `mobile_scanner`
- QR validation for `ipot://table/{tableId}`
- Invalid QR error handling
- Menu loading from local mock JSON with simulated latency
- Category tabs and search/filter
- Required and optional customizations with price modifiers
- Cart quantity updates, removal, subtotal calculation, and summary
- Order request payload matching the PDF structure
- Mock order submission with loading/success/error states
- Confirmation screen with fake order ID
- Bonus order tracking with polling:
  `pending -> confirmed -> preparing -> ready -> served`

## Project structure

```text
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── network/
│   ├── services/
│   ├── utils/
│   └── widgets/
├── shared/
│   ├── themes/
│   └── widgets/
├── features/
│   ├── qr_scanner/
│   ├── menu/
│   ├── cart/
│   └── order/
├── injection/
├── routes/
└── main.dart
```

## Architecture notes

The app follows the requested flow:

`UI -> Cubit -> UseCase -> Repository -> DataSource`

Pragmatic decisions:

- `menu` and `order` use full data/domain/presentation separation because they sit on API boundaries.
- `cart` is local-first state, so it keeps domain entities plus presentation cubit/widgets without unnecessary remote abstractions.
- JSON parsing stays inside data models.
- Widgets stay presentation-focused; QR parsing, filtering, subtotal logic, payload mapping, and polling live outside the UI.

## Mock data

Mock assets live in `assets/mock/`:

- `menu.json`
- `order_success.json`
- `order_status.json`

`menu.json` mirrors the PDF menu response exactly.

## API layer

Even though this submission uses local assets, the project includes endpoint constants and a `dio` client foundation for future backend wiring:

- `GET /api/v1/menu`
- `POST /api/v1/orders`
- `GET /api/v1/orders/{id}`

Base URL is configurable through `.env`:

```env
BASE_URL=https://mock.ipot.local
```

## How to run

1. Install Flutter 3.41+ or use `fvm`.
2. Fetch packages:

```bash
fvm flutter pub get
```

3. Run static checks and tests:

```bash
fvm flutter analyze
fvm flutter test
```

4. Launch the app:

```bash
fvm flutter run
```

If camera access is unavailable in the simulator, use the fallback button on the scanner screen for the sample table `T001`.

## Tests included

- `test/cart_cubit_test.dart`
- `test/menu_cubit_test.dart`
- `test/cart_page_test.dart`

Verified locally with:

- `fvm flutter analyze`
- `fvm flutter test`

## Why mock data is used

The PDF includes a full menu contract but no working backend URL. Local JSON keeps the assessment deterministic, supports offline development, and still preserves the architecture needed to swap in a live backend later.

## Scalability

This codebase is set up to scale by:

- keeping feature boundaries explicit
- isolating repositories and data sources
- centralizing config and dependency injection
- separating cart, menu, submission, and tracking state into focused cubits
- using typed entities and request/response models

Replacing the mock implementation with a real backend mostly means swapping the data sources while keeping the domain and presentation layers intact.

## Assumptions

- The PDF only provides a complete mock contract for the menu response, so `order_success.json` and `order_status.json` are modeled as practical mock contracts around the documented order flow.
- The local sample menu is available for table `T001`, matching the PDF example.
- Customization option quantities are submitted as `1`, because the PDF payload shape includes quantity per option but the mock menu presents selectable options rather than repeatable add-on quantities.
# IPOT-Mobile-Developer-Technical-Test
