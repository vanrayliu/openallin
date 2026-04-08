---
name: oa-discuss
description: OpenAllIn /oa:discuss 命令 — 需求讨论阶段
---

# /oa:discuss — 需求讨论阶段

当用户输入 `/oa:discuss <phase>` 时执行此技能。

## 工作流程

### 1. 澄清需求
- 用户想解决什么问题？
- 期望的输入和输出是什么？
- 边界情况有哪些？

### 2. 探索方案
- 提出 2-3 种实现方案
- 分析各方案优缺点
- 推荐最适合的方案

### 3. 确认共识
- 明确范围（做什么 / 不做什么）
- 确认技术选型
- 输出讨论结论到 `workspace/CONTEXT.md`

## 输出

- `workspace/CONTEXT.md` — 讨论结论和需求澄清
