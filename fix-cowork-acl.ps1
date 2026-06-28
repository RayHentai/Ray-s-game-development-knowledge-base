<#
.SYNOPSIS
    修复 Claude Cowork VM 因 ACL 缺失导致的 HCS 启动失败 (0x80070005)

.DESCRIPTION
    Claude Desktop (MSIX) 每次更新后, vm_bundles 目录的 ACL 会被重置,
    导致 Hyper-V 的 "NT VIRTUAL MACHINE\Virtual Machines" 组失去对
    rootfs.vhdx 的访问权限. VM 启动时 vmwp.exe 无法打开 VHDX, 报
    0x80070005 "拒绝访问".

    脚本执行步骤:
      [1/5] 停止 Claude 与 Cowork 相关进程
      [2/5] 关闭残留的 Cowork VM
      [3/5] 取得 vm_bundles 目录的所有权 (takeown)
      [4/5] 授予 Administrators 与 Virtual Machines 完全控制 (icacls)
      [5/5] 验证 .vhdx 文件 ACL

.PARAMETER DryRun
    仅显示将要执行的操作, 不实际修改任何内容. 用于第一次跑前检查环境.

.EXAMPLE
    管理员 PowerShell 直接执行:
        PowerShell -ExecutionPolicy Bypass -File .\fix-cowork-acl.ps1

    DryRun 模式 (推荐第一次先跑这个):
        PowerShell -ExecutionPolicy Bypass -File .\fix-cowork-acl.ps1 -DryRun
#>

[CmdletBinding()]
param(
    [switch]$DryRun
)

$ErrorActionPreference = 'Continue'

# ============================================================
# 日志设置: 优先脚本所在目录, 不可写则 fallback 到 TEMP
# ============================================================
try {
    $scriptDir = if ($PSScriptRoot) { $PSScriptRoot }
                 else { Split-Path -Parent $MyInvocation.MyCommand.Path }
} catch { $scriptDir = $env:TEMP }
if (-not $scriptDir) { $scriptDir = $env:TEMP }

$logFile = Join-Path $scriptDir "fix-cowork-acl_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# 系统命令全路径 (绕开 PATH 损坏)
$takeownExe = "$env:SystemRoot\System32\takeown.exe"
$icaclsExe  = "$env:SystemRoot\System32\icacls.exe"

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet('INFO','WARN','ERROR','SUCCESS','STEP')]
        [string]$Level = 'INFO'
    )
    $timestamp = Get-Date -Format 'HH:mm:ss'
    $line = "[$timestamp] [$Level] $Message"

    $color = switch ($Level) {
        'INFO'    { 'Gray' }
        'WARN'    { 'Yellow' }
        'ERROR'   { 'Red' }
        'SUCCESS' { 'Green' }
        'STEP'    { 'Cyan' }
    }

    Write-Host $line -ForegroundColor $color
    try {
        Add-Content -Path $logFile -Value $line -Encoding UTF8 -ErrorAction SilentlyContinue
    } catch {}
}

# ============================================================
# 前置检查
# ============================================================
Write-Host ""
Write-Log "Claude Cowork ACL 修复脚本" 'STEP'
Write-Log "日志文件: $logFile" 'INFO'
if ($DryRun) { Write-Log ">>> DRY RUN 模式: 仅检查, 不修改文件 <<<" 'WARN' }
Write-Host ""

# 管理员权限
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]$currentUser
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Log "未以管理员身份运行" 'ERROR'
    Write-Log "请右键 PowerShell -> '以管理员身份运行', 然后重试" 'ERROR'
    Read-Host "按回车键退出"
    exit 1
}
Write-Log "管理员权限: OK (当前用户 $($currentUser.Name))" 'SUCCESS'

