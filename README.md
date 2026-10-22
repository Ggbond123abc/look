# 看看时间（LookTime）

一款面向 iPhone 的本机使用时长记录工具。

## 能做什么

- 经用户授权后，展示微信、抖音、小红书等所选 App 的今日使用时长。
- 手动记录“微信指定聊天 / 朋友圈 / 抖音首页 / 小红书首页”的停留时间。
- 所有手动记录仅保存在本机，不需要服务器。

## iOS 的必要限制

iOS 沙盒不允许第三方 App 读取另一个 App 当前展示的页面、聊天对象或界面层级。因此，“微信某个人聊天页”“朋友圈”“抖音首页”“小红书首页”不能自动识别。本项目对 App 级时长使用 Apple Screen Time API 自动统计，对具体页面提供明确的手动计时，不使用截屏、辅助功能窃取或其他违规方案。

## 运行

要求：macOS、Xcode 15+、iOS 16+、Apple Developer 账号、[XcodeGen](https://github.com/yonaskolb/XcodeGen)。

1. 安装 XcodeGen：`brew install xcodegen`。
2. 在仓库根目录运行 `xcodegen generate`。
3. 用 Xcode 打开 `LookTime.xcodeproj`。
4. 为 `LookTime` 和 `LookTimeReport` 两个 Target 选择你的开发团队。
5. 把两个 entitlements 文件中的 App Group 改成你的唯一标识，并在 Signing & Capabilities 中为两个 Target 启用同一个 App Group。
6. 为两个 Target 添加 **Family Controls** capability。
7. 使用真机运行；Screen Time API 在模拟器中无法完整验证。

## 发布说明

开发调试可在 Xcode 中配置 Family Controls。发布 TestFlight/App Store 前，Apple Developer Account Holder 必须为主 App 和 Device Activity Report 扩展分别申请 Family Controls distribution entitlement。苹果审核通过前无法正式分发此能力。

## 技术结构

- `LookTime/`：SwiftUI 主应用、授权、App 选择器和手动计时。
- `LookTimeReport/`：Device Activity Report Extension，汇总所选 App 的当天使用时间。
- `project.yml`：XcodeGen 工程定义。

