# OpenAllIn 架构详解

> 6 层能力如何协同工作，以及为什么这样设计

## 设计哲学

OpenAllIn 不是"6 个框架的简单拼接"，而是经过深思熟虑的 **分层架构**。每层解决一个特定类型的问题，层与层之间有清晰的接口和依赖关系。

### 为什么要分层？

```
问题: "AI 编程不稳定"
  ↓
拆解:
  - 需求不稳定 → Spec 层解决
  - 行为不稳定 → Skills 层解决
  - 上下文不稳定 → Execution 层解决
  - 协作不稳定 → Orchestration 层解决
  - 能力不稳定 → Enhancement 层解决
  - 记忆不稳定 → Workspace 层解决
```

每一层都是一个 **稳定器**，解决 AI 编程中一个特定维度的不稳定性。

---

## 层 1: Spec — 规格驱动开发

**来源**: OpenSpec
**解决**: "AI 不知道你要什么"

### 核心机制

1. **Delta Spec 系统** — 变更只描述差异，不是全量重写
2. **RFC 2119 关键词** — MUST/SHALL/SHOULD/MAY 定义强制程度
3. **Gherkin Scenarios** — GIVEN/WHEN/THEN 描述行为
4. **Archive 合并** — 增量规格自动合并到主规格

### 为什么有效

- 把聊天记录中的模糊意图变成结构化资产
- 规格是 SOURCE OF TRUTH，不随会话变化
- 增量系统支持并行开发不冲突

### 文件流

```
proposal.md (WHY) → design.md (HOW) → specs/ (WHAT) → tasks.md (STEPS)
```

---

## 层 2: Skills — 工程方法论

**来源**: Superpowers
**解决**: "AI 会写但不像工程师"

### 核心机制

1. **手动调用** — 用户显式调用 `/oa-*` 命令激活技能
2. **工作流定义** — 每个技能有明确的步骤和输出
3. **推荐场景** — 文档提供推荐调用时机指南

### 技能矩阵

| 技能 | 推荐时机 | 核心纪律 |
|------|---------|---------|
| /oa-brainstorming | 创造性工作前 | 先理解再动手 |
| /oa-tdd | 写代码前（可选） | 红→绿→重构 |
| /oa-debugging | 遇到 bug | 先复现再修复 |
| /oa-review | 完成任务后 | 多维度审查 |
| /oa-worktree | 开始分支开发 | 隔离工作环境 |
| /oa-writing-plans | 多步任务前 | 原子化拆分 |
| /oa-verify | 声称完成前 | 证据优先 |

### 为什么有效

- 把优秀工程师的隐性知识变成显式流程
- AI 提供最佳实践指导，用户主动遵循
- 新成员（人类或 AI）通过文档学习团队纪律

---

## 层 3: Execution — 阶段化执行

**来源**: GSD
**解决**: "对话一长就崩"

### 核心机制

1. **阶段隔离** — 每个 phase 独立上下文窗口
2. **文件状态** — 所有进度持久化到文件
3. **波次执行** — 独立任务并行，依赖任务串行
4. **原子提交** — 每个任务完成后立即 git commit

### 阶段流

```
discuss → plan → execute → verify → ship
  ↓        ↓        ↓         ↓        ↓
CONTEXT  PLAN    WAVES    REPORT    PR
```

### 为什么有效

- 每个阶段都是"干净"的上下文，没有历史噪音
- 文件状态保证跨会话连续性
- 波次执行最大化并行度同时保证正确性

---

## 层 4: Enhancement — 能力增强

**来源**: ECC
**解决**: "每次 session 都像从零开始"

### 核心机制

1. **Hooks** — 事件驱动自动化（session start/end 记录）
2. **Memory** — 项目决策、模式、约定持久化（手动维护）
3. **Instincts** — 可复用模式库（手动维护）
4. **Security** — 密钥检测、Git 安全、配置保护

### Hook 生命周期

```
SessionStart → 加载上下文 → 工作 → PreToolUse → 执行 → PostToolUse → SessionEnd → 记录日志
```

### 为什么有效

- 跨会话记忆不丢失（通过文件持久化）
- 安全规则通过 hooks 检查执行
- 用户可主动维护 memory.json 和 instincts.json

---

## 层 5: Orchestration — 多代理编排

