import Foundation

/// Phase 2 stub: a transaction synced from Plaid.
struct PlaidTransaction: Identifiable, Hashable {
    let id: String
    let merchantName: String
    let amount: Double
    let date: Date
    var isFlaggedAsImpulse: Bool

    /// Mock data used until the Plaid backend is wired up.
    static let mockTransactions: [PlaidTransaction] = [
        PlaidTransaction(
            id: "txn_001",
            merchantName: "DoorDash",
            amount: 42.75,
            date: Calendar.current.date(byAdding: .day, value: -1, to: .now) ?? .now,
            isFlaggedAsImpulse: false
        ),
        PlaidTransaction(
            id: "txn_002",
            merchantName: "Apple Store",
            amount: 249.00,
            date: Calendar.current.date(byAdding: .day, value: -2, to: .now) ?? .now,
            isFlaggedAsImpulse: false
        ),
        PlaidTransaction(
            id: "txn_003",
            merchantName: "Starbucks",
            amount: 8.95,
            date: Calendar.current.date(byAdding: .day, value: -3, to: .now) ?? .now,
            isFlaggedAsImpulse: false
        ),
        PlaidTransaction(
            id: "txn_004",
            merchantName: "Amazon",
            amount: 67.32,
            date: Calendar.current.date(byAdding: .day, value: -5, to: .now) ?? .now,
            isFlaggedAsImpulse: false
        ),
        PlaidTransaction(
            id: "txn_005",
            merchantName: "StockX",
            amount: 185.00,
            date: Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? .now,
            isFlaggedAsImpulse: false
        )
    ]
}
