# AI for Cangjie 实践（ACE 平台 20' Deck）

> 场景：GitCode 社区 AI 开发者线下进化场｜总时长 ~20 分钟｜主题聚焦 ACE 平台落地

## Slide 01｜封面（1'）
- AI for Cangjie 实践：让 Agent 成为仓颉研发新基建
- GitCode 社区 AI 开发者线下进化场
- 讲者：仓颉编译器前端团队 / 日期：2026

## Slide 02｜受众与目标（1'）
- 受众：AI 开发者、编译器/系统工程师、GitCode 社区贡献者
- 目标：分享仓颉团队的 AI 落地路径，重点讲清 ACE 平台如何把个人效率提升复制为组织级生产力
- 收获：可复制的工作流模板、风险治理思路、可直接试用的开源资源

## Slide 03｜业务痛点与动机（2'）
- 需求与人力矛盾：需求涌入远超人力，且都紧急重要
- 能力断档：跨领域备份不足，前端等技术栈缺口阻碍交付
- 质量压力：人力吃紧导致质量螺旋下降，团队士气受挫
- 关键窗口：仓颉开源 + C++ 语料充足 + 大模型 2025H2 爆发 → 必须抓住 AI 窗口

## Slide 04｜演进路线图（2'）
- 2025.08-11 启动：Cursor/Copilot Tab，加速日常编辑
- 2025.12-2026.01 探索：消灭路径依赖（编译性能看板一周上线），验证 AI First-Try
- 2026.02-至今 规模化：搭建 ACE 平台，状态机工作流 + 攻防迭代；DFX Skills 推向客户侧
- 结论：单兵效率 → 平台化协作 → 场景化技能外溢

## Slide 05｜方法论抽象（2'）
- AI First-Try：先让 Agent 试，再人工纠偏
- 信息澄清：通过 `[NEED_INFO]` 协议强制 Agent 先补齐上下文
- 闭环场景：每个任务绑定可测验收指标，避免“讲故事”
- 边界识别：模型擅长重复、结构化工作；关键决策保留人工把关

## Slide 06｜ACE 平台是什么（2'）
- 定位：Agent Centric Engineering——团队级 AI 研发平台
- 核心角色：Defender（构建/修复）、Attacker（审查/挑战）、Judge（裁决）
- 工作流：支持 phase-based 线性和 state-machine 状态机两种模式
- 资产沉淀：知识库 18 模块 / 714 文件 / 1036 类 + 7 个仓颉专用 skill，全链路持久化 runs/{runId}/

## Slide 07｜架构关键设计（2'）
- 状态机引擎：Agent 输出 JSON 判决 `verdict/next_state` → transition 规则驱动跳转，`maxTransitions` + circuit breaker 防循环
- Supervisor-Lite 路由：Agent 只声明需求 `[NEED_INFO]`，由路由器决策问谁，保持 prompt 纯净
- 攻防迭代：Defender 产出 → Attacker 红队 → Judge 判决，不通过自动回滚重试
- HITL 审批：可配置人工检查点，支持 forceTransition / inject-feedback

## Slide 08｜实战案例：Issue #701 自动修复（2'）
- 场景：社区生产问题，需在多轮分析后精准修复
- 过程：57 步，16.5 小时自动完成，含 3 次自动回滚
- 结果：最终方案与人类专家一致——单行修复 `Attribute::IN_EXTEND`
- 收获：状态机 + 攻防让 Agent 在复杂场景保持可控，验证平台价值

## Slide 09｜能力外溢：DFX Skills（1.5'）
- 典型 skill：内存回归分析流水线（采集 → 复现 → 对比 → 根因 → 修复）
- 复用方式：工作流模板 + Skill 目录结构可直接移植到客户仓库
- 效果：把一次性解题变成可复制的“插件”，降低二线支持成本

## Slide 10｜度量与价值（1.5'）
- 个人效率：Tab 加速 20-30%，路径依赖场景实现“不会做也能做”
- 团队效率：工作流模板复用，问题处理周期从“周”级降到“小时”级
- 质量：攻防迭代 + 人工审批，减少“幻觉式”合入；知识库让“代码即文档”
- 组织收益：技能外溢到客户侧，形成新的服务资产

## Slide 11｜风险与治理（1.5'）
- 典型风险：Agent 猜测缺失信息、状态机循环、知识过时
- 治理手段：
  - 路由：`[NEED_INFO]` 协议 + 关键词路由避免盲猜
  - 控制：`maxTransitions` / circuit breaker / 自转移限流
  - 审批：关键节点 requireHumanApproval，保留最终决策
  - 审计：全链路记录 runs/{runId}/state.yaml 便于复盘

## Slide 12｜对 GitCode 社区的意义（1'）
- 仓颉开源语料丰富，模型可直接理解 → 适合社区贡献者快速上手
- ACE 工作流与 skill 可迁移到 GitCode 仓库，支撑 issue 修复、PR 巡检、规格分析
- 期待：与社区共建场景化 skill，沉淀到开源目录供复用

## Slide 13｜如何加入 & 现场互动（1'）
- 体验：gitcode.com/cjc-compiler-frontend/cangjie_frontend_ace（ACE 平台）  
- 案例：gitcode.com/cjc-compiler-frontend/compiler-performance-panel（性能看板）  
- Skill：gitcode.com/l3gi0n/cangjie_dfx_skills/tree/main/cjc（DFX Skills）
- 现场互动：用你们的仓库/issue 现场跑一条 state-machine 工作流，观察攻防回合

## Slide 14｜结语 & Q/A（1'）
- 一句话：ACE 让 AI 从“个人外挂”变成“团队基建”，仓颉实践可复制到更多社区项目
- 下一步：持续打磨 Supervisor-Lite 智能路由、自迭代知识库，欢迎共建
- Q/A 时间
