import DeviceActivity
import FamilyControls
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var model: AppModel
    private let reportContext = DeviceActivityReport.Context("LookTime.Today")

    var body: some View {
        NavigationStack {
            List {
                authorizationSection
                appUsageSection
                manualSection
                privacySection
            }
            .navigationTitle("看看时间")
            .familyActivityPicker(isPresented: $model.isPickerPresented, selection: $model.selection)
            .alert("提示", isPresented: Binding(
                get: { model.errorMessage != nil },
                set: { if !$0 { model.errorMessage = nil } }
            )) { Button("好") {} } message: { Text(model.errorMessage ?? "") }
        }
    }

    private var authorizationSection: some View {
        Section("第一步") {
            Button(model.isAuthorized ? "已授权屏幕使用时间" : "授权屏幕使用时间") {
                Task { await model.requestAuthorization() }
            }
            .disabled(model.isAuthorized)
            Button("选择微信、抖音和小红书") { model.isPickerPresented = true }
                .disabled(!model.isAuthorized)
        }
    }

    private var appUsageSection: some View {
        Section("今日 App 使用时长") {
            if model.selection.applicationTokens.isEmpty {
                ContentUnavailableView("尚未选择 App", systemImage: "hourglass", description: Text("授权后从系统列表中选择需要统计的 App。"))
                    .frame(height: 180)
            } else {
                DeviceActivityReport(reportContext, filter: todayFilter)
                    .frame(minHeight: 220)
            }
        }
    }

    private var manualSection: some View {
        Section("具体页面（手动计时）") {
            Text("iOS 不允许读取其他 App 内正在显示的聊天或页面。进入目标页面时点“开始”，离开时再点一次。")
                .font(.footnote).foregroundStyle(.secondary)
            ForEach(ManualCategory.allCases) { category in
                ManualTimerRow(category: category)
                    .environmentObject(model.sessions)
            }
        }
    }

    private var privacySection: some View {
        Section("隐私") {
            Label("数据只保存在本机，不上传服务器", systemImage: "lock.shield.fill")
        }
    }

    private var todayFilter: DeviceActivityFilter {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: .now)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? .now
        return DeviceActivityFilter(
            segment: .daily(during: DateInterval(start: start, end: end)),
            users: .all,
            devices: .all,
            applications: model.selection.applicationTokens,
            categories: model.selection.categoryTokens,
            webDomains: model.selection.webDomainTokens
        )
    }
}

