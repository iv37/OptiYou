import SwiftUI

enum AppTheme {
    static let background = Color(red: 0.96, green: 0.93, blue: 0.89)
    static let surface = Color.white.opacity(0.72)
    static let surfaceStrong = Color.white.opacity(0.90)
    static let foreground = Color(red: 0.10, green: 0.08, blue: 0.06)
    static let muted = Color(red: 0.43, green: 0.40, blue: 0.36)
    static let primary = Color(red: 0.11, green: 0.30, blue: 0.26)
    static let accent = Color(red: 0.78, green: 0.65, blue: 0.43)
    static let success = Color(red: 0.14, green: 0.36, blue: 0.25)
    static let danger = Color(red: 0.61, green: 0.30, blue: 0.25)
}

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.98, green: 0.96, blue: 0.92),
                AppTheme.background
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .overlay(alignment: .topTrailing) {
            Circle()
                .fill(AppTheme.accent.opacity(0.14))
                .frame(width: 220, height: 220)
                .blur(radius: 30)
                .offset(x: 70, y: -90)
        }
        .ignoresSafeArea()
    }
}

struct GlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.white.opacity(0.55), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 18, y: 10)
    }
}

extension View {
    func glassCard() -> some View {
        modifier(GlassCardModifier())
    }
}
