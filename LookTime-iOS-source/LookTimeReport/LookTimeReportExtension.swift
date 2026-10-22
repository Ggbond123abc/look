import DeviceActivity
import SwiftUI

@main
struct LookTimeReportExtension: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        TodayReport { configuration in TodayReportView(configuration: configuration) }
    }
}

