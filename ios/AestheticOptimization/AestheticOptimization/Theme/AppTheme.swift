import SwiftUI

enum AppTheme {
    static let background = Color(hex: "#0B0C10")
    static let backgroundElevated = Color(hex: "#0F1116")
    static let surface = Color(hex: "#111317")
    static let surfaceStrong = Color(hex: "#171A20")
    static let surfaceInset = Color(hex: "#15181D")
    static let border = Color(hex: "#2A2E35")
    static let foreground = Color(hex: "#F5F5F5")
    static let muted = Color(hex: "#A1A1AA")
    static let primary = Color(hex: "#4C1D95")
    static let primaryHover = Color(hex: "#3B0764")
    static let accent = Color(hex: "#4C1D95")
    static let success = Color(hex: "#059669")
    static let danger = Color(hex: "#8F4B4B")
    static let shadow = Color.black.opacity(0.34)
}

struct AppBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    AppTheme.backgroundElevated,
                    AppTheme.background
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            RadialGradient(
                colors: [
                    AppTheme.primary.opacity(0.10),
                    Color.clear
                ],
                center: .topTrailing,
                startRadius: 10,
                endRadius: 280
            )
            .offset(x: 60, y: -120)

            LinearGradient(
                colors: [
                    Color.white.opacity(0.015),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .center
            )
        }
        .ignoresSafeArea()
    }
}

struct GlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(AppTheme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
            .shadow(color: AppTheme.shadow, radius: 22, y: 14)
    }
}

struct InsetSurfaceModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppTheme.surfaceInset)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(AppTheme.border.opacity(0.95), lineWidth: 1)
            )
    }
}

struct LuxuryInputModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppTheme.surfaceInset)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
            .foregroundStyle(AppTheme.foreground)
    }
}

extension View {
    func glassCard() -> some View {
        modifier(GlassCardModifier())
    }

    func insetSurface() -> some View {
        modifier(InsetSurfaceModifier())
    }

    func luxuryInput() -> some View {
        modifier(LuxuryInputModifier())
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
