import Foundation

@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var sessions: [ManualSession] = []
    @Published private(set) var activeCategory: ManualCategory?
    @Published private(set) var startedAt: Date?

    private let storageKey = "manualSessions"

    init() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let saved = try? JSONDecoder().decode([ManualSession].self, from: data)
        else { return }
        sessions = saved
    }

    func toggle(_ category: ManualCategory, now: Date = .now) {
        if activeCategory == category { stop(now: now) }
        else {
            if activeCategory != nil { stop(now: now) }
            activeCategory = category
            startedAt = now
        }
    }

    func stop(now: Date = .now) {
        guard let category = activeCategory, let start = startedAt, now >= start else { return }
        sessions.insert(ManualSession(id: UUID(), category: category, startedAt: start, endedAt: now), at: 0)
        activeCategory = nil
        startedAt = nil
        persist()
    }

    func total(for category: ManualCategory, on date: Date = .now) -> TimeInterval {
        sessions.filter { $0.category == category && Calendar.current.isDate($0.startedAt, inSameDayAs: date) }
            .reduce(0) { $0 + $1.duration }
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(sessions) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}