# Bundle 目录
$bundleRoot = "$env:LOCALAPPDATA\Packages\Claude_pzs8sxrjxfjjc\LocalCache\Roaming\Claude\vm_bundles"
if (-not (Test-Path $bundleRoot)) {
    Write-Log "未找到 bundle 目录:" 'ERROR'
    Write-Log "  $bundleRoot" 'ERROR'
    Write-Log "可能原因: Claude Desktop 未安装, 或 MSIX 包标识符 (Claude_pzs8sxrjxfjjc) 变了" 'INFO'
    Write-Log "可在 $env:LOCALAPPDATA\Packages\ 下查找 Claude_* 目录确认实际路径" 'INFO'
    Read-Host "按回车键退出"
    exit 1
}
Write-Log "Bundle 目录: $bundleRoot" 'SUCCESS'

# 系统命令存在性检查
foreach ($exe in @($takeownExe, $icaclsExe)) {
    if (-not (Test-Path $exe)) {
        Write-Log "未找到系统命令: $exe" 'ERROR'
        Write-Log "Windows 安装可能损坏, 中止" 'ERROR'
        Read-Host "按回车键退出"
        exit 1
    }
}
Write-Log "系统命令: OK (使用全路径调用 takeown / icacls)" 'SUCCESS'

# PATH 诊断 (不致命, 只提示)
if ($env:PATH -notmatch [regex]::Escape("$env:SystemRoot\System32")) {
    Write-Log "PATH 中缺失 $env:SystemRoot\System32 — 强烈建议事后修复" 'WARN'
    Write-Log "  本脚本已用全路径调用, 不影响本次执行" 'INFO'
    Write-Log "  修复入口: 系统属性 -> 高级 -> 环境变量 -> 系统变量 Path" 'INFO'
}

# ============================================================
# [1/5] 停止 Claude 与 Cowork 进程
# ============================================================
Write-Host ""
Write-Log "[1/5] 停止 Claude 与 Cowork 进程" 'STEP'

$processes = Get-Process -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -like "Claude*" -or $_.Name -like "*cowork*" }

if ($processes) {
    foreach ($p in $processes) {
        Write-Log "  停止: $($p.Name) (PID $($p.Id))" 'INFO'
        if (-not $DryRun) {
            try {
                Stop-Process -Id $p.Id -Force -ErrorAction Stop
            } catch {
                Write-Log "  无法停止 $($p.Name): $($_.Exception.Message)" 'WARN'
            }
        }
    }
    Start-Sleep -Seconds 2
} else {
    Write-Log "  无运行中的 Claude/Cowork 进程" 'INFO'
}

# ============================================================
# [2/5] 关闭残留的 Cowork VM
# ============================================================
Write-Host ""
Write-Log "[2/5] 关闭残留的 Cowork VM" 'STEP'

try {
    $coworkVMs = @(Get-VM -ErrorAction Stop | Where-Object { $_.Name -like "cowork-vm-*" })
    if ($coworkVMs.Count -gt 0) {
        foreach ($vm in $coworkVMs) {
            Write-Log "  VM: $($vm.Name) (状态: $($vm.State))" 'INFO'
            if (-not $DryRun -and $vm.State -ne 'Off') {
                try {
                    Stop-VM -Name $vm.Name -TurnOff -Force -ErrorAction Stop
                    Write-Log "  已关闭" 'SUCCESS'
                } catch {
                    Write-Log "  关闭失败: $($_.Exception.Message)" 'WARN'
                }
            }
        }
    } else {
        Write-Log "  无残留 Cowork VM" 'INFO'
    }
} catch {
    Write-Log "  Hyper-V 模块不可用, 跳过此步: $($_.Exception.Message)" 'WARN'
    Write-Log "  (不影响 ACL 修复继续执行)" 'INFO'
}

# ============================================================
# [3/5] 取得 bundle 目录所有权
# ============================================================
Write-Host ""
Write-Log "[3/5] 取得 bundle 目录所有权" 'STEP'

if ($DryRun) {
    Write-Log "  [DRY RUN] 跳过 takeown" 'INFO'
} else {
    $null = & $takeownExe /F $bundleRoot /R /A /D Y 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Log "  takeown 完成" 'SUCCESS'
    } else {
        Write-Log "  takeown 退出码 $LASTEXITCODE (部分文件无法处理通常无影响)" 'WARN'
    }
}

