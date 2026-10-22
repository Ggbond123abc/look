import Foundation

struct ManualSession: Identifiable, Codable, Equatable {
    let id: UUID
    let category: ManualCategory
    let startedAt: Date
    let endedAt: Date

    var duration: TimeInterval { endedAt.timeIntervalSince(startedAt) }
}

enum ManualCategory: String, CaseIterable, Codable, Identifiable {
    case wechatChat = "微信指定聊天"
    case wechatMoments = "微信朋友圈"
    case douyinHome = "抖音首页"
    case xiaohongshuHome = "小红书首页"

    var id: String { rawValue }
    var symbol: String {
        switch self {
        case .wechatChat: return "message.fill"
        case .wechatMoments: return "circle.grid.2x2.fill"
        case .douyinHome: return "music.note"
        case .xiaohongshuHome: return "book.fill"
        }
    }
}

