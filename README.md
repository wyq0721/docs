# docs
documents for AI experience

## 文档目录

- [拉取 GitCode 代码仓库常见问题与解决方案](gitcode-pull-guide.md)

## GitCode Sync Skill

本仓库内置了一个 **GitCode 同步技能（Skill）**：当你告诉 AI（Copilot Coding Agent）执行 GitCode 相关操作时，它会自动触发 [`gitcode-sync`](.github/workflows/gitcode-sync.yml) GitHub Actions Workflow，将指定 GitCode 仓库的内容同步到本仓库。

### 前置配置：设置 GitHub Secrets

在使用前，需要在本仓库的 **Settings → Secrets and variables → Actions** 中添加以下两个 Secret：

| Secret 名称      | 说明                                |
|-----------------|-------------------------------------|
| `GITCODE_USER`  | 你的 GitCode 用户名                  |
| `GITCODE_TOKEN` | GitCode 个人访问令牌（需有 `read_repository` 权限） |

> 生成令牌：登录 GitCode → 设置 → 访问令牌 → 新建令牌，勾选 `read_repository`。

### 使用方法

直接用自然语言告诉 AI，例如：

- `从 gitcode 同步 cjc-compiler-frontend/compiler-performance-panel 仓库`
- `把 gitcode 上的 myorg/myrepo 同步到 synced/myrepo 目录`

AI 会更新 [`.github/gitcode-sync-request.json`](.github/gitcode-sync-request.json) 并自动触发 [`gitcode-sync`](.github/workflows/gitcode-sync.yml) workflow，将代码同步后自动 commit 到本仓库。

同步结果会存放在 `synced/<仓库名>/` 目录下（可通过 `target_dir` 参数自定义）。

如需手动触发，仍可在 GitHub Actions 页面运行 `GitCode Sync` workflow，并填写对应参数。

### Workflow 参数说明

| 参数            | 必填 | 说明                                         | 默认值              |
|----------------|------|----------------------------------------------|---------------------|
| `gitcode_repo` | ✅   | GitCode 仓库路径，如 `org/repo-name`          | —                   |
| `target_dir`   | ❌   | 同步到本仓库的目标目录（相对路径）              | `synced/<仓库名>`   |
| `branch`       | ❌   | 要同步的分支                                  | `main`              |
