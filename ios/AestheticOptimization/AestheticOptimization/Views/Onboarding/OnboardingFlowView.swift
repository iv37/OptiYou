import SwiftUI

struct OnboardingFlowView: View {
    @EnvironmentObject private var appModel: AppModel
    @State private var page = 0

    private let pages: [(title: String, detail: String)] = [
        ("Supportive optimization", "Track skincare, hair, body composition, and lifestyle without harsh scoring or shame."),
        ("Photo-based progress", "Save front face, side face, skin, and hairline scans under consistent lighting."),
        ("Actionable routines", "Get realistic daily and weekly recommendations shaped around consistency and presentation.")
    ]

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 12)

            VStack(alignment: .leading, spacing: 18) {
                ChipView(text: "Native iPhone app", tint: AppTheme.primary)
                Text("AI Personal Aesthetic Optimization")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.foreground)
                Text("A premium progress platform focused on routines, presentation, and steady improvement.")
                    .font(.headline)
                    .foregroundStyle(AppTheme.muted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            TabView(selection: $page) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    VStack(alignment: .leading, spacing: 14) {
                        Text("0\(index + 1)")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppTheme.primary)
                        Text(page.title)
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                            .foregroundStyle(AppTheme.foreground)
                        Text(page.detail)
                            .font(.body)
                            .foregroundStyle(AppTheme.muted)
                    }
                    .padding(28)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .glassCard()
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 360)

            VStack(spacing: 14) {
                Button("Start assessment") {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
                        appModel.hasCompletedOnboarding = true
                    }
                }
                .buttonStyle(PrimaryButtonStyle())

                Button("Preview demo profile") {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
                        appModel.hasCompletedOnboarding = true
                        appModel.selectedTab = .dashboard
                    }
                }
                .buttonStyle(SecondaryButtonStyle())
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
        .padding(.bottom, 28)
    }
}
