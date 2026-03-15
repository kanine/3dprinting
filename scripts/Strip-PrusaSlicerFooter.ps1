param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$GcodeFile
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $GcodeFile)) {
    throw "File not found: $GcodeFile"
}

$lines = Get-Content -LiteralPath $GcodeFile
$output = New-Object System.Collections.Generic.List[string]
$skip = $false

foreach ($line in $lines) {
    if ($line -eq '; prusaslicer_config = begin') {
        $skip = $true
        continue
    }

    if ($line -eq '; prusaslicer_config = end') {
        $skip = $false
        continue
    }

    if (-not $skip) {
        [void]$output.Add($line)
    }
}

Set-Content -LiteralPath $GcodeFile -Value $output
