# Docker image variants' definitions
$VARIANTS_VERSION = "1.0.4a"
$VARIANTS = @(
    # Ubuntu
    @{
        tag = 'cron'
        distro = 'ubuntu'
    }
    @{
        tag = 'cron-emailsender'
        distro = 'ubuntu'
    }
    @{
        tag = 'cron-geoip'
        distro = 'ubuntu'
    }
    @{
        tag = 'cron-geoip-geoip2'
        distro = 'ubuntu'
    }
    @{
        tag = 'cron-geoip-geoip2-emailsender'
        distro = 'ubuntu'
    }
    @{
        tag = 'emailsender'
        distro = 'ubuntu'
    }
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

    # Alpine
    @{
        tag = 'cron-alpine'
        distro = 'alpine'
    }
    @{
        tag = 'cron-emailsender-alpine'
        distro = 'alpine'
    }
    @{
        tag = 'cron-geoip-alpine'
        distro = 'alpine'
    }
    @{
        tag = 'cron-geoip-geoip2-alpine'
        distro = 'alpine'
    }
    @{
        tag = 'cron-geoip-geoip2-emailsender-alpine'
        distro = 'alpine'
    }
    @{
        tag = 'emailsender-alpine'
        distro = 'alpine'
    }
    @{
        tag = 'geoip-alpine'
        distro = 'alpine'
    }
    @{
        tag = 'geoip-geoip2-alpine'
        distro = 'alpine'
    }
    @{
        tag = 'geoip-geoip2-emailsender-alpine'
        distro = 'alpine'
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
    version = $VARIANTS_VERSION
    submodules = @{
        'hlstatsx-community-edition' = 'https://bitbucket.org/Maverick_of_UC/hlstatsx-community-edition.git'
    }
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

# Send definitions down the pipeline
$VARIANTS