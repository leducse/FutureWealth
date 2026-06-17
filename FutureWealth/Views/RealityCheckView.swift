import SwiftUI
import SwiftData

struct RealityCheckView: View {
    @Environment(\.modelContext) private var modelContext

    let input: TemptationInput
    var onFinished: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                prompt

                VStack(spacing: 16) {
                    ForEach(AssetBenchmark.all) { asset in
                        assetCard(for: asset)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Reality Check")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            actionButtons
        }
    }

    private var prompt: some View {
        Group {
            if input.isRecurring, let total = input.totalContributedLabel,
               let periodLabel = input.paymentPeriodLabel {
                Text("If you skip **\(input.itemName)** and save **\(input.amountLabel)** for **\(periodLabel)** (**\(total) total**), here is what that grows to if invested by **\(input.targetDateLabel)**:")
            } else if input.isRecurring {
                Text("If you skip **\(input.itemName)** and invest **\(input.amountLabel)** instead, here is what you'll have by **\(input.targetDateLabel)**:")
            } else {
                Text("If you skip **\(input.itemName)** today and invest **\(input.amountLabel)**, here is what you'll have by **\(input.targetDateLabel)**:")
            }
        }
        .font(.title3)
        .multilineTextAlignment(.center)
        .padding(.top)
    }

    private func assetCard(for asset: AssetBenchmark) -> some View {
        let futureValue = CalculatorEngine.projectedValue(for: input, in: asset)
        let contributed = CalculatorEngine.totalContributed(for: input)

        return VStack(spacing: 8) {
            HStack {
                Image(systemName: asset.systemImage)
                    .font(.title2)
                    .foregroundStyle(.tint)
                Text(asset.name)
                    .font(.headline)
                Spacer()
                Text(asset.annualRate, format: .percent)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if let contributed {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Out of pocket")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(contributed.asCurrency)
                            .font(.title3.weight(.semibold))
                    }
                    Image(systemName: "arrow.right")
                        .foregroundStyle(.secondary)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Invested value")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(futureValue.asCurrency)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.green)
                    }
                    Spacer()
                }
            } else {
                Text(futureValue.asCurrency)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button(role: .destructive) {
                onFinished()
            } label: {
                Text("I bought it anyway")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button {
                saveIt()
            } label: {
                Text("I'm Saving It!")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
        .padding()
        .background(.bar)
    }

    private func saveIt() {
        let purchase = SavedPurchase(
            itemName: input.itemName,
            cost: input.amount,
            horizonYears: input.roundedHorizonYears,
            assetChoice: AssetBenchmark.sp500.name,
            isRecurring: input.isRecurring,
            recurrenceFrequencyRaw: input.frequency?.rawValue,
            targetDate: input.targetDate
        )
        modelContext.insert(purchase)

        UINotificationFeedbackGenerator().notificationOccurred(.success)
        onFinished()
    }
}

#Preview("One-time") {
    NavigationStack {
        RealityCheckView(
            input: TemptationInput(
                itemName: "Dinner out",
                amount: 150,
                isRecurring: false,
                frequency: nil,
                targetDate: Calendar.current.date(byAdding: .year, value: 10, to: .now)!
            ),
            onFinished: {}
        )
    }
    .modelContainer(for: SavedPurchase.self, inMemory: true)
}

#Preview("Recurring") {
    NavigationStack {
        RealityCheckView(
            input: TemptationInput(
                itemName: "Netflix",
                amount: 15,
                isRecurring: true,
                frequency: .monthly,
                targetDate: Calendar.current.date(byAdding: .year, value: 10, to: .now)!
            ),
            onFinished: {}
        )
    }
    .modelContainer(for: SavedPurchase.self, inMemory: true)
}
