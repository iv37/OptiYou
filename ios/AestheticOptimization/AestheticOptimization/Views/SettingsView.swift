import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appModel: AppModel
    @State private var remindersEnabled = true
    @State private var saveComparisons = true
    @State private var showLockedModules = true
    @State private var conservativeLanguage = true

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                SectionHeaderView(
                    eyebrow: "Settings",
                    title: "Profile, privacy, and preferences.",
                    detail: "This native page is structured for real account management and safe defaults."
                )

                VStack(alignment: .leading, spacing: 14) {
                    Text("Profile")
                        .font(.headline)
                    settingRow(title: "Name", value: appModel.profile.fullName)
                    settingRow(title: "Goals", value: appModel.profile.goals.joined(separator: ", "))
                    settingRow(title: "Plan", value: appModel.profile.plan.rawValue)
                }
                .padding(20)
                .glassCard()

                VStack(alignment: .leading, spacing: 14) {
                    Text("Preferences")
                        .font(.headline)
                    Toggle("Weekly progress reminders", isOn: $remindersEnabled)
                    Toggle("Save comparison photos", isOn: $saveComparisons)
                    Toggle("Show premium locked modules", isOn: $showLockedModules)
                    Toggle("Keep recommendation language conservative", isOn: $conservativeLanguage)
                }
                .toggleStyle(SwitchToggleStyle(tint: AppTheme.primary))
                .padding(20)
                .glassCard()

                Button("Open premium") {
                    appModel.showingPremium = true
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 28)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func settingRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundStyle(AppTheme.muted)
            Text(value)
                .font(.body)
                .foregroundStyle(AppTheme.foreground)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.white.opacity(0.62), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