**来源**: OMC
**解决**: "多个 agent 像无头苍蝇"

### 核心机制

1. **角色定义** — 每个 agent 有明确职责和工具限制
2. **编排流程** — team-plan → team-exec → team-verify
3. **决策/执行分离** — 高阶模型做决策，执行模型做实现

### Agent 角色

| Agent | 角色 | 模型建议 | 工具限制 |
|-------|------|---------|---------|
| Planner | 架构决策 | 高阶 | 只读 |
| Implementer | 代码实现 | 中阶 | 读写 |
| Reviewer | 质量把关 | 高阶 | 只读 |
| Debugger | 问题诊断 | 中阶 | 读写 |
| Researcher | 信息检索 | 低阶 | 只读+搜索 |

### 为什么有效

- 不要让最贵的模型做最便宜的活
- 角色隔离防止权限滥用
- 编排流程确保协作有序

---

## 层 6: Workspace — 项目记忆

**来源**: Trellis
**解决**: "AI 没有长期记忆"

### 核心机制

1. **工作日志** — 每次会话结束记录到 journals/（通过 hooks）
2. **状态文件** — STATE.md / ROADMAP.md 追踪进度（手动维护）
3. **任务上下文** — 每个任务有独立的上下文配置
4. **JSONL 注入** — 精确控制每个 agent 看到的文件

### 记忆层次

```
workspace/
├── index.md          → 会话索引（快速查找）
├── STATE.md          → 当前状态（会话启动加载）
├── ROADMAP.md        → 路线图（全局视角）
└── journals/         → 工作日志（详细记录）
    └── journal-YYYY-MM-DD.md
```

### 为什么有效

- 文件即记忆，不依赖 LLM 窗口
- 新 session 通过 Hook 自动加载上下文
- 日志可回溯，方便交接和审计

---

## 层间交互

### 典型数据流

```
用户提出需求
    ↓
[Spec 层] 生成 proposal + specs → 持久化到 changes/
    ↓
[Skills 层] brainstorming 澄清需求 → 输出到 CONTEXT.md
    ↓
[Execution 层] plan → tasks.md → execute waves
    ↓
[Orchestration 层] 分配 agent → worktree 隔离执行
    ↓
[Enhancement 层] hooks 安全检查 → verification 验证
    ↓
[Workspace 层] 日志记录 → 状态更新 → 记忆沉淀
```

### 关键接口

| 层间 | 接口文件 | 内容 |
|------|---------|------|
| Spec → Skills | proposal.md + specs/ | 需求和规格 |
| Skills → Execution | CONTEXT.md + tasks.md | 澄清的需求和任务 |
| Execution → Orchestration | waves + agent assignments | 执行计划 |
| Orchestration → Enhancement | tool usage logs | 审计数据 |
| Enhancement → Workspace | memory.json + journals | 记忆和日志 |

---

## 渐进式采用

### 阶段 1: 单人行车（1-2 周）
- 启用: Spec + Skills
- 目标: 养成规格先行和工程纪律习惯
- 标志: 每个变更都有 proposal + tasks

### 阶段 2: 复杂任务（2-4 周）
- 新增: Execution
- 目标: 解决长任务和 context rot 问题
- 标志: 阶段文件完整，可跨会话续跑

### 阶段 3: 团队协作（4-8 周）
- 新增: Orchestration + Workspace
- 目标: 多人并行，项目记忆
- 标志: 多 agent 协作，日志完整

### 阶段 4: 持续优化（持续）
- 新增: Enhancement
- 目标: 安全、学习、自动化
- 标志: hooks 自动运行，instincts 积累

---

## 与原始框架的对应关系

| OpenAllIn 层 | 来源框架 | 核心保留 | 改进点 |
|-------------|---------|---------|--------|
| Spec | OpenSpec | Delta spec, archive | 简化 CLI，更灵活 |
| Skills | Superpowers | 工程纪律技能 | 推荐调用指南 |
| Execution | GSD | 阶段隔离, 波次执行 | 更轻量的状态管理 |
| Orchestration | OMC | Agent 角色, 团队流 | 平台无关 |
| Enhancement | ECC | Hooks, memory, security | 精简为核心功能 |
| Workspace | Trellis | 项目记忆, JSONL 注入 | 简化目录结构 |
