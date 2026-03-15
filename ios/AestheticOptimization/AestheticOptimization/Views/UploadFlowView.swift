import SwiftUI

struct UploadFlowView: View {
    @EnvironmentObject private var appModel: AppModel
    @State private var isProcessing = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                SectionHeaderView(
                    eyebrow: "Photo upload flow",
                    title: "Upload a new scan set with consistent lighting and angles.",
                    detail: "The native MVP saves a front face, side face, skin close-up, and hairline capture. Cloud storage can replace the mock layer later."
                )

                ForEach(appModel.scans) { scan in
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(AppTheme.accent.opacity(0.15))
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
                            ChipView(text: scan.status, tint: scan.status == "Processing" ? AppTheme.accent : AppTheme.success)
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

                Button(isProcessing ? "Processing..." : "Process scan set") {
                    isProcessing = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                        appModel.selectedTab = .dashboard
                        isProcessing = false
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(isProcessing)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 28)
        }
        .navigationTitle("New scan")
        .navigationBarTitleDisplayMode(.inline)
    }
}
