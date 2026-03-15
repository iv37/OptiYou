import SwiftUI

struct PremiumView: View {
    @EnvironmentObject private var appModel: AppModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 14) {
                        ChipView(text: "Premium-ready architecture", tint: .white)
                        Text("Unlock deeper tracking and more personalized optimization layers.")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Payments are not wired in, but the app already has plan gating, locked experiences, and a path to billing integration.")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.72))
                    }
                    .padding(22)
                    .background(
                        LinearGradient(colors: [Color.black.opacity(0.88), AppTheme.primary.opacity(0.94)], startPoint: .topLeading, endPoint: .bottomTrailing),
                        in: RoundedRectangle(cornerRadius: 30, style: .continuous)
                    )

                    ForEach(appModel.premiumFeatures) { feature in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(feature.title)
                                .font(.headline)
                                .foregroundStyle(AppTheme.foreground)
                            Text(feature.detail)
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.muted)
                        }
                        .padding(18)
                        .glassCard()
                    }

                    Button("Join premium waitlist") {}
                        .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 28)
            }
            .background(AppBackground())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
