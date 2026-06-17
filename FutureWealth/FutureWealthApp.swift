import SwiftUI
import SwiftData

@main
struct FutureWealthApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView()
        }
        .modelContainer(for: SavedPurchase.self)
    }
}
