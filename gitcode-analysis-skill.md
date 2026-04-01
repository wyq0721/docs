# GitCode 分析 Skill

该 Skill 用于处理用户提到 `gitcode` 关键词，并希望：

- 拉取（clone）GitCode 仓库
- 阅读 README
- 分析技术栈、目录结构、入口文件或构建方式
- 总结代码仓的用途和模块划分

与“同步到当前仓库”的 workflow 不同，这个 Skill 的目标是在**当前沙箱**中直接完成克隆与分析，适合一次性的代码阅读与总结。

## 触发意图

当用户请求包含以下意图时，优先使用本 Skill：

- `gitcode`
- `clone gitcode`
- `分析 gitcode 仓库`
- `总结 gitcode readme`
- `看看 gitcode 上这个 repo 做什么`

## 执行步骤

1. 从用户请求中提取 GitCode 仓库路径 `owner/repo`
2. 需要时确认分支，默认使用 `main`
3. 在沙箱里运行：

   ```bash
   /home/runner/work/docs/docs/scripts/analyze-gitcode.sh <owner/repo> [branch]
   ```

4. 基于脚本输出继续分析：
   - 先读 README
   - 再看根目录清单文件（如 `package.json`、`go.mod`、`pyproject.toml`）
   - 再根据源码目录使用 `rg` / `view` 深入查看入口文件、模块边界和运行方式
5. 最终向用户输出：
   - 项目用途总结
   - 技术栈判断
   - 核心目录/模块说明
   - README 关键内容摘要
   - 如有需要，再补充构建、运行、测试方式

## 私有仓支持

如果目标 GitCode 仓库是私有仓，需要在沙箱环境里提供：

- `GITCODE_USER`
- `GITCODE_TOKEN`

其中令牌需具备 `read_repository` 权限。

## 与 GitCode Sync Skill 的区别

| Skill | 目的 | 执行位置 | 输出 |
| --- | --- | --- | --- |
| GitCode 分析 Skill | 即时 clone 并分析代码 | 当前沙箱 | 临时目录 `/tmp/gitcode-analysis/...` 与分析结论 |
| GitCode Sync Skill | 持久化同步仓库内容 | GitHub Actions | 本仓库内 `synced/<repo-name>/` |
