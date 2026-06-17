import SwiftUI

/// Phase 2 stub: shows mock Plaid transactions with a "Flag as Impulse" swipe action.
struct TransactionFeedView: View {
    @State private var transactions = PlaidTransaction.mockTransactions
    @State private var flaggedTransaction: PlaidTransaction?

    var body: some View {
        List {
            ForEach(transactions) { transaction in
                transactionRow(transaction)
                    .swipeActions(edge: .trailing) {
                        Button {
                            flag(transaction)
                        } label: {
                            Label("Flag as Impulse", systemImage: "exclamationmark.triangle.fill")
                        }
                        .tint(.orange)
                    }
            }
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $flaggedTransaction) { transaction in
            NavigationStack {
                RealityCheckView(
                    input: TemptationInput(
                        itemName: transaction.merchantName,
                        amount: transaction.amount,
                        isRecurring: false,
                        frequency: nil,
                        targetDate: TimeHorizon.tenYears.targetDate()
                    ),
                    onFinished: { flaggedTransaction = nil }
                )
            }
        }
    }

    private func transactionRow(_ transaction: PlaidTransaction) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.merchantName)
                    .font(.headline)
                Text(transaction.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if transaction.isFlaggedAsImpulse {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
            }
            Text(transaction.amount.asCurrency)
                .font(.subheadline.weight(.semibold))
        }
    }

    private func flag(_ transaction: PlaidTransaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[index].isFlaggedAsImpulse = true
        }
        flaggedTransaction = transaction
    }
}

#Preview {
    NavigationStack {
        TransactionFeedView()
    }
    .modelContainer(for: SavedPurchase.self, inMemory: true)
}
