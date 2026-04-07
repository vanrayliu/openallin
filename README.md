# OpenAllIn — 全栈 AI 编程 Harness

> 融合 OpenSpec、Superpowers、GSD、OMC、ECC、Trellis 六大框架核心优势的工程化体系

## 架构总览

OpenAllIn 采用 **分层搭积木** 设计，每层独立可选、自由组合：

```
┌─────────────────────────────────────────────────┐
│  Layer 6: Workspace  — 项目记忆与并行流水线      │  ← Trellis
│  .trellis/tasks/  workspace/  parallel pipeline  │
├─────────────────────────────────────────────────┤
│  Layer 5: Orchestration — 多代理团队编排          │  ← OMC
│  team-plan  team-exec  team-verify  agent roles  │
├─────────────────────────────────────────────────┤
│  Layer 4: Execution — 阶段化执行与上下文工程      │  ← GSD
│  discuss → plan → execute → verify → ship       │
├─────────────────────────────────────────────────┤
│  Layer 3: Enhancement — 安全/记忆/学习/验证      │  ← ECC
│  hooks  security  memory  instincts  learning    │
├─────────────────────────────────────────────────┤
│  Layer 2: Skills — 工程方法论技能库              │  ← Superpowers
│  brainstorm  TDD  debug  review  worktree        │
├─────────────────────────────────────────────────┤
│  Layer 1: Spec — 规格驱动开发                    │  ← OpenSpec
│  project.md  specs/  changes/  delta system      │
└─────────────────────────────────────────────────┘
```

## 目录结构

```
openallin/
├── AGENTS.md                    # 统一指令入口（所有 AI 工具读取）
├── project.md                   # 项目全局上下文（技术栈、架构、规范）
├── README.md                    # 本文件
│
├── specs/                       # [Spec 层] 当前系统行为规格（SOURCE OF TRUTH）
│   ├── auth/
│   │   └── spec.md
│   ├── api/
│   │   └── spec.md
│   └── ui/
│       └── spec.md
│
├── changes/                     # [Spec 层] 进行中的变更提案
│   ├── <change-name>/
│   │   ├── proposal.md          # WHY：动机、范围、影响
│   │   ├── design.md            # HOW：技术方案、架构决策
│   │   ├── specs/               # WHAT：增量规格（ADDED/MODIFIED/REMOVED）
│   │   │   └── spec.md
│   │   └── tasks.md             # STEPS：实现清单
│   └── archive/                 # 已归档的变更（按时间戳）
│
├── skills/                      # [Skills 层] 可组合技能
│   ├── brainstorming.md         # 头脑风暴与需求探索
│   ├── tdd-workflow.md          # 测试驱动开发
│   ├── systematic-debugging.md  # 系统化调试
│   ├── code-review.md           # 代码审查
│   ├── worktree-isolation.md    # Git Worktree 隔离
│   ├── writing-plans.md         # 计划编写
│   └── verification.md          # 验证闭环
│
├── agents/                      # [Orchestration 层] 专用代理定义
│   ├── planner.md               # 架构师/规划器（高阶推理）
│   ├── implementer.md           # 执行者（代码实现）
│   ├── reviewer.md              # 审查者（质量把关）
│   ├── debugger.md              # 调试者（问题诊断）
│   └── researcher.md            # 研究者（信息检索）
│
├── rules/                       # [Enhancement 层] 全局规则
│   ├── coding-standards.md      # 编码规范
│   ├── security-rules.md        # 安全规则
│   ├── commit-rules.md          # 提交规则
│   └── review-rules.md          # 审查规则
│
├── hooks/                       # [Enhancement 层] 事件驱动自动化
│   ├── hooks.json               # Hook 注册表
│   ├── pre-tool-use.js          # 工具执行前检查
│   ├── post-tool-use.js         # 工具执行后审计
│   ├── session-start.js         # 会话启动：加载上下文
│   └── session-end.js           # 会话结束：持久化状态
│
├── config/                      # [Enhancement 层] 配置
│   ├── settings.json            # 全局设置
│   ├── memory.json              # 记忆与学习数据
│   └── instincts.json           # 直觉/模式库
│
├── tasks/                       # [Execution 层] 任务驱动工作流
│   ├── <task-id>/
│   │   ├── task.json            # 元数据：状态、分支、优先级
│   │   ├── prd.md               # 需求文档
│   │   ├── implement.jsonl      # 实现 Agent 上下文配置
│   │   └── check.jsonl          # 检查 Agent 上下文配置
│   └── archive/
│
├── workspace/                   # [Workspace 层] 项目记忆
│   ├── index.md                 # 会话索引
│   ├── STATE.md                 # 当前执行状态
│   ├── ROADMAP.md               # 项目路线图
│   └── journals/
│       └── journal-<date>.md    # 每日工作日志
│
├── .planning/                   # [Execution 层] 运行时规划状态
│   ├── config.json              # 运行配置
│   ├── CONTEXT.md               # 澄清后的需求
│   └── REQUIREMENTS.md          # 提取的需求
│
├── templates/                   # 模板库
│   ├── proposal.md
│   ├── design.md
│   ├── spec.md
│   ├── tasks.md
│   └── task.json
│
└── scripts/                     # 工具脚本
    ├── init.sh                  # 初始化脚本
    ├── validate-spec.sh         # 规格验证
    └── archive-change.sh        # 变更归档
```

