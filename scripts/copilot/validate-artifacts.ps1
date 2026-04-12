Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

$requiredFiles = @(
  'README.md',
  'AGENTS.md',
  '.github\copilot-instructions.md',
  '.github\instructions\world-rules.instructions.md',
  'scripts\copilot\validate-artifacts.ps1'
)

$errors = New-Object System.Collections.Generic.List[string]

foreach ($relativePath in $requiredFiles) {
  $fullPath = Join-Path $repoRoot $relativePath
  if (-not (Test-Path -LiteralPath $fullPath)) {
    $errors.Add("Missing file: $relativePath")
    continue
  }

  $item = Get-Item -LiteralPath $fullPath
  if ($item.Length -le 0) {
    $errors.Add("Empty file: $relativePath")
  }
}

function Assert-Contains {
  param(
    [Parameter(Mandatory = $true)][string]$Text,
    [Parameter(Mandatory = $true)][string]$Pattern,
    [Parameter(Mandatory = $true)][string]$ErrorMessage
  )

  if (-not [Regex]::IsMatch($Text, $Pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
    $errors.Add($ErrorMessage)
  }
}

$readmeText = Get-Content -LiteralPath (Join-Path $repoRoot 'README.md') -Raw
$agentsText = Get-Content -LiteralPath (Join-Path $repoRoot 'AGENTS.md') -Raw
$copilotText = Get-Content -LiteralPath (Join-Path $repoRoot '.github\copilot-instructions.md') -Raw
$worldRulesText = Get-Content -LiteralPath (Join-Path $repoRoot '.github\instructions\world-rules.instructions.md') -Raw

# Entry/reference checks (minimal and non-duplicative).
Assert-Contains -Text $readmeText -Pattern 'AGENTS\.md' -ErrorMessage "README missing 'AGENTS.md' entry link"
Assert-Contains -Text $readmeText -Pattern 'world-rules\.instructions\.md' -ErrorMessage 'README missing world-rules entry link'
Assert-Contains -Text $readmeText -Pattern '\.github\\copilot-instructions\.md' -ErrorMessage 'README missing copilot-instructions entry link'

Assert-Contains -Text $copilotText -Pattern 'AGENTS\.md' -ErrorMessage "copilot-instructions missing 'AGENTS.md' load reference"
Assert-Contains -Text $copilotText -Pattern 'world-rules\.instructions\.md' -ErrorMessage 'copilot-instructions missing world-rules load reference'

# Key governance anchors stay in canonical sources (AGENTS + world-rules).
$governanceText = @($agentsText, $worldRulesText) -join "`n"
Assert-Contains -Text $governanceText -Pattern 'Draft\s*->\s*Trial\s*->\s*Active\s*->\s*Deprecated\s*->\s*Retired' -ErrorMessage 'Lifecycle anchor missing in governance docs'
Assert-Contains -Text $governanceText -Pattern 'owner.+Main approval|Main approval.+owner' -ErrorMessage 'Gate anchor missing (owner/Main approval)'
Assert-Contains -Text $governanceText -Pattern 'rollback' -ErrorMessage "Governance docs missing 'rollback' anchor"
Assert-Contains -Text $governanceText -Pattern 'fail-close' -ErrorMessage "Governance docs missing 'fail-close' anchor"

foreach ($source in @('web', 'wiki-db', 'mcp', 'cli')) {
  Assert-Contains -Text $worldRulesText -Pattern ([Regex]::Escape($source)) -ErrorMessage "world-rules missing dynamic source '$source'"
}

if ($errors.Count -gt 0) {
  Write-Host 'Validation FAILED:' -ForegroundColor Red
  foreach ($err in $errors) {
    Write-Host " - $err" -ForegroundColor Red
  }
  exit 1
}

Write-Host 'Validation PASSED: minimal Dao+Shu references and anchors are present.' -ForegroundColor Green
exit 0
