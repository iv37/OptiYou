import SwiftUI

struct PremiumView: View {
    @EnvironmentObject private var appModel: AppModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 14) {
                        ChipView(text: "Premium access", tint: AppTheme.primary)
                        Text("Unlock deeper tracking and more personalized optimization layers.")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                            .foregroundStyle(AppTheme.foreground)
                        Text("Payments are not wired in, but the app already has plan gating, locked experiences, and a path to billing integration.")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.muted)
                    }
                    .padding(22)
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [AppTheme.surfaceStrong, AppTheme.background],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .stroke(AppTheme.primary.opacity(0.5), lineWidth: 1)
                            )
                            .overlay(alignment: .topTrailing) {
                                Circle()
                                    .fill(AppTheme.primary.opacity(0.18))
                                    .frame(width: 150, height: 150)
                                    .blur(radius: 24)
                                    .offset(x: 36, y: -26)
                            }
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
