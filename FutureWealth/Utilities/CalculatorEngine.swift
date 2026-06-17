import Foundation

/// Compound interest math: FV = PV * (1 + r)^n
enum CalculatorEngine {
    static func yearsBetween(from start: Date, to end: Date) -> Double {
        let days = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
        return max(Double(days) / 365.25, 1.0 / 365.25)
    }

    static func calculateFutureValue(presentValue: Double, rate: Double, years: Double) -> Double {
        presentValue * pow(1 + rate, years)
    }

    static func futureValue(of presentValue: Double, in asset: AssetBenchmark, years: Double) -> Double {
        calculateFutureValue(presentValue: presentValue, rate: asset.annualRate, years: years)
    }

    /// FV of ordinary annuity: PMT × [((1 + r)^n − 1) / r]
    static func futureValueOfAnnuity(
        payment: Double,
        annualRate: Double,
        years: Double,
        periodsPerYear: Int
    ) -> Double {
        let periods = max(1, Int((years * Double(periodsPerYear)).rounded()))
        let ratePerPeriod = pow(1 + annualRate, 1.0 / Double(periodsPerYear)) - 1
        guard ratePerPeriod > 0 else { return payment * Double(periods) }
        return payment * (pow(1 + ratePerPeriod, Double(periods)) - 1) / ratePerPeriod
    }

    static func projectedValue(
        amount: Double,
        isRecurring: Bool,
        frequency: RecurrenceFrequency?,
        in asset: AssetBenchmark,
        years: Double
    ) -> Double {
        if isRecurring, let frequency {
            return futureValueOfAnnuity(
                payment: amount,
                annualRate: asset.annualRate,
                years: years,
                periodsPerYear: frequency.periodsPerYear
            )
        }
        return futureValue(of: amount, in: asset, years: years)
    }

    static func projectedValue(for input: TemptationInput, in asset: AssetBenchmark) -> Double {
        let years = yearsBetween(from: .now, to: input.targetDate)
        return projectedValue(
            amount: input.amount,
            isRecurring: input.isRecurring,
            frequency: input.frequency,
            in: asset,
            years: years
        )
    }

    static func projectedValue(for purchase: SavedPurchase, in asset: AssetBenchmark = .sp500) -> Double {
        projectedValue(
            amount: purchase.cost,
            isRecurring: purchase.isRecurring,
            frequency: purchase.recurrenceFrequency,
            in: asset,
            years: purchase.projectionYears()
        )
    }
}
