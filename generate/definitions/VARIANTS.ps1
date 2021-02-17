$local:VARIANTS_DISTROS = @(
    'ubuntu:16.04'
    'alpine:3.8'
)
$local:VARIANTS_MATRIX = @(
    foreach ($d in $local:VARIANTS_DISTROS) {
        @{
            # package_version = 'v1.6.19'
            distro = $d.Split(':')[0]
            distro_version = $d.Split(':')[1]
            subvariants = @(
                # @{ components = @() }
                @{ components = @( 'emailsender' ) }
                @{ components = @( 'geoip' ); tag_as_latest = if ($d -match 'alpine') { $true } else { $false } }
                @{ components = @( 'geoip', 'geoip2' ) }
                @{ components = @( 'geoip', 'geoip2', 'emailsender' ) }
            )
        }
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
                }
                # Docker image tag. E.g. 'v2.3.0.0-alpine-3.6'
                tag = @(
                        # $variant['package_version']
                        $subVariant['components'] | ? { $_ }
                        if ($variant['distro'] -match 'alpine') { $variant['distro'] }
                        # $variant['distro_version']
                ) -join '-'
                tag_as_latest = if ( $subVariant.Contains('tag_as_latest') ) {
                                    $subVariant['tag_as_latest']
                                } else {
                                    $false
                                }
                components = $subVariant['components']
                distro = $variant['distro']
            }
        }
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
    buildContextFiles = @{
        templates = @{
            'Dockerfile' = @{
                common = $false
                includeHeader = $true
                includeFooter = $true
                passes = @(
                    @{
                        variables = @{
                            hlstatsxce_git_url = 'https://bitbucket.org/Maverick_of_UC/hlstatsx-community-edition.git'
                            hlstatsxce_git_hash = '11cac08de8c01b7a07897562596e59b7f0f86230'
                            geolitecity_url = 'https://github.com/startersclan/GeoLiteCity-data/raw/c14d99c42446f586e3ca9c89fe13714474921d65/GeoLiteCity.dat'
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
        copies = @(

        )
     }
}

# Send definitions down the pipeline
$VARIANTS
