# TheTao

TheTao 只保留最小执行骨架：**Dao + Shu**。
治理文本 canonical 目录：`.copilot\instructions\`（Dao + Shu 原文）。

## 单一入口策略
- 唯一 Copilot 入口：`.copilot\copilot-instructions.md`
- 入口只负责按顺序加载 canonical 文本：
  1. `.copilot\instructions\dao.instructions.md`
  2. `.copilot\instructions\shu.instructions.md`

## 关键文件
- `.copilot\instructions\dao.instructions.md`：Dao（硬约束）
- `.copilot\instructions\shu.instructions.md`：Shu（动态规则）
- `.copilot\copilot-instructions.md`：唯一 Copilot 入口

## 校验原则
- 仅以 canonical 路径为准：`.copilot\instructions\` + `.copilot\copilot-instructions.md`。
- 保持最小、可执行、可验证。
