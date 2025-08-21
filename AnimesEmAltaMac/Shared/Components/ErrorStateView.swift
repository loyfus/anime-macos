import SwiftUI

struct ErrorStateView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
                .accessibilityLabel("Erro")
            
            Text("Ops! Algo deu errado")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: onRetry) {
                Label("Tentar novamente", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
            .keyboardShortcut("r", modifiers: .command)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}