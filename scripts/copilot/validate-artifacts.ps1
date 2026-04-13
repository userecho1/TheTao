Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

$canonicalInstructionFiles = @(
  '.copilot\instructions\dao.instructions.md',
  '.copilot\instructions\shu.instructions.md'
)

$requiredFiles = @(
  'README.md',
  '.copilot\copilot-instructions.md',
  'scripts\copilot\validate-artifacts.ps1'
) + $canonicalInstructionFiles

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

$specsPath = Join-Path $repoRoot 'specs'
if (Test-Path -LiteralPath $specsPath -PathType Container) {
  $errors.Add("Forbidden directory exists: specs")
}

if ($errors.Count -gt 0) {
  Write-Host 'Validation FAILED:' -ForegroundColor Red
  foreach ($err in $errors) {
    Write-Host " - $err" -ForegroundColor Red
  }
  exit 1
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

function Assert-NotContains {
  param(
    [Parameter(Mandatory = $true)][string]$Text,
    [Parameter(Mandatory = $true)][string]$Pattern,
    [Parameter(Mandatory = $true)][string]$ErrorMessage
  )

  if ([Regex]::IsMatch($Text, $Pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
    $errors.Add($ErrorMessage)
  }
}

$readmeText = Get-Content -LiteralPath (Join-Path $repoRoot 'README.md') -Raw
$canonicalDaoText = Get-Content -LiteralPath (Join-Path $repoRoot '.copilot\instructions\dao.instructions.md') -Raw
$copilotEntryText = Get-Content -LiteralPath (Join-Path $repoRoot '.copilot\copilot-instructions.md') -Raw
$canonicalShuText = Get-Content -LiteralPath (Join-Path $repoRoot '.copilot\instructions\shu.instructions.md') -Raw

# Entry/reference checks (minimal and non-duplicative).
Assert-Contains -Text $readmeText -Pattern '\.copilot\\instructions\\' -ErrorMessage 'README missing canonical instructions directory reference'
Assert-Contains -Text $readmeText -Pattern '\.copilot\\copilot-instructions\.md' -ErrorMessage 'README missing .copilot\copilot-instructions.md entry link'
Assert-Contains -Text $readmeText -Pattern '\.copilot\\instructions\\dao\.instructions\.md' -ErrorMessage 'README missing canonical dao path reference'
Assert-Contains -Text $readmeText -Pattern '\.copilot\\instructions\\shu\.instructions\.md' -ErrorMessage 'README missing canonical shu path reference'
Assert-NotContains -Text $readmeText -Pattern '\.github\\instructions\\world-rules\.instructions\.md|\.github\\copilot-instructions\.md' -ErrorMessage 'README should not reference .github compatibility shim paths'
Assert-NotContains -Text $readmeText -Pattern '\.copilot\\governance\\' -ErrorMessage 'README should not reference deprecated .copilot\governance path'

Assert-Contains -Text $copilotEntryText -Pattern '\.copilot[\\/]+instructions[\\/]+dao\.instructions\.md' -ErrorMessage '.copilot\copilot-instructions missing canonical dao load reference'
Assert-Contains -Text $copilotEntryText -Pattern '\.copilot[\\/]+instructions[\\/]+shu\.instructions\.md' -ErrorMessage '.copilot\copilot-instructions missing canonical shu load reference'

# Key governance anchors stay in canonical sources (dao + shu).
$governanceText = @($canonicalDaoText, $canonicalShuText) -join "`n"
Assert-Contains -Text $governanceText -Pattern 'Draft\s*->\s*Trial\s*->\s*Active\s*->\s*Deprecated\s*->\s*Retired' -ErrorMessage 'Lifecycle anchor missing in governance docs'
Assert-Contains -Text $governanceText -Pattern 'owner.+Main approval|Main approval.+owner' -ErrorMessage 'Gate anchor missing (owner/Main approval)'
Assert-Contains -Text $governanceText -Pattern 'rollback' -ErrorMessage "Governance docs missing 'rollback' anchor"
Assert-Contains -Text $governanceText -Pattern 'fail-close' -ErrorMessage "Governance docs missing 'fail-close' anchor"

foreach ($source in @('web', 'wiki-db', 'mcp', 'cli')) {
  Assert-Contains -Text $canonicalShuText -Pattern ([Regex]::Escape($source)) -ErrorMessage "shu rules missing dynamic source '$source'"
}

if ($errors.Count -gt 0) {
  Write-Host 'Validation FAILED:' -ForegroundColor Red
  foreach ($err in $errors) {
    Write-Host " - $err" -ForegroundColor Red
  }
  exit 1
}

Write-Host 'Validation PASSED: canonical instruction paths and anchors are present.' -ForegroundColor Green
exit 0
