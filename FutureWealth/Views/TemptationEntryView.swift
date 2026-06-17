import SwiftUI
import SwiftData

private enum TemptationKind: String, CaseIterable, Identifiable {
    case oneTime = "One-time"
    case recurring = "Recurring"

    var id: String { rawValue }
}

private enum HorizonMode: String, CaseIterable, Identifiable {
    case preset = "Preset"
    case custom = "Custom Date"

    var id: String { rawValue }
}

struct TemptationEntryView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var kind: TemptationKind = .oneTime
    @State private var itemName = ""
    @State private var amount: Double?
    @State private var frequency: RecurrenceFrequency = .monthly
    @State private var horizonMode: HorizonMode = .preset
    @State private var presetHorizon: TimeHorizon = .fiveYears
    @State private var customTargetDate = Calendar.current.date(byAdding: .year, value: 10, to: .now) ?? .now
    @State private var showingRealityCheck = false

    private var resolvedTargetDate: Date {
        switch horizonMode {
        case .preset:
            return presetHorizon.targetDate()
        case .custom:
            return customTargetDate
        }
    }

    private var isValid: Bool {
        !itemName.trimmingCharacters(in: .whitespaces).isEmpty
            && (amount ?? 0) > 0
            && resolvedTargetDate > .now
    }

    private var temptationInput: TemptationInput {
        TemptationInput(
            itemName: itemName.trimmingCharacters(in: .whitespaces),
            amount: amount ?? 0,
            isRecurring: kind == .recurring,
            frequency: kind == .recurring ? frequency : nil,
            targetDate: resolvedTargetDate
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Type", selection: $kind) {
                        ForEach(TemptationKind.allCases) { kind in
                            Text(kind.rawValue).tag(kind)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("The Temptation") {
                    TextField("What are you tempted to buy?", text: $itemName)
                    TextField(
                        kind == .recurring ? "How much per period?" : "How much does it cost?",
                        value: $amount,
                        format: .currency(code: Locale.current.currency?.identifier ?? "USD")
                    )
                    .keyboardType(.decimalPad)

                    if kind == .recurring {
                        Picker("Frequency", selection: $frequency) {
                            ForEach(RecurrenceFrequency.allCases) { frequency in
                                Text(frequency.label).tag(frequency)
                            }
                        }
                    }
                }

                Section("When do you want to see this money again?") {
                    Picker("Horizon Mode", selection: $horizonMode) {
                        ForEach(HorizonMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)

                    if horizonMode == .preset {
                        Picker("Time Horizon", selection: $presetHorizon) {
                            ForEach(TimeHorizon.allCases) { horizon in
                                Text(horizon.label).tag(horizon)
                            }
                        }
                        .pickerStyle(.segmented)
                    } else {
                        DatePicker(
                            "Target Date",
                            selection: $customTargetDate,
                            in: Date.now.addingTimeInterval(86_400)...,
                            displayedComponents: .date
                        )
                    }
                }

                Section {
                    Button {
                        showingRealityCheck = true
                    } label: {
                        Label("See the Math", systemImage: "function")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!isValid)
                }
            }
            .navigationTitle("Log a Temptation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .navigationDestination(isPresented: $showingRealityCheck) {
                RealityCheckView(input: temptationInput, onFinished: { dismiss() })
            }
        }
    }
}

#Preview {
    TemptationEntryView()
        .modelContainer(for: SavedPurchase.self, inMemory: true)
}
