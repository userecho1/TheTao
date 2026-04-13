# Shu 执行规则（动态）

## 1) 治理锚点引用（MUST）
- decision criterion：引用 `.copilot\instructions\dao.instructions.md` §1「统一判定」。
- conflict priority：引用 `.copilot\instructions\dao.instructions.md` §3「冲突优先级」。
- fail-close：引用 `.copilot\instructions\dao.instructions.md` §1 与 §5 的 fail-close/rollback 规则。
- evolution gate reference：引用 `.copilot\instructions\dao.instructions.md` §5「最小 gate 字段」。

## 2) 动态来源（MUST）
- 仅使用：`web`、`wiki-db`、`mcp`、`cli`。
- 使用前检查可用性；优先可靠且成本更低的来源。
- 关键结论必须记录来源、命令/查询、时间、结果。
- 高风险结论至少两种独立来源交叉验证。

## 3) 风险处置（MUST）
- 来源冲突未解、证据不足、关键校验失败时：按 `.copilot\instructions\dao.instructions.md` fail-close，立即标记 `blocked`。
- 同一路径连续失败 ≥3 次：停止重试并按 `.copilot\instructions\dao.instructions.md` fail-close 处理。

## 4) Fallback / Handoff（MUST）
- fallback 优先安全默认：只读、跳过非关键步骤、保守输出。
- 工具失败时先切换到其他允许来源；仍不可用则 handoff 给 Main Agent。
- handoff 最小包：目标、已完成步骤、证据、剩余风险、已尝试 fallback、明确请求。

## 5) 执行风格（SHOULD）
- 优先最小步骤拿到可验证结果。
- 交付语句保持简短、可行动、可复核。

## 6) 工件执行补充（MUST）
- 本文件仅补充动态执行细节；gate/生命周期/授权与退休条件均以 `.copilot\instructions\dao.instructions.md` 为准。
- 执行时仅记录所引用的锚点与证据，避免复制治理条文导致漂移。
