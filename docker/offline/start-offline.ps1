param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
)

$ErrorActionPreference = "Stop"

Push-Location $RepoRoot
try {
    if (-not (Test-Path -LiteralPath "docker\.env")) {
        Copy-Item -LiteralPath "docker\.env.example" -Destination "docker\.env"
        Write-Host "Created docker/.env from docker/.env.example. Check DM database settings before startup."
    }

    docker info | Out-Null

    Write-Host "Starting offline Docker development environment..."
    docker compose --env-file docker/.env -f docker/docker-compose.apps.yml up -d

    Write-Host ""
    Write-Host "Container status:"
    docker compose --env-file docker/.env -f docker/docker-compose.apps.yml ps
}
finally {
    Pop-Location
}
