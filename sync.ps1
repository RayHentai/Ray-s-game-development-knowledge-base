Write-Host "syncing..." -ForegroundColor Cyan
Remove-Item -Path "C:\Users\Administrator\quartz\content\*" -Recurse -Force
Copy-Item -Path "D:\OneDrive\文档\Obsidian\Hentai的知识库\*" -Destination "C:\Users\Administrator\quartz\content" -Recurse -Force
Write-Host "pushing to GitHub..." -ForegroundColor Cyan
Set-Location "C:\Users\Administrator\quartz"
git add .
git commit -m "update notes $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git push
Write-Host "done!" -ForegroundColor Green
