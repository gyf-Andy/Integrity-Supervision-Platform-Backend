$ErrorActionPreference = "Continue"

$urls = @(
    "http://localhost:8080/actuator/health",
    "http://localhost:9200/actuator/health",
    "http://localhost:9201/actuator/health",
    "http://localhost:9202/actuator/health",
    "http://localhost:9203/actuator/health",
    "http://localhost:9204/actuator/health",
    "http://localhost:9300/actuator/health",
    "http://localhost:9100/actuator/health"
)

foreach ($url in $urls) {
    try {
        $response = Invoke-WebRequest -UseBasicParsing -TimeoutSec 8 -Uri $url
        Write-Host "$url -> $($response.StatusCode)"
    }
    catch {
        Write-Host "$url -> ERROR $($_.Exception.Message)"
    }
}
