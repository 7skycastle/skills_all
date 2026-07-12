param(
  [string]$ProjectPath = "C:\Users\7skyc\Desktop\anti\K_study",
  [string]$ProductionUrl = "https://k-study.vercel.app",
  [switch]$AllowDirty
)

$ErrorActionPreference = "Stop"

function Run-Step {
  param(
    [string]$Name,
    [scriptblock]$Command
  )
  Write-Host ""
  Write-Host "== $Name ==" -ForegroundColor Cyan
  & $Command
}

Set-Location -LiteralPath $ProjectPath

$status = git status --short
if ($status -and -not $AllowDirty) {
  Write-Host "Working tree is dirty. Commit or stash changes before running finish deploy." -ForegroundColor Yellow
  git status --short --branch
  exit 2
}

Run-Step "Git status" { git status --short --branch }
Run-Step "Push main" { git push origin main }
Run-Step "Vercel redeploy" { npx vercel redeploy $ProductionUrl --target production }
Run-Step "Vercel inspect" { npx vercel inspect $ProductionUrl }
Run-Step "Post-deploy check" { npm run check:post-deploy }
Run-Step "Final git status" { git status --short --branch }

Write-Host ""
Write-Host "Finish deploy completed." -ForegroundColor Green
