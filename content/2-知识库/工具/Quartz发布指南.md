# 🌐 Quartz 发布指南

---

## 🚀 快速操作

### 更新发布网站
打开 **PowerShell（管理员）**，运行：
```powershell
C:\Users\Administrator\quartz\sync.ps1
```
等出现 `done!` 后，约 1-2 分钟网站自动更新。

### 本地预览
打开**命令行（管理员）**，运行：
```
cd C:\Users\Administrator\quartz
npx quartz build --serve
```
浏览器访问：`http://localhost:8080`
退出预览：`Ctrl + C`

### 网站地址
```
https://rayhentai.github.io/Ray-s-game-development-knowledge-base
```

---

## 📁 文件位置

| 内容 | 路径 |
|------|------|
| Quartz 工程 | `C:\Users\Administrator\quartz\` |
| 笔记库 | `D:\OneDrive\文档\Obsidian\Hentai的知识库\` |
| 同步脚本 | `C:\Users\Administrator\quartz\sync.ps1` |
| 网站配置 | `C:\Users\Administrator\quartz\quartz.config.ts` |
| 屏蔽文件配置 | `C:\Users\Administrator\quartz\.gitignore` |

---

## 🔒 不公开的文件夹

目前屏蔽了以下文件夹，不会发布到网站：
- `5-AI QA`

如需添加屏蔽，打开 `.gitignore`，在末尾加一行：
```
content/文件夹名/
```
**注意：改了文件夹名要同步更新 `.gitignore`**

---

## ⚙️ 环境信息

| 工具 | 说明 |
|------|------|
| Node.js | v24.1.0 |
| Git | 安装在 `D:\Program\Git\` |
| Quartz | v4.5.2 |
| GitHub 用户名 | RayHentai |
| 仓库名 | Ray-s-game-development-knowledge-base |

---

## 🔧 常见问题

**脚本无法运行**
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**node 命令找不到**
用管理员身份打开命令行再试。

**推送失败（网络问题）**
需要挂梯子，开全局代理后重试：
```
git push
```

**网站显示 RSS XML 而不是页面**
直接访问 `https://rayhentai.github.io/Ray-s-game-development-knowledge-base` 不要带任何后缀。

---

## 📝 搭建过程记录

1. 安装 Node.js（LTS版本）、Git 已有
2. 下载 Quartz v4 zip 解压到 `C:\Users\Administrator\quartz\`
3. `npm ci` 安装依赖
4. `npx quartz create` 初始化（选 Symlink，后改为复制）
5. 配置 `baseUrl` 为 `rayhentai.github.io/Ray-s-game-development-knowledge-base`
6. 生成 SSH 密钥，添加到 GitHub
7. 创建 GitHub 仓库 `Ray-s-game-development-knowledge-base`
8. 推送代码，配置 GitHub Pages（Source 选 GitHub Actions）
9. 添加 `deploy.yml` workflow 文件
10. 编写 `sync.ps1` 同步脚本

---

*最后更新：2026-05-27*
