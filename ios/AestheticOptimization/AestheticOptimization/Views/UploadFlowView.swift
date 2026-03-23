import SwiftUI

struct UploadFlowView: View {
    @EnvironmentObject private var appModel: AppModel
    @State private var isProcessing = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                SectionHeaderView(
                    eyebrow: "Initial assessment",
                    title: appModel.hasCompletedInitialAssessment ? "Upload a new scan set with consistent lighting and angles." : "Start with your baseline photos and profile details.",
                    detail: appModel.hasCompletedInitialAssessment ? "The native MVP saves a front face, side face, skin close-up, and hairline capture. Cloud storage can replace the mock layer later." : "We do not show scores before the first assessment. Complete your intake once, then the dashboard can evaluate and track progress over time."
                )

                if !appModel.hasCompletedInitialAssessment {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("What gets unlocked after the first evaluation")
                            .font(.headline)
                            .foregroundStyle(AppTheme.foreground)
                        Text("Dashboard metrics, module summaries, progress charts, and your recommendation roadmap stay hidden until the user has provided the first real input set.")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.muted)
                    }
                    .padding(18)
                    .glassCard()
                }

                ForEach(appModel.scans) { scan in
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(AppTheme.surfaceInset)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                                        .stroke(AppTheme.border, lineWidth: 1)
                                )
                                .frame(width: 72, height: 72)
                            Image(systemName: scan.imageName)
                                .font(.title2)
                                .foregroundStyle(AppTheme.primary)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text(scan.title)
                                .font(.headline)
                                .foregroundStyle(AppTheme.foreground)
                            Text(scan.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.muted)
                            ChipView(text: scan.status, tint: scan.status == "Needed" ? AppTheme.primary : (scan.status == "Processing" ? AppTheme.accent : AppTheme.success))
                        }

                        Spacer()
                    }
                    .padding(16)
                    .glassCard()
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Capture guidance")
                        .font(.headline)
                        .foregroundStyle(AppTheme.foreground)
                    Text("Keep the same mirror distance and overhead lighting each time. Progress comparisons only become useful when input conditions stay stable.")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.muted)
                }
                .padding(18)
                .glassCard()

                Button(isProcessing ? "Processing..." : (appModel.hasCompletedInitialAssessment ? "Process new scan set" : "Complete first evaluation")) {
                    isProcessing = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                        appModel.completeAssessment()
                        isProcessing = false
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(isProcessing)

                if !appModel.hasCompletedInitialAssessment && appModel.isUsingDevBypass {
                    Button("Dev: skip uploads") {
                        appModel.completeAssessment()
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 28)
        }
        .navigationTitle("New scan")
        .navigationBarTitleDisplayMode(.inline)
    }
}
