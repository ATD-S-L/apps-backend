# Configure branch protection for ATD-S-L repositories
# Usage: .\scripts\configure-branch-protection.ps1 -Owner "ATD-S-L" -Repo "apps-backend" -Token $env:GITHUB_TOKEN

param(
    [Parameter(Mandatory=$true)]
    [string]$Owner = "ATD-S-L",
    
    [Parameter(Mandatory=$true)]
    [string]$Repo = "apps-backend",
    
    [Parameter(Mandatory=$true)]
    [string]$Token = $env:GITHUB_TOKEN
)

if (-not $Token) {
    Write-Error "GitHub token is required. Set GITHUB_TOKEN environment variable or pass -Token parameter."
    exit 1
}

$branch = "main"
$apiUrl = "https://api.github.com/repos/$Owner/$Repo/branches/$branch/protection"

Write-Host "Configuring branch protection for $Owner/$Repo:$branch..."

$body = @{
    required_status_checks = @{
        strict = $true
        contexts = @("Test", "Build")
    }
    enforce_admins = $true
    required_pull_request_reviews = @{
        dismiss_stale_reviews = $true
        require_code_owner_reviews = $false
        required_approving_review_count = 1
    }
    restrictions = $null
    allow_force_pushes = $false
    allow_deletions = $false
    require_linear_history = $false
    required_conversation_resolution = $false
    allow_auto_merge = $true
} | ConvertTo-Json

$headers = @{
    "Authorization" = "token $Token"
    "Accept" = "application/vnd.github.v3+json"
}

try {
    $response = Invoke-WebRequest -Uri $apiUrl -Method PUT -Headers $headers -Body $body -ContentType "application/json"
    Write-Host "✅ Branch protection configured successfully for $Owner/$Repo:$branch"
    Write-Host "Response: $($response.StatusCode)"
} catch {
    Write-Error "Failed to configure branch protection: $($_.Exception.Message)"
    exit 1
}
