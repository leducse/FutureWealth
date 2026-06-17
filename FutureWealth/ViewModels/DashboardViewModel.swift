import Foundation

/// Aggregate math for the dashboard. Kept as a stateless helper so the view
/// can feed it the live SwiftData query results.
struct DashboardViewModel {
    /// Total future wealth across all saved purchases, projected at the
    /// S&P 500 benchmark rate (10%) over each purchase's own horizon.
    func totalFutureWealth(for purchases: [SavedPurchase]) -> Double {
        purchases.reduce(0) { total, purchase in
            total + CalculatorEngine.projectedValue(for: purchase, in: .sp500)
        }
    }

    /// Future value of a single purchase at the S&P 500 rate.
    func projectedValue(for purchase: SavedPurchase) -> Double {
        CalculatorEngine.projectedValue(for: purchase, in: .sp500)
    }
}
