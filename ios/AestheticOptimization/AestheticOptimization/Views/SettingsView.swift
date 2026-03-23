import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appModel: AppModel
    @State private var remindersEnabled = true
    @State private var saveComparisons = true
    @State private var showLockedModules = true
    @State private var conservativeLanguage = true
    @State private var showingProfileEditor = false

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
                    settingRow(title: "Current user", value: appModel.currentUserEmail)
                    Text("Update age, measurements, goals, and lifestyle inputs from one place.")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.muted)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(appModel.currentProfile == nil ? "Complete profile" : "Edit profile and stats") {
                        showingProfileEditor = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
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

                Button("Log out") {
                    Task {
                        await appModel.logout()
                    }
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 28)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingProfileEditor) {
            NavigationStack {
                ProfileSetupView(mode: .editing, profile: appModel.currentProfile)
                    .environmentObject(appModel)
                    .background(AppTheme.background.ignoresSafeArea())
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Close") {
                                showingProfileEditor = false
                            }
                            .foregroundStyle(AppTheme.foreground)
                        }
                    }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
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
        .insetSurface()
    }

}
