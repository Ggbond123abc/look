import DeviceActivity
import FamilyControls
import ManagedSettings
import SwiftUI

struct AppUsage: Identifiable {
    let id = UUID()
    let token: ApplicationToken
    let duration: TimeInterval
}

struct TodayConfiguration {
    let total: TimeInterval
    let apps: [AppUsage]
}

struct TodayReport: DeviceActivityReportScene {
    let context = DeviceActivityReport.Context("LookTime.Today")
    let content: (TodayConfiguration) -> TodayReportView

    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> TodayConfiguration {
        var totals: [ApplicationToken: TimeInterval] = [:]
        for await item in data {
            for await segment in item.activitySegments {
                for await category in segment.categories {
                    for await application in category.applications {
                        guard let token = application.application.token else { continue }
                        totals[token, default: 0] += application.totalActivityDuration
                    }
                }
            }
        }
        let apps = totals.map { AppUsage(token: $0.key, duration: $0.value) }.sorted { $0.duration > $1.duration }
        return TodayConfiguration(total: apps.reduce(0) { $0 + $1.duration }, apps: apps)
    }
}

struct TodayReportView: View {
    let configuration: TodayConfiguration

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("合计 \(formatted(configuration.total))").font(.headline)
            if configuration.apps.isEmpty {
                Text("今天还没有记录，系统数据有时会延迟几分钟。")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            ForEach(configuration.apps) { app in
                HStack {
                    Label(app.token).labelStyle(.titleAndIcon)
                    Spacer()
                    Text(formatted(app.duration)).monospacedDigit()
                }
            }
        }.padding(.vertical, 8)
    }

    private func formatted(_ seconds: TimeInterval) -> String {
        Duration.seconds(seconds).formatted(.time(pattern: .hourMinute))
    }
}

