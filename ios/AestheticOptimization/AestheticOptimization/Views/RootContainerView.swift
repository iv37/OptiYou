import SwiftUI

struct RootContainerView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        ZStack {
            AppBackground()

            switch appModel.authState {
            case .loading:
                ProgressView()
                    .controlSize(.large)
            case .unauthenticated:
                AuthView()
            case .needsOnboarding:
                ProfileSetupView()
            case .authenticated:
                MainTabView()
            }
        }
        .preferredColorScheme(.dark)
        .task {
            await appModel.restoreSessionIfNeeded()
        }
    }
}
