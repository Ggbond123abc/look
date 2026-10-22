import FamilyControls
import Foundation

@MainActor
final class AppModel: ObservableObject {
    @Published var selection: FamilyActivitySelection {
        didSet { SelectionStore.save(selection) }
    }
    @Published var isPickerPresented = false
    @Published var errorMessage: String?
    let sessions = SessionStore()

    init() { selection = SelectionStore.load() }

    var isAuthorized: Bool { AuthorizationCenter.shared.authorizationStatus == .approved }

    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            objectWillChange.send()
        } catch {
            errorMessage = "屏幕使用时间授权失败：\(error.localizedDescription)"
        }
    }
}

