import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavedPurchase.dateSaved, order: .reverse) private var purchases: [SavedPurchase]

    @State private var showingEntrySheet = false

    private let viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                List {
                    Section {
                        header
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }

                    Section("Skipped Purchases") {
                        if purchases.isEmpty {
                            ContentUnavailableView(
                                "Nothing saved yet",
                                systemImage: "sparkles",
                                description: Text("Log a temptation to see what skipping it could be worth.")
                            )
                        } else {
                            ForEach(purchases) { purchase in
                                purchaseRow(purchase)
                            }
                            .onDelete(perform: deletePurchases)
                        }
                    }

                    // Spacer so the last row isn't hidden behind the button.
                    Section {
                        Color.clear
                            .frame(height: 60)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.insetGrouped)

                logTemptationButton
            }
            .navigationTitle("FutureWealth")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        TransactionFeedView()
                    } label: {
                        Image(systemName: "creditcard")
                    }
                    .accessibilityLabel("Transactions")
                }
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        PlaidConnectView()
                    } label: {
                        Image(systemName: "link")
                    }
                    .accessibilityLabel("Connect Bank")
                }
            }
            .sheet(isPresented: $showingEntrySheet) {
                TemptationEntryView()
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Total Future Wealth Saved")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(viewModel.totalFutureWealth(for: purchases).asCurrency)
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .contentTransition(.numericText())
            Text("Projected at 10% (S&P 500)")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func purchaseRow(_ purchase: SavedPurchase) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(purchase.itemName)
                        .font(.headline)
                    if purchase.isRecurring {
                        Image(systemName: "repeat")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Text(purchase.dateSaved, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                if let total = purchase.totalContributedLabel {
                    Text("\(purchase.amountLabel) · \(total) total")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text(purchase.amountLabel)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Text("→ \(viewModel.projectedValue(for: purchase).asCurrency) \(purchase.horizonDisplayLabel)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.green)
            }
        }
        .padding(.vertical, 2)
    }

    private var logTemptationButton: some View {
        Button {
            showingEntrySheet = true
        } label: {
            Label("Log a Temptation", systemImage: "plus.circle.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
        }
        .buttonStyle(.borderedProminent)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    private func deletePurchases(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(purchases[index])
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: SavedPurchase.self, inMemory: true)
}
