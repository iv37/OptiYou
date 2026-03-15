import SwiftUI

struct RootContainerView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        ZStack {
            AppBackground()

            if appModel.hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingFlowView()
            }
        }
        .preferredColorScheme(.light)
    }
}
