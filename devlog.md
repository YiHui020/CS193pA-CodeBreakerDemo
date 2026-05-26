# 开发日志 — CodeBreaker

## 2026-05-26

### 文件变更

- **CodeBreaker/UI/ElapsedTimeView.swift** *(修改)*: startTime 改为可选类型，新增 elapsedTime 参数和 format 计算属性，startTime 为 nil 时显示暂停图标
- **CodeBreaker/CodeBreakerModel/CodeBreaker.swift** *(修改)*: 新增 startTimer()/pauseTimer() 方法，startTime 改为可选、新增 elapsedTime 累积，restart() 中交由 onAppear 触发计时
- **CodeBreaker/UI/CodeBreakerView.swift** *(修改)*: 添加 onAppear/onDisappear 生命周期钩子驱动计时器启停，传递 elapsedTime 给 ElapsedTimeView
- **CodeBreaker/UI/GameList.swift** *(修改)*: 新增 leading swipe 编辑操作，sheet 从按钮移至 List 层级，列表样式改为 plain，editButton 改用 init 值拷贝避免引用共享
- **CodeBreaker/UI/CodeBreakerView.swift** *(修改)*: 计时器逻辑提取为 ElapsedTimeTracker ViewModifier，新增 scenePhase 响应（后台暂停、前台恢复），View extension `trackElapsedTime(in:)` 统一调用入口
- **CodeBreaker/UI/GameChooser.swift** *(修改)*: 格式调整

### 变更摘要

计时器进一步重构：将 onAppear/onDisappear 内联逻辑抽取为可复用的 ElapsedTimeTracker ViewModifier，并接入 scenePhase 实现应用前后台切换时的自动暂停/恢复，提升计时精度的同时保持代码整洁。

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
