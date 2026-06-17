import Foundation

/// In-memory payload passed from entry → reality check → save.
struct TemptationInput {
    let itemName: String
    let amount: Double
    let isRecurring: Bool
    let frequency: RecurrenceFrequency?
    let targetDate: Date

    var roundedHorizonYears: Int {
        max(1, Int(CalculatorEngine.yearsBetween(from: .now, to: targetDate).rounded()))
    }

    var amountLabel: String {
        if isRecurring, let frequency {
            return "\(amount.asCurrency)/\(frequency.shortLabel)"
        }
        return amount.asCurrency
    }

    var horizonLabel: String {
        let years = CalculatorEngine.yearsBetween(from: .now, to: targetDate)
        if years < 1.5 {
            let months = max(1, Int((years * 12).rounded()))
            return "\(months) month\(months == 1 ? "" : "s")"
        }
        let rounded = max(1, Int(years.rounded()))
        return "\(rounded) year\(rounded == 1 ? "" : "s")"
    }

    var targetDateLabel: String {
        targetDate.formatted(date: .abbreviated, time: .omitted)
    }
}
