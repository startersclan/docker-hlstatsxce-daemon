$local:VARIANTS_MATRIX = @(
    @{
        package_version = 'v1.6.19'
        package_githash = '11cac08de8c01b7a07897562596e59b7f0f86230'
        distro = 'ubuntu'
        distro_version = '16.04'
        subvariants = @(
            # @{ components = @() }
            @{ components = @( 'emailsender' ) }
            @{ components = @( 'geoip' ) }
            @{ components = @( 'geoip', 'geoip2' ) }
            @{ components = @( 'geoip', 'geoip2', 'emailsender' ) }
        )
    }
    @{
        package_version = 'v1.6.19'
        package_githash = '11cac08de8c01b7a07897562596e59b7f0f86230'
        distro = 'alpine'
        distro_version = '3.8'
        subvariants = @(
            # @{ components = @() }
            @{ components = @( 'emailsender' ) }
            @{ components = @( 'geoip' ); tag_as_latest = $true }
            @{ components = @( 'geoip', 'geoip2' ) }
            @{ components = @( 'geoip', 'geoip2', 'emailsender' ) }
        )
    }
)
# Docker image variants' definitions
$VARIANTS = @(
    foreach ($variant in $local:VARIANTS_MATRIX) {
        foreach ($subVariant in $variant['subvariants']) {
            @{
                # Metadata object
                _metadata = @{
                    # package_version = $variant['package_version']
                    distro = $variant['distro']
                    distro_version = $variant['distro_version']
                    platforms = 'linux/amd64'
                }
                # Docker image tag. E.g. 'v1.6.19-geoip-alpine-3.8'
                tag = @(
                        $variant['package_version']
                        $subVariant['components'] | ? { $_ }
                        $variant['distro']
                        $variant['distro_version']
                ) -join '-'
                tag_as_latest = if ( $subVariant.Contains('tag_as_latest') ) {
                                    $subVariant['tag_as_latest']
                                } else {
                                    $false
                                }
                components = $subVariant['components']
                distro = $variant['distro']
                buildContextFiles = @{
                    templates = @{
                        'Dockerfile' = @{
                            common = $false
                            includeHeader = $true
                            includeFooter = $true
                            passes = @(
                                @{
                                    variables = @{
                                        hlstatsxce_git_hash = $variant['package_githash']
                                    }
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
                }
            }
        }
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
}