# ============================================================
# [4/5] 设置 ACL
# ============================================================
Write-Host ""
Write-Log "[4/5] 设置 ACL" 'STEP'

# Administrators 组 (S-1-5-32-544)
Write-Log "  授予 Administrators 完全控制..." 'INFO'
if ($DryRun) {
    Write-Log "  [DRY RUN] 跳过 icacls" 'INFO'
} else {
    $null = & $icaclsExe $bundleRoot /grant "*S-1-5-32-544:(OI)(CI)F" /T /C 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Log "  Administrators: OK" 'SUCCESS'
    } else {
        Write-Log "  Administrators: icacls 退出码 $LASTEXITCODE" 'WARN'
    }
}

# Virtual Machines 组 (S-1-5-83-0) — 这是关键
Write-Log "  授予 NT VIRTUAL MACHINE\Virtual Machines 完全控制..." 'INFO'
if ($DryRun) {
    Write-Log "  [DRY RUN] 跳过 icacls" 'INFO'
} else {
    $null = & $icaclsExe $bundleRoot /grant "*S-1-5-83-0:(OI)(CI)F" /T /C 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Log "  Virtual Machines: OK" 'SUCCESS'
    } else {
        Write-Log "  Virtual Machines: icacls 退出码 $LASTEXITCODE" 'ERROR'
        Write-Log "  这是关键步骤, 若失败 Cowork 仍会报 0x80070005" 'ERROR'
    }
}

# ============================================================
# [5/5] 验证 .vhdx 文件 ACL
# ============================================================
Write-Host ""
Write-Log "[5/5] 验证 VHDX 文件 ACL" 'STEP'

$vhdxFiles = @(Get-ChildItem -Path $bundleRoot -Filter "*.vhdx" -Recurse -ErrorAction SilentlyContinue)
if ($vhdxFiles.Count -gt 0) {
    $allOk = $true
    foreach ($vhdx in $vhdxFiles) {
        $relativePath = $vhdx.FullName.Substring($bundleRoot.Length).TrimStart('\')
        Write-Log "  $relativePath" 'INFO'
        $aclText = (& $icaclsExe $vhdx.FullName 2>&1) -join "`n"
        if ($aclText -match 'Virtual Machines' -or $aclText -match 'S-1-5-83-0') {
            Write-Log "    Virtual Machines 权限: 已设置" 'SUCCESS'
        } else {
            Write-Log "    Virtual Machines 权限: 缺失 (修复未生效)" 'ERROR'
            $allOk = $false
        }
    }
    if (-not $allOk -and -not $DryRun) {
        Write-Log "  建议: 在 Claude 错误对话框中点 'Reinstall workspace' 让 Cowork 重下 VHDX" 'WARN'
    }
} else {
    Write-Log "  未找到 .vhdx 文件 (Cowork 可能尚未首次启动, 此为正常)" 'WARN'
}

# ============================================================
# 收尾
# ============================================================
Write-Host ""
Write-Log "==========================================" 'STEP'
if ($DryRun) {
    Write-Log "DRY RUN 完成 (未修改任何文件)" 'SUCCESS'
} else {
    Write-Log "修复完成" 'SUCCESS'
}
Write-Log "==========================================" 'STEP'
Write-Log "下一步:" 'INFO'
Write-Log "  1. 启动 Claude (无需以管理员身份运行)" 'INFO'
Write-Log "  2. 触发 Cowork 任务, 验证 VM 启动" 'INFO'
Write-Log "  3. 若 [5/5] 验证失败, 在错误对话框点 'Reinstall workspace'" 'INFO'
Write-Log "  4. 日志已保存到: $logFile" 'INFO'
Write-Host ""

if ($Host.Name -eq 'ConsoleHost' -and -not $env:CI) {
    Read-Host "按回车键退出"
}
