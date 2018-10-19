# Docker image variants' definitions
$VARIANTS_VERSION = "1.0.0"
$VARIANTS = @(
    @{
        tag = 'geoip'
        distro = 'ubuntu'
    }
    @{
        tag = 'geoip-geoip2'
        distro = 'ubuntu'
    }
    @{
        tag = 'geoip-geoip2-emailsender'
        distro = 'ubuntu'
    }
    @{
        tag = 'geoip-alpine'
        distro = 'alpine'
    }
    @{
        tag = 'geoip-geoip2-alpine'
        distro = 'alpine'
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
    version = $VARIANTS_VERSION
    buildContextFiles = @{
        templates = @{
            'Dockerfile' = @{
                common = $false
                includeHeader = $true
                includeFooter = $true
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
            'docker-entrypoint.sh' = @{
                common = $true
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
        }
        copies = @(

        )
     }
}

# Intelligently add properties
$VARIANTS | % {
    $VARIANT = $_
    $VARIANTS_SHARED.GetEnumerator() | % {
        $VARIANT[$_.Name] =  $_.Value
    }
}

# Send definitions down the pipeline
$VARIANTS