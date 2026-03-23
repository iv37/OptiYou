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
        .toolbarBackground(AppTheme.backgroundElevated, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .sheet(isPresented: $appModel.showingPremium) {
            PremiumView()
        }
        .onAppear(perform: configureChrome)
    }

    private func configureChrome() {
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor(AppTheme.backgroundElevated)
        tabAppearance.shadowColor = UIColor(AppTheme.border)
        tabAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppTheme.primary)
        tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(AppTheme.primary)]
        tabAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppTheme.muted)
        tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(AppTheme.muted)]
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance

        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(AppTheme.background)
        navAppearance.shadowColor = UIColor(AppTheme.border)
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor(AppTheme.foreground)]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(AppTheme.foreground)]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
    }
}
