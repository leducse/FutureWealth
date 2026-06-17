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

    var paymentPeriodCount: Int? {
        guard isRecurring, let frequency else { return nil }
        let years = CalculatorEngine.yearsBetween(from: .now, to: targetDate)
        return CalculatorEngine.paymentPeriodCount(
            years: years,
            periodsPerYear: frequency.periodsPerYear
        )
    }

    var paymentPeriodLabel: String? {
        guard let count = paymentPeriodCount, let frequency else { return nil }
        switch frequency {
        case .monthly:
            return "\(count) month\(count == 1 ? "" : "s")"
        case .yearly:
            return "\(count) year\(count == 1 ? "" : "s")"
        }
    }

    var totalContributedLabel: String? {
        guard let total = CalculatorEngine.totalContributed(for: self) else { return nil }
        return total.asCurrency
    }
}
