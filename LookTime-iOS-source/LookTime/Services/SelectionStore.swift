import FamilyControls
import Foundation

enum SelectionStore {
    private static let suite = "group.com.ggbond.looktime"
    private static let key = "familyActivitySelection"

    static func save(_ selection: FamilyActivitySelection) {
        guard let data = try? PropertyListEncoder().encode(selection) else { return }
        UserDefaults(suiteName: suite)?.set(data, forKey: key)
    }

    static func load() -> FamilyActivitySelection {
        guard let data = UserDefaults(suiteName: suite)?.data(forKey: key),
              let value = try? PropertyListDecoder().decode(FamilyActivitySelection.self, from: data)
        else { return FamilyActivitySelection() }
        return value
    }
}

