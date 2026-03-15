import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        TabView(selection: $appModel.selectedTab) {
            NavigationStack {
                DashboardView()
            }
            .tabItem {
                Label(AppTab.dashboard.title, systemImage: AppTab.dashboard.systemImage)
            }
            .tag(AppTab.dashboard)

            NavigationStack {
                UploadFlowView()
            }
            .tabItem {
                Label(AppTab.upload.title, systemImage: AppTab.upload.systemImage)
            }
            .tag(AppTab.upload)

            NavigationStack {
                ProgressViewScreen()
            }
            .tabItem {
                Label(AppTab.progress.title, systemImage: AppTab.progress.systemImage)
            }
            .tag(AppTab.progress)

            NavigationStack {
                RoadmapView()
            }
            .tabItem {
                Label(AppTab.plan.title, systemImage: AppTab.plan.systemImage)
            }
            .tag(AppTab.plan)

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label(AppTab.settings.title, systemImage: AppTab.settings.systemImage)
            }
            .tag(AppTab.settings)
        }
        .tint(AppTheme.primary)
        .sheet(isPresented: $appModel.showingPremium) {
            PremiumView()
        }
    }
}
