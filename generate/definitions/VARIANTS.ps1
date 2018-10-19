# Docker image variants' definitions
$VARIANTS_VERSION = "1.0.0"
$VARIANTS = @(
    @{
        name = 'geoip'
        includeEntrypointScript = $true
        distro = 'ubuntu'
    }
    @{
        name = 'geoip-geoip2'
        includeEntrypointScript = $true
        distro = 'ubuntu'
    }
    @{
        name = 'geoip-geoip2-emailsender'
        includeEntrypointScript = $true
        distro = 'ubuntu'
    }
    @{
        name = 'alpine-geoip'
        includeEntrypointScript = $true
        distro = 'alpine'
    }
    @{
        name = 'alpine-geoip-geoip2'
        includeEntrypointScript = $true
        distro = 'alpine'
    }
)

# Intelligently add properties
$VARIANTS | % {
    $VARIANT = $_
    $_['version'] = $VARIANTS_VERSION
    $_['extensions'] = $_['name'] -split '-' | ? { $_.Trim() } | ? { $_ -ne $VARIANT['distro'] }
}

# Send definitions down the pipeline
$VARIANTS