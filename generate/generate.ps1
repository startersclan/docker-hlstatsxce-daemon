# This script generates the each Docker image variants' build context files' in ./variants/<variant>

$GENERATE_BASE_DIR = $PSScriptRoot
$GENERATE_TEMPLATES_DIR = Join-Path $GENERATE_BASE_DIR "templates"
$GENERATE_DEFINITIONS_DIR = Join-Path $GENERATE_BASE_DIR "definitions"
$PROJECT_BASE_DIR = Split-Path $GENERATE_BASE_DIR -Parent

$ErrorActionPreference = 'Stop'

cd $GENERATE_BASE_DIR

# Get variants' definition
$VARIANTS = & (Join-Path $GENERATE_DEFINITIONS_DIR "VARIANTS.ps1")

# Get files' definition
$FILES = &(Join-Path $GENERATE_DEFINITIONS_DIR "FILES.ps1")

function Get-ContentFromTemplate {
    param (
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path $_ })]
        [string]$Path
    ,
        [ValidateRange(1,100)]
        [int]$PrependNewLines
    )
    $content = & $Path
    if ($PrependNewLines -gt 0) {
        1..($PrependNewLine) | % {
            $content = "`n$content"
        }
    }
    $content
}

# Generate each Docker image variant's build context files
$VARIANTS | % {
    $VARIANT = $_
    $VARIANT_DIR = "$PROJECT_BASE_DIR/variants/$($VARIANT['name'])"

    "Generating variant of name $( $VARIANT['name'] ), variant dir: $VARIANT_DIR" | Write-Host -ForegroundColor Green
    if ( ! (Test-Path $VARIANT_DIR) ) {
        New-Item -Path $VARIANT_DIR -ItemType Directory -Force > $null
    }

    # Generate Dockerfile
    $content = & {
        $my_template_dir = if ( $VARIANT['distro'] ) { "$GENERATE_TEMPLATES_DIR/variants/$($VARIANT['distro'])" } else { "$GENERATE_TEMPLATES_DIR/variants" }
        Get-ContentFromTemplate -Path "$my_template_dir/Dockerfile.begin.ps1"
        $VARIANT['extensions'] | % {
            Get-ContentFromTemplate -Path "$my_template_dir/$_/$_.ps1" -PrependNewLines 2
        }
        Get-ContentFromTemplate -Path "$my_template_dir/Dockerfile.end.ps1" -PrependNewLines 2
    }
    $content | Out-File "$VARIANT_DIR/Dockerfile" -Encoding Utf8 -Force -NoNewline

    # Generate docker-entrypoint.sh
    if ( $VARIANT['includeEntrypointScript' ]) {
        Get-ContentFromTemplate -Path "$GENERATE_TEMPLATES_DIR/docker-entrypoint.sh.ps1" | Out-File "$VARIANT_DIR/docker-entrypoint.sh" -Encoding Utf8 -Force -NoNewline
    }
}

# Generate other repo files
$FILES | % {
    # Generate README.md
    Get-ContentFromTemplate -Path (Join-Path $GENERATE_TEMPLATES_DIR "$_.ps1") | Out-File (Join-Path $PROJECT_BASE_DIR $_) -Encoding utf8 -NoNewline
}