## 快速开始

### 1. 初始化

```bash
# 在项目根目录初始化 OpenAllIn
bash scripts/init.sh
```

### 2. 工作流

```
# Step 1: 规格驱动（先把"做什么"写清楚）
/oa:propose <change-name>     → 创建变更提案（proposal + design + specs + tasks）
/oa:validate <change-name>    → 验证规格格式
/oa:apply <change-name>       → 按任务清单执行

# Step 2: 阶段化执行（解决上下文腐烂）
/oa:discuss <phase>           → 讨论阶段，澄清模糊地带
/oa:plan <phase>              → 计划阶段，拆分原子任务
/oa:execute <phase>           → 执行阶段，波次并行
/oa:verify <phase>            → 验证阶段，质量把关
/oa:ship <phase>              → 发布阶段，创建 PR

# Step 3: 团队协作（多代理编排）
/oa:team-plan                 → 团队规划
/oa:team-exec                 → 团队执行
/oa:team-verify               → 团队验证

# Step 4: 技能调用（工程纪律）
/oa:brainstorm                → 头脑风暴
/oa:tdd                       → 测试驱动开发
/oa:debug                     → 系统化调试
/oa:review                    → 代码审查
/oa:worktree                  → Git Worktree 隔离
```

### 3. 分层采用建议

| 你的痛点 | 优先启用层 | 组合建议 |
|---------|-----------|---------|
| 需求总跑偏 | Spec 层 | Spec + Skills |
| AI 写得太随意 | Skills 层 | Spec + Skills |
| 长任务容易崩 | Execution 层 | Spec + Execution |
| 需要多人并行 | Orchestration 层 | Spec + Orchestration |
| 跨会话失忆 | Workspace 层 | Spec + Workspace |
| 想要完整体系 | 全层 | 全部（建议渐进式） |

## 设计理念

1. **规格先行** — 需求没对齐前不写代码（OpenSpec）
2. **工程纪律** — 把优秀工程师的习惯变成默认动作（Superpowers）
3. **上下文清洁** — 拆小任务、阶段分离、信息结构化（GSD）
4. **团队编排** — 多代理像团队一样协作（OMC）
5. **能力增强** — 安全、记忆、学习、验证闭环（ECC）
6. **项目记忆** — 用文件而非 LLM 记忆来持久化上下文（Trellis）

## 许可证

MIT
