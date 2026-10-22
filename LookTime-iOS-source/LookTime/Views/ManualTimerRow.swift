import SwiftUI

struct ManualTimerRow: View {
    @EnvironmentObject private var store: SessionStore
    let category: ManualCategory

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: category.symbol).frame(width: 26).foregroundStyle(.blue)
            VStack(alignment: .leading) {
                Text(category.rawValue)
                TimelineView(.periodic(from: .now, by: 1)) { context in
                    Text(durationText(at: context.date)).font(.caption).foregroundStyle(.secondary)
                }
            }
            Spacer()
            Button(store.activeCategory == category ? "停止" : "开始") { store.toggle(category) }
                .buttonStyle(.borderedProminent)
                .tint(store.activeCategory == category ? .red : .blue)
        }
    }

    private func durationText(at date: Date) -> String {
        var value = store.total(for: category)
        if store.activeCategory == category, let start = store.startedAt { value += date.timeIntervalSince(start) }
        return "今天 \(Duration.seconds(value).formatted(.time(pattern: .hourMinuteSecond)))"
    }
}

