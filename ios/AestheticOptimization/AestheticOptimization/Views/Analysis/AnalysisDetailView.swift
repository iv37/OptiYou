import SwiftUI

struct AnalysisDetailView: View {
    @EnvironmentObject private var appModel: AppModel
    let module: AnalysisModule

    var detail: AnalysisDetailContent {
        appModel.detailContent(for: module)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 14) {
                    ChipView(text: module.confidence.rawValue, tint: AppTheme.primary)
                    Text(module.title)
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .foregroundStyle(AppTheme.foreground)
                    Text(detail.headline)
                        .font(.title3.weight(.medium))
                        .foregroundStyle(AppTheme.foreground)
                    Text(detail.explanation)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.muted)
                }
                .padding(20)
                .glassCard()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Key observations")
                        .font(.headline)
                    ForEach(detail.observations, id: \.self) { item in
                        Text(item)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.muted)
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .insetSurface()
                    }
                }
                .padding(20)
                .glassCard()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Recommended routine")
                        .font(.headline)
                    ForEach(detail.routines) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.timing.uppercased())
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(AppTheme.primary)
                            Text(item.title)
                                .font(.headline)
                            Text(item.detail)
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.muted)
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .insetSurface()
                    }
                }
                .padding(20)
                .glassCard()

                if detail.locked {
                    Button("Unlock advanced comparisons") {
                        appModel.showingPremium = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 28)
        }
        .navigationTitle(module.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
