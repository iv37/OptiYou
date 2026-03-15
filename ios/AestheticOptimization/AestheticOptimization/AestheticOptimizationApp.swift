import SwiftUI

@main
struct AestheticOptimizationApp: App {
    @StateObject private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            RootContainerView()
                .environmentObject(appModel)
        }
    }
}
