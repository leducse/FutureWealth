import Foundation

enum FormattingHelpers {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()

    static func currency(_ value: Double) -> String {
        currencyFormatter.string(from: NSNumber(value: value)) ?? "$\(String(format: "%.2f", value))"
    }
}

extension Double {
    var asCurrency: String {
        FormattingHelpers.currency(self)
    }
}
