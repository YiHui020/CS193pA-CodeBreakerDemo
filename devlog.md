# 开发日志 — CodeBreaker

## 2026-06-05

### 文件变更

- **CodeBreaker/CodeBreakerModel/CodeBreaker.swift** *(修改)*: 新增 `lastPlayedTime` 属性（Date?），init 时置 nil，进入游戏时更新
- **CodeBreaker/UI/CodeBreakerView.swift** *(修改)*: onAppear 设置 `game.lastPlayedTime = Date.now`
- **CodeBreaker/UI/GameChooser.swift** *(修改)*: 新增 SortPicker（Name/Recent 分段选择器）+ searchable 搜索栏
- **CodeBreaker/UI/GameList.swift** *(修改)*: init 重构为动态 @Query（sort + predicate），新增 SortOption 枚举（name/recent）

### 变更摘要

GameList 新增排序与搜索功能：用户可按游戏名称或最近游玩时间排序，并通过搜索栏过滤游戏列表。模型层同步添加 `lastPlayedTime` 属性以支持"最近"排序依据，进入游戏画面时自动更新该时间戳。

## 2026-05-30

### 文件变更

- **CodeBreaker/CodeBreakerModel/Code.swift** *(修改)*: Match 枚举新增 String/Sendable/Equatable 遵从，Code 类新增 `timeStamp` 属性（默认为 .now），用于 attempts 排序
- **CodeBreaker/CodeBreakerModel/CodeBreaker.swift** *(修改)*: attempts 改为 `_attempts` 后备字段 + 计算属性（按 timeStamp 降序排列）；`startTimer()` 微增 elapsedTime 以触发 SwiftUI 刷新
- **CodeBreaker/UI/Color+String.swift** *(重构)*: 提取 `namedColors` 静态字典，新增 grey/primary/secondary/accent/accentColor 预设支持；重组解析优先级（预设名 → 十六进制 → RGBA → RGB）；`gameString`/`fromGameString` 改为调用通用转换方法，消除硬编码 switch；简化多处辅助方法；移除废弃的示例代码块
- **CodeBreaker/UI/GameList.swift** *(重构)*: `@State private var games` → `@Query` 持久化查询；`games.remove()` → `modelContext.delete()`；`games.append()` → `modelContext.insert()`；`onAppear` 使用 FetchDescriptor 检查数据是否为空再播种初始数据
- **CodeBreaker/UI/GameChooser.swift** *(修改)*: Preview 改用 `.swiftData` trait 替代手写 modelContainer
- **CodeBreaker/UI/CodeBreakerView.swift** *(修改)*: pegColorChoices 计算属性添加注释说明 Color↔String 转换意图
- **CodeBreaker/UI/SwiftDataPreview.swift** *(新)*: 实现 PreviewModifier 协议，提供内存模式 ModelContainer 供 Preview 使用

### 变更摘要

GameList 完成 SwiftData 迁移的最后一步 — 淘汰本地 @State 数组，改用 @Query 与 modelContext 实现完整的持久化 CRUD。Color 字符串转换层大幅精简：提取统一颜色表后，gameString/fromGameString 从数十行硬编码 switch 缩减为一行调用，同时扩展了 grey/accent 等预设的支持。新增 SwiftDataPreview 为所有 SwiftData Preview 提供标准化的内存容器。

## 2026-05-26

### SwiftData 迁移 + Peg 类型重构 (7aafbdd)

