# Bootstraps opencode on Windows using this repo's shared config.
#
# What it does:
#   1. Installs the opencode CLI if it isn't already on PATH.
#   2. Links opencode.json and AGENTS.md into opencode's global config
#      directory (%USERPROFILE%\.config\opencode) so every machine that runs
#      this script behaves the same way.
#
# Usage (from a normal PowerShell prompt, run as your own user):
#   cd <repo>\scripts
#   .\install.ps1

$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent $PSScriptRoot
$ConfigDir = Join-Path $env:USERPROFILE ".config\opencode"

if (-not (Get-Command opencode -ErrorAction SilentlyContinue)) {
    Write-Host "opencode not found, installing..."

    if (Get-Command npm -ErrorAction SilentlyContinue) {
        npm install -g opencode-ai
    } elseif (Get-Command scoop -ErrorAction SilentlyContinue) {
        scoop install opencode
    } elseif (Get-Command choco -ErrorAction SilentlyContinue) {
        choco install opencode -y
    } else {
        Write-Host "No supported package manager found (npm, scoop, or choco)."
        Write-Host "Install Node.js (https://nodejs.org) and re-run this script, or grab a binary from https://opencode.ai/download"
        exit 1
    }
} else {
    Write-Host "opencode is already installed."
    opencode --version
}

New-Item -ItemType Directory -Force -Path $ConfigDir | Out-Null

foreach ($f in @("opencode.json", "AGENTS.md")) {
    $target = Join-Path $ConfigDir $f
    $source = Join-Path $RepoDir $f

    if (Test-Path $target) {
        Remove-Item $target -Force
    }

    try {
        # Requires Developer Mode or an elevated prompt on most Windows setups.
        New-Item -ItemType SymbolicLink -Path $target -Target $source -Force | Out-Null
        Write-Host "Linked $target -> $source"
    } catch {
        # Fall back to a plain copy if symlinks aren't permitted.
        Copy-Item -Path $source -Destination $target -Force
        Write-Host "Copied $source -> $target (symlink not permitted; re-run this script after editing the repo to refresh the copy)"
    }
}

Write-Host ""
Write-Host "Done. Next steps:"
Write-Host "  1. Run 'opencode auth login' to connect a provider (OpenCode Zen recommended)."
Write-Host "  2. Run 'opencode' from any project to start."
