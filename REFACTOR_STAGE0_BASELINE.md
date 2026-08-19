# 重构阶段 0 基线记录

> 分支：`refactor/stage-0-baseline`（从 `master` @ `09502a2` 创建）
> 记录时间：2026-08-06

## 1. 编译验证

- 命令：`xcodebuild -project TinyCal.xcodeproj -scheme TinyCal -configuration Debug build`
- 首次运行因本机无 "Mac Development" 签名证书失败（`No signing certificate "Mac Development" found`），这是本机开发环境的签名配置问题，非代码问题。
- 加 `CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO` 后 **BUILD SUCCEEDED**，产物：
  `~/Library/Developer/Xcode/DerivedData/TinyCal-*/Build/Products/Debug/TinyCal.app`
- 依赖解析正常：SPM 拉取 `Cron-Swift@master`（`3704a7f`），与 `ARCHITECTURE.md` 记录一致。

## 2. 运行时冒烟验证

- `open TinyCal.app` 后进程正常常驻（`ps aux` 可见，持续运行无退出）。
- `osascript` 通过 System Events 确认该进程属于 `background only` 进程，符合 `LSUIElement = true` 的菜单栏应用预期（不出现 Dock 图标）。
- 运行期间 `~/Library/Logs/DiagnosticReports/` 未产生任何 TinyCal 崩溃日志。
- 已正常终止测试进程，不影响用户机器上已安装的 `/Applications/TinyCal.app` 正在运行的实例。

## 3. 未能完成的验证项（需人工补充）

当前环境下 `screencapture` 报 `could not create image from display`（终端/自动化进程缺少"屏幕录制"权限），因此**无法**通过截图方式验证：

- 菜单栏文案/图标渲染是否符合 `AppSettings` 三个开关的组合预期；
- 日历面板的翻月（上月/下月/回到今天）视觉效果；
- 设置页三组开关（菜单栏 / 日历 / 其他）的交互反馈。

以上三项建议由用户在本机手动点击验证一次并简单描述现象（或在系统设置里为终端授予屏幕录制权限后由我重新截图），作为后续每个阶段对比的视觉基线。代码层面（构建成功、进程稳定运行、无崩溃日志）已确认为可用于回归对比的行为基线。

## 4. 结论

- 项目在当前 `master` 状态下可正常编译、运行、常驻菜单栏，无启动崩溃。
- 以上即为进入阶段 1（P0 止血修复）前的行为基线；阶段 1 完成后将用相同方法（编译 + 常驻验证 + 崩溃日志检查）做回归对比，UI 视觉项待用户确认权限后补充。