- **CodeBreaker/CodeBreakerModel/CodeBreaker.swift** *(修改)*: `@Observable` → `@Model`，Peg typealias 从 Color 改为 String，masterCode/guessCode/attempts 添加 `@Relationship(deleteRule: .cascade)`，startTime 添加 `@Transient`，移除手写的 Hashable/Identifiable/Equatable（@Model 自动合成），commitGuess() 改为创建新 Code 实例而非原地修改 kind
- **CodeBreaker/CodeBreakerModel/Code.swift** *(修改)*: struct → `@Model` class，Kind 枚举提取至独立文件，kind 通过 `_kind: String` 存储并桥接计算属性，Match 枚举从 MatchMaker.swift 迁入并添加 Codable 遵从，移除 mutating 关键字（class 不需要）
- **CodeBreaker/CodeBreakerModel/Kind.swift** *(新)*: 从 Code.swift 提取 Kind 枚举，新增 rawString 序列化 / init?(rawString:) 反序列化，支持 master(isHidden:)/guess/attempt([Match]) 三种 case 与 String 互转
- **CodeBreaker/CodeBreakerModel/CodeBreakerApp.swift** *(修改)*: 添加 `import SwiftData`，GameChooser 注入 `.modelContainer(for: CodeBreaker.self)`
- **CodeBreaker/UI/Color+String.swift** *(新→完整)*: Color 扩展完整实现 — 支持预设名称/十六进制/RGB/RGBA 多格式解析，toHexString/toRGBString/toRGBAString/toColorNameString 输出，gameString/fromGameString 游戏专用转换
- **CodeBreaker/UI/PegView.swift** *(修改)*: `foregroundStyle(peg)` → `foregroundStyle(Color(from: peg) ?? .clear)`，Preview 改用 `Color.blue.toHexString()`
- **CodeBreaker/UI/CodeBreakerView.swift** *(修改)*: 新增 `convenience init(name:pegChoices: [Color])` 桥接旧 Color API，新增 `pegColorChoices` 计算属性双向转换 Color↔String，ElapsedTimeTracker 的 onChange(of: game) 改为双参数版
- **CodeBreaker/UI/PegChoicesPicker.swift** *(修改)*: `@Binding var pegChoices: [Peg]` → `[Color]`，Preview 适配
- **CodeBreaker/UI/GameEditor.swift** *(修改)*: pegChoices 改为 pegColorChoices，Preview 适配 String peg
- **CodeBreaker/UI/GameSummary.swift** *(修改)*: Preview 适配 `.map { $0.gameString }`
- **CodeBreaker/UI/GameChooser.swift** *(修改)*: 添加 SwiftData import，Preview 注入 modelContainer 修复崩溃
- **CodeBreaker/UI/MatchMaker.swift** *(修改)*: 移除 Match 枚举（迁至 Code.swift）
- **CodeBreaker/UI/ElapsedTimeView.swift** *(修改)*: 格式微调

### 变更摘要

核心架构升级：将数据模型从 `@Observable` + `struct` 迁移至 SwiftData 的 `@Model` + `class`，Peg 类型从 `Color` 改为 `String` 以实现持久化存储。新增完整的 Color↔String 双向转换层确保 UI 层不受影响。Kind 枚举独立成文件并实现序列化以适配 @Model 的存储需求。所有 Preview 同步修复（含 GameChooser 补上 modelContainer 修复预览崩溃）。

## 2026-05-23

### 文件变更

- **CodeBreaker/UI/GameList.swift** *(修改)*: 右键菜单新增 Edit 按钮（`editButton(for:)` 方法），`submit(game:)` 方法改为按名称匹配 — 已有游戏则更新，否则插入新记录
- **CodeBreaker/UI/GameEditor.swift** *(修改)*: 格式调整

### 变更摘要

为 GameList 的列表项右键菜单添加了编辑入口，用户现在可以直接通过右键 Edit 编辑已有游戏。同时重构了 submit 逻辑，使其支持原地更新而非仅追加，避免了编辑后产生重复记录的问题。

## 2026-05-22

### 文件变更

- **Extensions/ModelExtensions.swift** *(新)*: 新增 `isExist()` 校验方法 — 要求至少 2 种不同颜色的 Peg 且名称非空
- **Extensions/UIExtensions.swift** *(迁移)*: 动画/过渡/颜色/View 扩展从 `CodeBreaker/UI/` 迁移至 `Extensions/` 目录
- **CodeBreaker/UI/GameEditor.swift** *(修改)*: 添加 toolbar（Cancel / Done 按钮）、闭包式 submit/dismiss 回调、校验失败弹窗、名称输入框的 onSubmit 与自动大写
- **CodeBreaker/UI/GameList.swift** *(修改)*: Sheet 展示改用闭包回调模式替代内联 toolbar，抽取 `submit(game:)` 和 `dismiss()` 方法
- **CodeBreaker/UI/PegChoicesPicker.swift** *(修改)*: 格式调整
- **CodeBreaker.xcodeproj/project.pbxproj** *(修改)*: Xcode 项目结构新增 `Extensions` 组

### 变更摘要

将扩展文件重组到独立的 `Extensions/` 目录，提升项目结构清晰度。为 GameEditor 添加游戏校验逻辑（至少 2 种 Peg + 非空名称），并将导航逻辑从内联 toolbar 重构为闭包回调模式，使组件边界更清晰。
