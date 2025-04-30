param (
    [switch]$AvatarOnly,
    [switch]$PlaceholderOnly
)

$allFormats = @(
    "640x480", "800x600", "1024x768", "1280x720", "1280x800",
    "1366x768", "1440x900", "1600x900", "1920x1080", "2560x1440", "3840x2160",
    "500x500", "800x800", "1080x1080",
    "720x1280", "1080x1350", "1080x1920",
    "1200x628", "1080x566"
)

$avatarSizes = @(64, 128, 256, 512, 800)
$numImages = 10
$placeholderDir = "placeholders"
$avatarDir = "avatars"

function Get-Suffix {
    param ($format)
    $width, $height = $format -split 'x'
    if ($width -eq $height) {
        return "_square"
    } elseif ($width -lt $height) {
        return "_portrait"
    } else {
        return "_landscape"
    }
}

function Select-FormatProfile {
    Write-Host "`n📐 Select a format profile:" -ForegroundColor Cyan
    Write-Host "  1) Web (landscape)"
    Write-Host "  2) Mobile (portrait)"
    Write-Host "  3) Square"
    Write-Host "  4) All"
    Write-Host "  5) Manual selection"
    $choice = Read-Host "Enter your choice [1-5]"

    switch ($choice) {
        '1' {
            return @("640x480", "800x600", "1024x768", "1280x720", "1280x800",
                     "1366x768", "1440x900", "1600x900", "1920x1080")
        }
        '2' {
            return @("720x1280", "1080x1350", "1080x1920")
        }
        '3' {
            return @("500x500", "800x800", "1080x1080")
        }
        '4' {
            return $allFormats
        }
        '5' {
            Write-Host "`n📝 Manual selection:"
            for ($i = 0; $i -lt $allFormats.Count; $i++) {
                Write-Host "$($i + 1). $($allFormats[$i])"
            }
            $input = Read-Host "Enter format numbers (e.g. 1 5 9)"
            $indexes = $input -split '\\s+' | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^[0-9]+$' }
            $selected = @()
            foreach ($idx in $indexes) {
                $i = [int]$idx - 1
                if ($i -ge 0 -and $i -lt $allFormats.Count) {
                    $selected += $allFormats[$i]
                }
            }
            return $selected
        }
        default {
            Write-Host "❌ Invalid selection. Exiting." -ForegroundColor Red
            exit 1
        }
    }
}

function Download-Placeholders {
    param ([string[]]$formats)

    Write-Host "`n▶️ Downloading placeholder images..." -ForegroundColor Cyan

    foreach ($format in $formats) {
        $suffix = Get-Suffix $format
        $folder = Join-Path $placeholderDir "$format$suffix"
        New-Item -ItemType Directory -Path $folder -Force | Out-Null

        $width, $height = $format -split 'x'

        for ($i = 1; $i -le $numImages; $i++) {
            $random = Get-Random
            $url = "https://picsum.photos/"+$width+"/"+$height+"?random="+$random
            $output = Join-Path $folder "image_$i.jpg"
            Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing
        }

        Write-Host "📁 $folder : $numImages images downloaded."
    }
}

function Download-Avatars {
    Write-Host "`n▶️ Downloading avatars from Pravatar..." -ForegroundColor Cyan

    foreach ($size in $avatarSizes) {
        $folder = Join-Path $avatarDir "${size}x$size"
        New-Item -ItemType Directory -Path $folder -Force | Out-Null

        for ($i = 1; $i -le $numImages; $i++) {
            $random = Get-Random
            $url = "https://i.pravatar.cc/"+$size+"?u="+$random
            $output = Join-Path $folder "avatar_$i.jpg"
            Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing
        }

        Write-Host "📁 $folder : $numImages avatars downloaded."
    }
}

# === Main Execution Logic ===

if (-not $AvatarOnly) {
    $selectedFormats = Select-FormatProfile
}

if ($PlaceholderOnly) {
    Download-Placeholders -formats $selectedFormats
} elseif ($AvatarOnly) {
    Download-Avatars
} else {
    Download-Placeholders -formats $selectedFormats
    Download-Avatars
}

Write-Host "`n✅ All downloads completed." -ForegroundColor Green