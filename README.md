# FutureWealth — Opportunity Cost Calculator

An iOS app that shows what an impulse purchase could be worth if you invested the money instead. Built with SwiftUI, SwiftData, and MVVM. Targets iOS 17+.

## The Math

**One-time purchases** — compound interest:

```
FV = PV × (1 + r)^n
```

**Recurring temptations** (subscriptions, memberships) — future value of an ordinary annuity:

```
FV = PMT × [((1 + r)^n − 1) / r]
```

| Asset Class | Assumed Annual Return |
|---|---|
| High-Yield Savings | 4% |
| S&P 500 Index Fund | 10% |
| Blue Chip Tech | 14% |

Horizons can be preset (1, 5, 10, or 18 years) or a custom target date. Recurring items support monthly or yearly frequency.

## Features

### Phase 1 — Local MVP
- **Dashboard** — total future wealth saved (all skipped items projected at 10% S&P 500), plus a history of skipped purchases (newest first, swipe to delete). Recurring items show a repeat icon and per-period amount (e.g. `$15/mo`).
- **Log a Temptation** — one-time or recurring; preset or custom target date; monthly/yearly frequency for recurring items.
- **Reality Check** — future value across all three asset classes; "I bought it anyway" (saves nothing) or "I'm Saving It!" (persists to SwiftData with a success haptic).

### Phase 1.5 — Custom dates & recurring
- **Custom target date** — pick any future date instead of fixed year buckets.
- **Recurring temptations** — model subscriptions and repeating costs with annuity math.
- **Unified projection** — dashboard totals include both one-time skips and recurring commitments avoided.

### Phase 2 — Plaid (stubbed)
- **Connect Bank** (`PlaidConnectView`) — mock link/unlink toggle, ready for Plaid Link.
- **Transactions** (`TransactionFeedView`) — mock transaction feed; swipe to "Flag as Impulse" and open a Reality Check for that merchant and amount.

Both stubs are reachable from the dashboard toolbar (link and credit-card icons).

## Project Structure

```
FutureWealth/
├── FutureWealthApp.swift          # App entry point, SwiftData container
├── Models/
│   ├── SavedPurchase.swift        # @Model persisted with SwiftData
│   ├── AssetBenchmark.swift       # Asset classes, rates, time horizons
│   ├── TemptationInput.swift      # Entry → Reality Check payload
│   └── PlaidTransaction.swift     # Phase 2 stub + mock data
├── ViewModels/
│   └── DashboardViewModel.swift   # Aggregate future-value math
├── Views/
│   ├── DashboardView.swift
│   ├── TemptationEntryView.swift
│   ├── RealityCheckView.swift
│   ├── PlaidConnectView.swift
│   └── TransactionFeedView.swift
└── Utilities/
    ├── CalculatorEngine.swift     # Compound interest + annuity math
    └── FormattingHelpers.swift    # Currency formatting
```

## Requirements & Running

- **Xcode 16+** (project uses file-system-synchronized groups — new files under `FutureWealth/` are picked up automatically)
- **iOS 17.0+** simulator or device

```bash
open FutureWealth.xcodeproj
```

1. Select an iOS simulator (e.g. **iPhone 17**) — not "Any iOS Device" or a physical phone unless signing is configured.
2. Press **Cmd+R**.

For a physical device: set your development team under **Signing & Capabilities** (a free Apple ID works).

## Status

Working local MVP with custom date horizons and recurring payment modeling. Plaid integration is stubbed for a future phase.
