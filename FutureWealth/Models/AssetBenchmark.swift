import Foundation

/// A benchmark asset class with a fixed assumed annual return.
struct AssetBenchmark: Identifiable, Hashable {
    let id: String
    let name: String
    let annualRate: Double
    let systemImage: String

    static let highYieldSavings = AssetBenchmark(
        id: "hys",
        name: "High-Yield Savings",
        annualRate: 0.04,
        systemImage: "building.columns"
    )

    static let sp500 = AssetBenchmark(
        id: "sp500",
        name: "S&P 500",
        annualRate: 0.10,
        systemImage: "chart.pie.fill"
    )

    static let blueChipTech = AssetBenchmark(
        id: "tech",
        name: "Blue Chip Tech",
        annualRate: 0.14,
        systemImage: "desktopcomputer"
    )

    static let all: [AssetBenchmark] = [.highYieldSavings, .sp500, .blueChipTech]
}

/// The time horizons offered when logging a temptation.
enum TimeHorizon: Int, CaseIterable, Identifiable {
    case nextYear = 1
    case fiveYears = 5
    case tenYears = 10
    case collegeFund = 18

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .nextYear: return "Next Year"
        case .fiveYears: return "5 Years"
        case .tenYears: return "10 Years"
        case .collegeFund: return "College Fund"
        }
    }

    func targetDate(from start: Date = .now) -> Date {
        Calendar.current.date(byAdding: .year, value: rawValue, to: start) ?? start
    }
}

/// How often a recurring temptation repeats.
enum RecurrenceFrequency: String, CaseIterable, Identifiable {
    case monthly
    case yearly

    var id: String { rawValue }

    var label: String {
        switch self {
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        }
    }

    var shortLabel: String {
        switch self {
        case .monthly: return "mo"
        case .yearly: return "yr"
        }
    }

    var periodsPerYear: Int {
        switch self {
        case .monthly: return 12
        case .yearly: return 1
        }
    }
}
