[CmdletBinding()]
param(
  [string]$RepoPath = 'C:\Users\7skyc\Desktop\Codex\관상\doctor_face_montage_v20_asset_alignment_kit\doctor_face_montage_v20_asset_alignment_kit',
  [switch]$AllowDirty
)

$ErrorActionPreference = 'Stop'

function Invoke-Git {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Args
  )

  & git @Args
  if ($LASTEXITCODE -ne 0) {
    throw "git $($Args -join ' ') failed with exit code $LASTEXITCODE"
  }
}

function Invoke-Vercel {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Args
  )

  & npx vercel @Args
  if ($LASTEXITCODE -ne 0) {
    throw "npx vercel $($Args -join ' ') failed with exit code $LASTEXITCODE"
  }
}

$resolvedRepo = (Resolve-Path -LiteralPath $RepoPath).Path
Push-Location $resolvedRepo

try {
  $statusLines = git status --short --branch
  if ($LASTEXITCODE -ne 0) {
    throw 'git status failed'
  }

  $dirtyLines = $statusLines | Select-Object -Skip 1
  if (-not $AllowDirty -and $dirtyLines.Count -gt 0) {
    throw "Working tree is dirty. Commit or stash changes before running finish_deploy.ps1."
  }

  $branch = (git rev-parse --abbrev-ref HEAD).Trim()
  if ($LASTEXITCODE -ne 0) {
    throw 'Failed to resolve current branch.'
  }

  Invoke-Git -Args @('push', 'origin', $branch)

  $deployOutput = & npx vercel deploy --prod --yes
  if ($LASTEXITCODE -ne 0) {
    throw "npx vercel deploy --prod --yes failed with exit code $LASTEXITCODE"
  }

  $deployText = ($deployOutput | Out-String).Trim()
  $deploymentUrl = $null
  $vercelMatches = [regex]::Matches($deployText, 'https://[a-zA-Z0-9.-]+\.vercel\.app')
  if ($vercelMatches.Count -gt 0) {
    $deploymentUrl = $vercelMatches[$vercelMatches.Count - 1].Value
  }

  if (-not $deploymentUrl) {
    $productionMatch = [regex]::Match($deployText, 'Production\s+https://[a-zA-Z0-9.-]+')
    if ($productionMatch.Success) {
      $deploymentUrl = ($productionMatch.Value -split '\s+')[-1]
    }
  }

  if (-not $deploymentUrl) {
    throw 'Could not determine deployment URL from Vercel output.'
  }

  $inspectOutput = & npx vercel inspect $deploymentUrl
  if ($LASTEXITCODE -ne 0) {
    throw "npx vercel inspect $deploymentUrl failed with exit code $LASTEXITCODE"
  }

  $inspectText = ($inspectOutput | Out-String).Trim()
  $headCommit = (git rev-parse HEAD).Trim()
  if ($LASTEXITCODE -ne 0) {
    throw 'Failed to resolve HEAD commit.'
  }

  [pscustomobject]@{
    repo = $resolvedRepo
    branch = $branch
    head = $headCommit
    deploymentUrl = $deploymentUrl
    gitStatus = ($statusLines -join [Environment]::NewLine)
    inspect = $inspectText
  } | ConvertTo-Json -Depth 4
}
finally {
  Pop-Location
}
