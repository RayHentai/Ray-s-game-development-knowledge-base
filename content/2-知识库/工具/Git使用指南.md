# Git × Unity 项目启动标准流程
> 基于 StarForge 开发过程中踩坑总结
> 每次新建项目时照着这个清单走，5分钟搞定

---

## 正确顺序（顺序很重要）

### 第一步：GitHub 上创建空仓库
1. 登录 GitHub → 右上角 `+` → `New repository`
2. 填写仓库名
3. ⚠️ **以下三个选项全部不勾选**：
   - ☐ Add a README file
   - ☐ Add .gitignore
   - ☐ Choose a license
4. 点 `Create repository`
5. 复制仓库地址备用：`https://github.com/你的用户名/项目名.git`

> **为什么要空仓库？**
> 勾选任何初始化选项都会产生一次提交，和本地历史冲突，
> 导致 push 时报 `failed to push some refs` 错误。

---

### 第二步：创建 Unity 项目
1. Unity Hub → New Project → 选模板 → 填项目名
2. 记住项目路径

---

### 第三步：放入 .gitignore（在 git init 之前）

在项目根目录（和 `Assets` 文件夹同级）创建 `.gitignore` 文件。

⚠️ **文件名注意事项：**
- 正确：`.gitignore`（只有点和后缀，无前缀）
- 错误：`StarForge.gitignore` / `gitignore.txt`
- Windows 会自动加前缀，创建后务必确认文件名

Unity 项目的标准忽略内容：
```
/Library/
/Temp/
/Obj/
/Build/
/Builds/
/Logs/
/UserSettings/
.vs/
*.csproj
*.sln
.DS_Store
```

> **为什么要在 git init 之前放？**
> 如果先 init 再放 .gitignore，Library 等大文件夹
> 已经被 Git 追踪，忽略规则不会对它们生效。

---

### 第四步：初始化 Git 并提交

打开终端，进入项目根目录：

```bash
# 初始化
git init

# 验证 .gitignore 是否生效（不应该看到 Library/ Temp/ .vs/）
git status

# 暂存所有文件
git add .

# 第一次提交
git commit -m "feat: 初始化项目"
```

---

### 第五步：连接 GitHub 并推送

```bash
# 连接远端仓库
git remote add origin https://github.com/你的用户名/项目名.git

# 推送（首次用 -u 绑定默认远端）
git push -u origin main
```

首次推送会弹出登录窗口，选 **Sign in with browser** 授权即可。

---

## 日常工作流（每天用这三条）

```bash
git add .
git commit -m "feat/fix/refactor: 描述做了什么"
git push
```

### Commit 信息规范

| 前缀 | 用途 | 示例 |
|------|------|------|
| `feat:` | 新功能 | `feat: 添加自动采集器` |
| `fix:` | 修复bug | `fix: 修复资源ID不匹配` |
| `refactor:` | 重构 | `refactor: ResourceUI改为动态生成` |
| `docs:` | 文档 | `docs: 更新GDD资源系统章节` |

---

## 踩坑备忘

| 症状 | 原因 | 解决 |
|------|------|------|
| `failed to push some refs` | GitHub 仓库不是空的 | `git pull origin main --allow-unrelated-histories` 再 push |
| `src refspec main does not match any` | 本地没有任何提交，分支不存在 | 先 `git add .` 和 `git commit` 再 push |
| `Permission denied` 无法 add | .vs 等文件被程序锁定 | 用 `git add --ignore-errors .` |
| Library/ 等被上传 | .gitignore 文件名错误或位置不对 | 确认文件名是 `.gitignore`，位置在项目根目录 |
| 点了"放弃所有更改"文件消失 | 未提交时放弃更改 = 永久删除 | 养成写完就 commit 的习惯，危险按钮要确认 |

---

## Cursor Git 面板按钮安全提示

```
✅ 安全   暂存所有更改（= git add .）
✅ 安全   提交（= git commit）
✅ 安全   推送（= git push）
⚠️ 危险   放弃所有更改（未提交内容直接删除，不可恢复）
⚠️ 危险   丢弃此文件（单文件版的放弃更改）
```

**原则：没有 commit 之前，不要点任何"放弃/丢弃"按钮。**

---

*文档版本：1.0 · 2026-05-06*

---

# 配置 VS Code 作为 Git 编辑器 Commit

配置好之后，以后每次提交只需要：

**第一步：配置一次（只需做一次）**

```powershell
git config --global core.editor "code --wait"
```

---

**第二步：以后提交都这样操作**

```powershell
git commit
```

回车后 VS Code 会自动弹出一个文件，长这样：

```
# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
```

在 `#` 注释上方**直接粘贴或输入**提交信息：

```
feat(ClickCollector): 支持不同采集方式产出不同资源

- 新增 outputResourceId 字段：玩家点击/燃料驱动采矿机的产出资源 ID
- ...
```

---

**第三步：保存并关闭这个文件**

按 `Ctrl + S` 保存，再按 `Ctrl + W` 关闭标签页。

PowerShell 里会自动完成提交，显示类似：

```
[main a1b2c3d] feat(ClickCollector): 支持不同采集方式产出不同资源
```

就完成了。

---

是的，`commit` 只是保存到**本地**仓库，`push` 才会同步到远程（GitHub/GitLab 等）。

标准流程是：

```powershell
git add .          # 暂存改动的文件
git commit         # 写提交信息，保存本地记录
git push           # 推送到远程
```

---

**但不是每次 commit 都必须立刻 push。**

常见习惯是：

- 本地连续做几个 commit（记录每个小改动）
- 到一个阶段性节点，或者要备份/协作时，统一 `push` 一次

一次 `push` 会把所有未推送的 commit 一起上传。