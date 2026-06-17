import SwiftUI

/// Phase 2 stub: will host Plaid Link once the backend exists.
struct PlaidConnectView: View {
    @State private var isConnected = false

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: isConnected ? "checkmark.seal.fill" : "building.columns.circle")
                .font(.system(size: 72))
                .foregroundStyle(isConnected ? .green : .accentColor)

            Text(isConnected
                 ? "Bank connected (mock). Transactions will sync automatically."
                 : "Connect your bank to automatically detect impulse purchases.")
                .font(.title3)
                .multilineTextAlignment(.center)

            Button {
                // TODO(Phase 2): launch Plaid Link with a link_token from the backend.
                isConnected.toggle()
            } label: {
                Text(isConnected ? "Disconnect" : "Link Bank Account")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Connect Bank")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PlaidConnectView()
    }
}
