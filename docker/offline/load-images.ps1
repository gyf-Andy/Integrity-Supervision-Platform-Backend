param(
    [string]$BundleRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"

$imageTar = Join-Path $BundleRoot "docker-images\integrity-docker-images.tar"

if (-not (Test-Path -LiteralPath $imageTar)) {
    throw "Docker image tar not found: $imageTar"
}

Write-Host "Loading Docker images: $imageTar"
docker load -i $imageTar

Write-Host ""
Write-Host "Related images:"
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" |
    Select-String -Pattern "integrity/|nacos|redis|nginx|sentinel|minio|eclipse-temurin" -CaseSensitive:$false
