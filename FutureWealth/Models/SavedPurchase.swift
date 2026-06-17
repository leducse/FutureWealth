import Foundation
import SwiftData

/// A purchase the user resisted, persisted locally with SwiftData.
@Model
final class SavedPurchase {
    var id: UUID
    var itemName: String
    var cost: Double
    var dateSaved: Date
    var horizonYears: Int
    var assetChoice: String?
    var isRecurring: Bool
    var recurrenceFrequencyRaw: String?
    var targetDate: Date?

    init(
        id: UUID = UUID(),
        itemName: String,
        cost: Double,
        dateSaved: Date = .now,
        horizonYears: Int,
        assetChoice: String? = nil,
        isRecurring: Bool = false,
        recurrenceFrequencyRaw: String? = nil,
        targetDate: Date? = nil
    ) {
        self.id = id
        self.itemName = itemName
        self.cost = cost
        self.dateSaved = dateSaved
        self.horizonYears = horizonYears
        self.assetChoice = assetChoice
        self.isRecurring = isRecurring
        self.recurrenceFrequencyRaw = recurrenceFrequencyRaw
        self.targetDate = targetDate
    }

    var recurrenceFrequency: RecurrenceFrequency? {
        guard let recurrenceFrequencyRaw else { return nil }
        return RecurrenceFrequency(rawValue: recurrenceFrequencyRaw)
    }

    func projectionYears() -> Double {
        if let targetDate {
            return CalculatorEngine.yearsBetween(from: dateSaved, to: targetDate)
        }
        return Double(horizonYears)
    }

    var amountLabel: String {
        if isRecurring, let frequency = recurrenceFrequency {
            return "\(cost.asCurrency)/\(frequency.shortLabel)"
        }
        return cost.asCurrency
    }

    var horizonDisplayLabel: String {
        if let targetDate {
            return "by \(targetDate.formatted(date: .abbreviated, time: .omitted))"
        }
        return "in \(horizonYears) yrs"
    }

    var totalContributedLabel: String? {
        guard let total = CalculatorEngine.totalContributed(for: self) else { return nil }
        return total.asCurrency
    }
}
