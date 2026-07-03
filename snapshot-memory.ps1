# ============================================================
# snapshot-memory.ps1
# Claude memory 三源快照脚本(非 Project / Project / Cowork)
#
# 用法:
#   1. 修改下方"配置区"
#   2. 在 administrator PowerShell 中执行: .\snapshot-memory.ps1
#   3. 按提示操作(主要是切换 Claude.ai 上的 Project 然后复制)
# ============================================================

# ---------- 配置区(按需修改) ----------

$KnowledgeBaseRoot = "D:\OneDrive\文档\Obsidian\Hentai的知识库"
$SnapshotDir      = Join-Path $KnowledgeBaseRoot "5-AI QA\记忆"

# 你在 claude.ai 上的 Project 列表(留空则跳过 Project memory 这一步)
$ClaudeProjects = @(
    "蜕变",
    "亲密关系学习",
    "游戏开发学习",
    "个人成长"
)

# Cowork project 的本地文件夹路径
# 查找方法:Claude Desktop > Cowork > 选中 project > 右侧 Context 面板能看到 "Local folder" 路径
# 注意:Windows 上 Cowork 用 VHDX 跑沙箱,如果你看不到 host 上的文件夹,这块就跳过
$CoworkProjects = @(
    @{ Name = "C#-review"; Path = "C:\Users\Administrator\CoworkProjects\C#-review\.claude\memory" }
    )

# 是否自动 git commit & push 到 Quartz 仓库
$AutoCommit = $false

# ---------- 执行区(一般不用动) ----------

$Today    = Get-Date -Format "yyyy-MM-dd"
$TodayDir = Join-Path $SnapshotDir $Today

if (-not (Test-Path $TodayDir)) {
    New-Item -ItemType Directory -Path $TodayDir -Force | Out-Null
}
Write-Host "`n[$Today] 快照目录: $TodayDir" -ForegroundColor Cyan

# --- 工具函数:把剪贴板内容包装成模板并保存 ---
function Save-MemoryFromClipboard {
    param(
        [string]$Title,
        [string]$FileName,
        [string]$Source
    )

    $clip = Get-Clipboard -Raw
    if ([string]::IsNullOrWhiteSpace($clip)) {
        Write-Host "  ⚠ 剪贴板为空,跳过 $FileName" -ForegroundColor Yellow
        return
    }

    $lines = @(
        '---',
        'title: "' + $Title + '"',
        "date: $Today",
        'tags:',
        '  - Tools/Claude',
        '  - Memory/Snapshot',
        'type: snapshot',
        'draft: true',
        '---',
        '',
        "> **来源**: $Source",
        "> **导出日期**: $Today",
        '',
        '## Memory 原文',
        '',
        '```text',
        $clip,
        '```'
    )

    $path = Join-Path $TodayDir $FileName
    [System.IO.File]::WriteAllText($path, ($lines -join "`r`n"), [System.Text.Encoding]::UTF8)
    Write-Host "  ✓ 已保存: $FileName" -ForegroundColor Green
}

# --- 1. 非 Project memory ---
Write-Host "`n[1/3] 非 Project memory" -ForegroundColor Yellow
Write-Host "→ 打开 claude.ai → Settings → Capabilities → View memory → Ctrl+A → Ctrl+C"
Read-Host "  复制完成后按回车"
Save-MemoryFromClipboard "非 Project memory - $Today" "personal.md" "Claude.ai / 非 Project"

# --- 2. 各 Project memory ---
if ($ClaudeProjects.Count -gt 0) {
    Write-Host "`n[2/3] Project memory" -ForegroundColor Yellow
    foreach ($proj in $ClaudeProjects) {
        Write-Host "→ 进入 Project '$proj' → Settings → View memory → Ctrl+A → Ctrl+C"
        Read-Host "  复制完成后按回车"
        $safeName = "project-" + ($proj -replace '[\\/:*?"<>|\s]', '_') + ".md"
        Save-MemoryFromClipboard "Project: $proj - $Today" $safeName "Claude.ai / Project: $proj"
    }
} else {
    Write-Host "`n[2/3] Project memory: (未配置,跳过)" -ForegroundColor DarkGray
}

# --- 3. Cowork memory(本地文件,无需手动) ---
Write-Host "`n[3/3] Cowork memory" -ForegroundColor Yellow
if ($CoworkProjects.Count -eq 0) {
    Write-Host "  (未配置 Cowork project,跳过)" -ForegroundColor DarkGray
} else {
    foreach ($cw in $CoworkProjects) {
        if (Test-Path $cw.Path) {
            $destName = "cowork-" + ($cw.Name -replace '[\\/:*?"<>|\s]', '_')
            $dest = Join-Path $TodayDir $destName
            Copy-Item -Path $cw.Path -Destination $dest -Recurse -Force
            Write-Host "  ✓ Cowork '$($cw.Name)' 已复制到 $destName" -ForegroundColor Green
        } else {
            Write-Host "  ✗ 路径不存在: $($cw.Path)" -ForegroundColor Red
        }
    }
}

# --- 4. 与上次快照 diff ---
Write-Host "`n[diff] 与上次快照对比" -ForegroundColor Yellow
$prevDir = Get-ChildItem $SnapshotDir -Directory |
    Where-Object { $_.Name -match '^\d{4}-\d{2}-\d{2}$' -and $_.Name -lt $Today } |
    Sort-Object Name -Descending |
    Select-Object -First 1

if ($prevDir) {
    $diffLines = @(
        '---',
        "title: 变更追踪 - $Today vs $($prevDir.Name)",
        "date: $Today",
        'draft: true',
        '---',
        '',
        "对比基准:[[$($prevDir.Name)/personal]]",
        ''
    )

    Get-ChildItem $TodayDir -Filter "*.md" |
        Where-Object { $_.Name -ne "changes.md" } |
        ForEach-Object {
            $prevFile = Join-Path $prevDir.FullName $_.Name
            $diffLines += "## $($_.Name)"
            $diffLines += ''
            if (Test-Path $prevFile) {
                $diff = git diff --no-index --no-color -- "$prevFile" "$($_.FullName)" 2>$null
                if ($diff) {
                    $diffLines += '```diff'
                    $diffLines += $diff
                    $diffLines += '```'
                } else {
                    $diffLines += '(无变化)'
                }
            } else {
                $diffLines += '⭐ 本次新增'
            }
            $diffLines += ''
        }

    $diffPath = Join-Path $TodayDir "changes.md"
    [System.IO.File]::WriteAllText($diffPath, ($diffLines -join "`r`n"), [System.Text.Encoding]::UTF8)
    Write-Host "  ✓ diff 已写入 changes.md" -ForegroundColor Green
} else {
    Write-Host "  (没有上次快照,跳过 diff)" -ForegroundColor DarkGray
}

# --- 5. Git commit & push ---
if ($AutoCommit) {
    Write-Host "`n[git] commit & push" -ForegroundColor Yellow
    Push-Location $KnowledgeBaseRoot
    try {
        git add "$TodayDir" 2>&1 | Out-Host
        git commit -m "memory snapshot: $Today" 2>&1 | Out-Host
        git push 2>&1 | Out-Host
    } finally {
        Pop-Location
    }
}

Write-Host "`n完成。打开 Obsidian 查看 Tools/Claude/Memory snapshots/$Today/" -ForegroundColor Cyan
